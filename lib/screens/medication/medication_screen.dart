import 'package:flutter/material.dart';

import '../../models/medication.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({super.key});

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  List<Medication> _medications = [];
  bool _loading = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _timeController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _instructionsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadMedications() async {
    final medications = await StorageService.instance.getMedications();
    if (!mounted) return;
    setState(() {
      _medications = medications;
      _loading = false;
    });
  }

  void _openForm({Medication? medication}) {
    _nameController.text = medication?.name ?? '';
    _dosageController.text = medication?.dosage ?? '';
    _frequencyController.text = medication?.frequency ?? '';
    _timeController.text = medication?.time ?? '08:00';
    _startDateController.text = medication?.startDate ?? DateTime.now().toIso8601String().split('T').first;
    _endDateController.text = medication?.endDate ?? DateTime.now().toIso8601String().split('T').first;
    _instructionsController.text = medication?.instructions ?? '';
    _notesController.text = medication?.notes ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(medication == null ? 'Add Medication' : 'Edit Medication', style: Theme.of(context).textTheme.titleLarge),
                      IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Medicine Name'), validator: (value) => (value == null || value.trim().isEmpty) ? 'Medicine name is required.' : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _dosageController, decoration: const InputDecoration(labelText: 'Dosage'), validator: (value) => (value == null || value.trim().isEmpty) ? 'Dosage is required.' : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _frequencyController, decoration: const InputDecoration(labelText: 'Frequency'), validator: (value) => (value == null || value.trim().isEmpty) ? 'Frequency is required.' : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _timeController, decoration: const InputDecoration(labelText: 'Time'), validator: (value) => (value == null || value.trim().isEmpty) ? 'Time is required.' : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _startDateController, decoration: const InputDecoration(labelText: 'Start Date'), validator: (value) => (value == null || value.trim().isEmpty) ? 'Start date is required.' : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _endDateController, decoration: const InputDecoration(labelText: 'End Date'), validator: (value) => (value == null || value.trim().isEmpty) ? 'End date is required.' : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _instructionsController, decoration: const InputDecoration(labelText: 'Instructions'), maxLines: 2),
                  const SizedBox(height: 12),
                  TextFormField(controller: _notesController, decoration: const InputDecoration(labelText: 'Notes'), maxLines: 2),
                  const SizedBox(height: 20),
                  SizedBox(width: double.infinity, child: FilledButton(onPressed: () => _saveMedication(medication), child: const Text('Save'))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveMedication(Medication? medication) async {
    if (!_formKey.currentState!.validate()) return;

    final item = (medication ?? Medication(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      dosage: _dosageController.text.trim(),
      frequency: _frequencyController.text.trim(),
      time: _timeController.text.trim(),
      startDate: _startDateController.text.trim(),
      endDate: _endDateController.text.trim(),
      instructions: _instructionsController.text.trim(),
      notes: _notesController.text.trim(),
      status: 'Upcoming',
    )).copyWith(
      name: _nameController.text.trim(),
      dosage: _dosageController.text.trim(),
      frequency: _frequencyController.text.trim(),
      time: _timeController.text.trim(),
      startDate: _startDateController.text.trim(),
      endDate: _endDateController.text.trim(),
      instructions: _instructionsController.text.trim(),
      notes: _notesController.text.trim(),
    );

    final updated = [..._medications];
    final index = updated.indexWhere((element) => element.id == item.id);
    if (index >= 0) {
      updated[index] = item;
    } else {
      updated.insert(0, item);
    }

    await StorageService.instance.saveMedications(updated);
    if (!mounted) return;
    setState(() => _medications = updated);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved successfully')));
  }

  Future<void> _deleteMedication(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete medication?'),
        content: const Text('Are you sure you want to delete this medication?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed != true) return;
    final updated = _medications.where((item) => item.id != id).toList();
    await StorageService.instance.saveMedications(updated);
    if (!mounted) return;
    setState(() => _medications = updated);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Medication deleted')));
  }

  Future<void> _updateStatus(Medication medication, String status) async {
    final updated = _medications.map((item) {
      if (item.id == medication.id) {
        return item.copyWith(status: status);
      }
      return item;
    }).toList();

    await StorageService.instance.saveMedications(updated);
    if (!mounted) return;
    setState(() => _medications = updated);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Marked as $status')));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Management'),
        actions: [
          IconButton(onPressed: () => _openForm(), icon: const Icon(Icons.add_circle_outline)),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SectionHeader(title: 'Today’s Medication'),
            const SizedBox(height: 12),
            if (_medications.isEmpty)
              EmptyState(
                title: 'No medications yet.',
                subtitle: 'Add medication reminders and track doses.',
                actionLabel: 'Add Medication',
                onAction: () => _openForm(),
              )
            else
              ..._medications.map((medication) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [BoxShadow(color: Color(0x0B19324D), blurRadius: 12, offset: Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(medication.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: medication.status == 'Taken' ? AppTheme.teal.withValues(alpha: 0.12) : AppTheme.blue.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(medication.status, style: TextStyle(fontSize: 11, color: medication.status == 'Taken' ? AppTheme.teal : AppTheme.blue, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('${medication.dosage} • ${medication.frequency}', style: const TextStyle(color: AppTheme.muted)),
                    const SizedBox(height: 4),
                    Text('${medication.time} • ${medication.startDate} to ${medication.endDate}', style: const TextStyle(color: AppTheme.muted)),
                    if (medication.instructions.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(medication.instructions, style: const TextStyle(color: AppTheme.muted)),
                    ],
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton.tonal(onPressed: () => _updateStatus(medication, 'Taken'), child: const Text('Mark as Taken')),
                        FilledButton.tonal(onPressed: () => _updateStatus(medication, 'Missed'), child: const Text('Mark as Missed')),
                        TextButton.icon(onPressed: () => _openForm(medication: medication), icon: const Icon(Icons.edit_outlined), label: const Text('Edit')),
                        TextButton.icon(onPressed: () => _deleteMedication(medication.id), icon: const Icon(Icons.delete_outline), label: const Text('Delete')),
                      ],
                    ),
                  ],
                ),
              )),
          ],
        ),
      ),
    );
  }
}
