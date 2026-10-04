import 'package:flutter/material.dart';

import '../../models/app_notification.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<AppNotificationItem> _notifications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final notifications = await StorageService.instance.getNotifications();
    if (!mounted) return;
    setState(() {
      _notifications = notifications;
      _loading = false;
    });
  }

  Future<void> _markRead(String id) async {
    final updated = _notifications.map((item) {
      if (item.id == id) return item.copyWith(read: true);
      return item;
    }).toList();
    await StorageService.instance.saveNotifications(updated);
    if (!mounted) return;
    setState(() => _notifications = updated);
  }

  Future<void> _markAllRead() async {
    final updated = _notifications.map((item) => item.copyWith(read: true)).toList();
    await StorageService.instance.saveNotifications(updated);
    if (!mounted) return;
    setState(() => _notifications = updated);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All notifications marked as read')));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(onPressed: _markAllRead, child: const Text('Mark all as read')),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: _notifications.isEmpty
              ? [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Text('No notifications available.', style: TextStyle(color: AppTheme.muted)),
                    ),
                  )
                ]
              : _notifications.map((item) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: item.read ? Colors.white : const Color(0xFFF5F8FF),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: item.read ? Colors.transparent : AppTheme.blue.withValues(alpha: 0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w800))),
                          if (!item.read)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.coral.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text('New', style: TextStyle(fontSize: 11, color: AppTheme.coral, fontWeight: FontWeight.w700)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(item.description, style: const TextStyle(color: AppTheme.muted)),
                      const SizedBox(height: 8),
                      Text('${item.date} • ${item.time}', style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
                      const SizedBox(height: 10),
                      if (!item.read)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => _markRead(item.id),
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Mark as Read'),
                          ),
                        ),
                    ],
                  ),
                )).toList(),
        ),
      ),
    );
  }
}
