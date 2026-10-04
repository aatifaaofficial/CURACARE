import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About CancerCare')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            Text('CancerCare', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: AppTheme.ink)),
            SizedBox(height: 6),
            Text('Track. Care. Support.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.blue)),
            SizedBox(height: 16),
            Text(
              'CancerCare is a supportive application designed to help patients and caregivers organize treatment, medications, symptoms, appointments, reports and daily health information.',
              style: TextStyle(color: AppTheme.muted),
            ),
            SizedBox(height: 20),
            ListTile(leading: Icon(Icons.info_outline), title: Text('Version'), trailing: Text('1.0.0')),
            ListTile(leading: Icon(Icons.app_shortcut_outlined), title: Text('Project Information'), trailing: Text('CancerCare')),
            SizedBox(height: 16),
            Text(
              'CancerCare is a supportive tracking application and does not replace professional medical advice, diagnosis, or treatment.',
              style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.ink),
            ),
          ],
        ),
      ),
    );
  }
}
