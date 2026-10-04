import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    this.doctorName = 'Dr. Michael Anderson',
    this.hospital = 'Oncology Specialist',
    this.date = '28 September',
    this.time = '10:30 AM',
    required this.onViewDetails,
  });

  final String doctorName;
  final String hospital;
  final String date;
  final String time;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFEAF7F5), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.teal.withValues(alpha: 0.16))),
      child: Row(children: [
        Container(width: 52, height: 52, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.person_outline, color: AppTheme.teal, size: 30)),
        const SizedBox(width: 13),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(doctorName, style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.ink)),
          const SizedBox(height: 4),
          Text(hospital, style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
          const SizedBox(height: 9),
          Row(children: [
            const Icon(Icons.calendar_today_outlined, size: 13, color: AppTheme.teal),
            const SizedBox(width: 5),
            Text(date, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            const SizedBox(width: 10),
            const Icon(Icons.schedule_outlined, size: 13, color: AppTheme.teal),
            const SizedBox(width: 5),
            Text(time, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ]),
        ])),
        IconButton(onPressed: onViewDetails, tooltip: 'View appointment details', icon: const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.teal)),
      ]),
    );
  }
}
