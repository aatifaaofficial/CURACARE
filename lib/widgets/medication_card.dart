import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class MedicationCard extends StatelessWidget {
  const MedicationCard({super.key, required this.name, required this.time, required this.status, required this.isTaken, required this.onCheck});

  final String name;
  final String time;
  final String status;
  final bool isTaken;
  final VoidCallback onCheck;

  @override
  Widget build(BuildContext context) {
    final statusColor = isTaken ? AppTheme.teal : AppTheme.blue;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), boxShadow: const [BoxShadow(color: Color(0x0919324D), blurRadius: 12, offset: Offset(0, 4))]),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.11), shape: BoxShape.circle), child: Icon(Icons.medication_outlined, color: statusColor, size: 20)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)), const SizedBox(height: 4), Text(time, style: const TextStyle(color: AppTheme.muted, fontSize: 12))])),
        Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6), decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(20)), child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w700))),
        const SizedBox(width: 5),
        IconButton(onPressed: onCheck, tooltip: isTaken ? 'Marked as taken' : 'Mark as taken', icon: Icon(isTaken ? Icons.check_circle : Icons.radio_button_unchecked, color: isTaken ? AppTheme.teal : AppTheme.muted)),
      ]),
    );
  }
}
