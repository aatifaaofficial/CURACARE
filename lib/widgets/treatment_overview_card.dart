import 'package:flutter/material.dart';

import '../models/treatment.dart';
import '../theme/app_theme.dart';

class TreatmentOverviewCard extends StatelessWidget {
  const TreatmentOverviewCard({super.key, required this.treatment, required this.onViewTreatment});

  final Treatment treatment;
  final VoidCallback onViewTreatment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF286CC5), Color(0xFF4B91E4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppTheme.blue.withValues(alpha: 0.22), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Treatment Overview', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.16), shape: BoxShape.circle),
                child: const Icon(Icons.medical_services_outlined, color: Colors.white, size: 19),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _Detail(label: 'Treatment Type', value: treatment.type)),
              Expanded(child: _Detail(label: 'Current Cycle', value: '${treatment.currentCycle} of ${treatment.totalCycles}')),
              Expanded(child: _Detail(label: 'Next Session', value: treatment.nextSession)),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${(treatment.progress * 100).round()}% complete', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
              Text('${treatment.currentCycle} / ${treatment.totalCycles} cycles', style: TextStyle(color: Colors.white.withValues(alpha: 0.82), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(value: treatment.progress.clamp(0, 1), minHeight: 8, backgroundColor: const Color(0x4DFFFFFF), valueColor: const AlwaysStoppedAnimation(Colors.white)),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onViewTreatment,
              style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppTheme.blue, padding: const EdgeInsets.symmetric(vertical: 13)),
              child: const Text('View Treatment'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.72), fontSize: 10)),
      const SizedBox(height: 5),
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
    ]);
  }
}
