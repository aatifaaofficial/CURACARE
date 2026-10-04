import 'package:flutter/material.dart';

class HealthSummaryCard extends StatelessWidget {
  const HealthSummaryCard({super.key, required this.title, required this.value, required this.icon, required this.color, required this.note});

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.10)),
        boxShadow: const [BoxShadow(color: Color(0x0A19324D), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, color: color, size: 18),
          const Spacer(),
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        ]),
        const Spacer(),
        Text(title, style: const TextStyle(fontSize: 11, color: Color(0xFF728097))),
        const SizedBox(height: 3),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF213047))),
        const SizedBox(height: 2),
        Text(note, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}
