import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 56, color: AppTheme.blue),
        const SizedBox(height: 16),
        Text('$title space', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        const Text('This area is ready for your tracking and organization tools.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.muted)),
      ]))),
    );
  }
}
