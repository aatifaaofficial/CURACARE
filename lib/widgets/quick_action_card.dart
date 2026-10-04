import 'package:flutter/material.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({super.key, required this.label, required this.icon, required this.color, required this.onTap});

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: color.withValues(alpha: 0.12)), boxShadow: const [BoxShadow(color: Color(0x0719324D), blurRadius: 9, offset: Offset(0, 3))]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(padding: const EdgeInsets.all(9), decoration: BoxDecoration(color: color.withValues(alpha: 0.11), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 21)),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF213047))),
          ]),
        ),
      ),
    );
  }
}
