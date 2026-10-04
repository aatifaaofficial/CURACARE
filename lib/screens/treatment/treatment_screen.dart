import 'package:flutter/material.dart';

import '../../models/treatment.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class TreatmentScreen extends StatefulWidget {
  const TreatmentScreen({super.key});

  @override
  State<TreatmentScreen> createState() => _TreatmentScreenState();
}

class _TreatmentScreenState extends State<TreatmentScreen> {
  Treatment? _treatment;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTreatment();
  }

  Future<void> _loadTreatment() async {
    final treatment = await StorageService.instance.getTreatment();
    if (!mounted) return;
    setState(() {
      _treatment = treatment;
      _loading = false;
    });
  }

  Future<void> _showCycleDetails(TreatmentCycle cycle) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cycle ${cycle.cycleNumber}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${cycle.date}'),
            const SizedBox(height: 8),
            Text('Status: ${cycle.status}'),
            const SizedBox(height: 8),
            Text('Notes: ${cycle.notes.isEmpty ? 'No notes provided.' : cycle.notes}'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Close')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Update')),
        ],
      ),
    );

    if (result == true && _treatment != null) {
      final updated = _treatment!.cycles.map((item) {
        if (item.cycleNumber == cycle.cycleNumber) {
          return item.copyWith(status: item.status == 'Completed' ? 'Upcoming' : 'Completed', notes: item.notes.isEmpty ? 'Reviewed and updated.' : item.notes);
        }
        return item;
      }).toList();

      final completedCycles = updated.where((item) => item.status == 'Completed').length;
      final nextCycle = updated.where((item) => item.status != 'Completed').firstOrNull;
      final updatedTreatment = _treatment!.copyWith(
        cycles: updated,
        currentCycle: nextCycle?.cycleNumber ?? _treatment!.totalCycles,
        progress: _treatment!.totalCycles > 0 ? completedCycles / _treatment!.totalCycles : 0,
        nextSession: nextCycle?.date ?? _treatment!.nextSession,
      );
      await StorageService.instance.saveTreatment(updatedTreatment);
      if (!mounted) return;
      setState(() => _treatment = updatedTreatment);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Treatment cycle updated.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _treatment == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final treatment = _treatment!;
    return Scaffold(
      appBar: AppBar(title: const Text('Treatment')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppTheme.blue, AppTheme.teal], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Current Treatment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                  const SizedBox(height: 14),
                  _InfoRow(label: 'Treatment Type', value: treatment.type),
                  _InfoRow(label: 'Doctor', value: treatment.doctorName),
                  _InfoRow(label: 'Hospital', value: treatment.hospital),
                  _InfoRow(label: 'Start Date', value: treatment.startDate),
                  _InfoRow(label: 'Current Cycle', value: '${treatment.currentCycle} of ${treatment.totalCycles}'),
                  _InfoRow(label: 'Next Session', value: treatment.nextSession),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Progress', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      Text('${(treatment.progress * 100).round()}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: treatment.progress,
                      minHeight: 8,
                      backgroundColor: Colors.white.withValues(alpha: 0.25),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Treatment Timeline'),
            const SizedBox(height: 12),
            ...treatment.cycles.map((cycle) => GestureDetector(
              onTap: () => _showCycleDetails(cycle),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cycle.status == 'Completed' ? AppTheme.teal.withValues(alpha: 0.2) : AppTheme.muted.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: cycle.status == 'Completed' ? AppTheme.teal.withValues(alpha: 0.12) : AppTheme.blue.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        cycle.status == 'Completed' ? Icons.check : Icons.pending,
                        color: cycle.status == 'Completed' ? AppTheme.teal : AppTheme.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cycle ${cycle.cycleNumber}', style: const TextStyle(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text(cycle.date, style: const TextStyle(color: AppTheme.muted)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: cycle.status == 'Completed' ? AppTheme.teal.withValues(alpha: 0.12) : AppTheme.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(cycle.status, style: TextStyle(fontSize: 11, color: cycle.status == 'Completed' ? AppTheme.teal : AppTheme.blue, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
