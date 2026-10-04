import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class EmergencyCard extends StatelessWidget {
  const EmergencyCard({super.key, required this.emergencyContact, required this.onEmergencyHelp});

  final String emergencyContact;
  final VoidCallback onEmergencyHelp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: const Color(0xFFFFF2F0), borderRadius: BorderRadius.circular(22), border: Border.all(color: AppTheme.coral.withValues(alpha: 0.18))),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppTheme.coral.withValues(alpha: 0.13), shape: BoxShape.circle), child: const Icon(Icons.support_agent, color: AppTheme.coral, size: 26)),
        const SizedBox(width: 13),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Need Urgent Help?', style: TextStyle(fontWeight: FontWeight.w800, color: AppTheme.ink, fontSize: 15)), const SizedBox(height: 4), const Text('Quickly contact your emergency support.', style: TextStyle(color: AppTheme.muted, fontSize: 11)), const SizedBox(height: 8), Text('Emergency Contact  •  $emergencyContact', style: const TextStyle(color: AppTheme.coral, fontSize: 11, fontWeight: FontWeight.w700))])),
        FilledButton(onPressed: onEmergencyHelp, style: FilledButton.styleFrom(backgroundColor: AppTheme.coral, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11), minimumSize: const Size(0, 42)), child: const Text('Emergency Help', textAlign: TextAlign.center, style: TextStyle(fontSize: 11))),
      ]),
    );
  }
}
