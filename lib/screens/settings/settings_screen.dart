import 'package:flutter/material.dart';

import '../../models/app_settings.dart';
import '../about/about_screen.dart';
import '../../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AppSettings _settings = const AppSettings(
    notifications: true,
    medicationReminders: true,
    appointmentReminders: true,
    treatmentReminders: true,
    darkMode: false,
    language: 'English',
    privacyAccepted: true,
  );
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await StorageService.instance.getSettings();
    if (!mounted) return;
    setState(() {
      _settings = settings;
      _loading = false;
    });
  }

  Future<void> _saveSettings(AppSettings updated) async {
    await StorageService.instance.saveSettings(updated);
    if (!mounted) return;
    setState(() => _settings = updated);
  }

  Future<void> _showPrivacyInformation() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy'),
        content: const Text('CancerCare stores your profile and tracking records locally on this device. Anyone with access to this device may be able to view them. This app does not replace professional medical advice.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SwitchListTile(
              value: _settings.notifications,
              onChanged: (value) => _saveSettings(_settings.copyWith(notifications: value)),
              title: const Text('Notifications'),
            ),
            SwitchListTile(
              value: _settings.medicationReminders,
              onChanged: (value) => _saveSettings(_settings.copyWith(medicationReminders: value)),
              title: const Text('Medication Reminders'),
            ),
            SwitchListTile(
              value: _settings.appointmentReminders,
              onChanged: (value) => _saveSettings(_settings.copyWith(appointmentReminders: value)),
              title: const Text('Appointment Reminders'),
            ),
            SwitchListTile(
              value: _settings.treatmentReminders,
              onChanged: (value) => _saveSettings(_settings.copyWith(treatmentReminders: value)),
              title: const Text('Treatment Reminders'),
            ),
            SwitchListTile(
              value: _settings.darkMode,
              onChanged: (value) => _saveSettings(_settings.copyWith(darkMode: value)),
              title: const Text('Dark Mode'),
            ),
            ListTile(
              title: const Text('Language'),
              trailing: Text(_settings.language),
              onTap: () async {
                final result = await showDialog<String>(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: const Text('Select Language'),
                    children: ['English', 'Hindi', 'Spanish']
                        .map((language) => SimpleDialogOption(
                              onPressed: () => Navigator.pop(context, language),
                              child: Text(language),
                            ))
                        .toList(),
                  ),
                );
                if (result == null) return;
                await _saveSettings(_settings.copyWith(language: result));
              },
            ),
            ListTile(
              title: Text('Privacy'),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: _showPrivacyInformation,
            ),
            ListTile(
              title: Text('About CancerCare'),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen())),
            ),
          ],
        ),
      ),
    );
  }
}
