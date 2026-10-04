import 'package:flutter/material.dart';

import '../../models/symptom.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class SymptomScreen extends StatefulWidget {
  const SymptomScreen({super.key, this.initialAddMode = false});

  final bool initialAddMode;

  @override
  State<SymptomScreen> createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomScreen> {
  List<Symptom> _symptoms = [];
  bool _loading = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _severity = 'Mild';
  String _selectedSymptom = 'Fatigue';
  final List<String> _symptomOptions = [
    'Nausea',
    'Fatigue',
    'Headache',
    'Pain',
    'Dizziness',
    'Loss of Appetite',
    'Vomiting',
    'Fever',
    'Weakness',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadSymptoms();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadSymptoms() async {
    final symptoms = await StorageService.instance.getSymptoms();
    if (!mounted) return;
    setState(() {
      _symptoms = symptoms;
      _loading = false;
    });
    if (widget.initialAddMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openForm());
    }
  }

  void _openForm({Symptom? symptom}) {
    _selectedSymptom = symptom?.name ?? _symptomOptions.first;
    _severity = symptom?.severity ?? 'Mild';
    _nameController.text = symptom?.name ?? '';
    _dateController.text = symptom?.date ?? DateTime.now().toIso8601String().split('T').first;
    _timeController.text = symptom?.time ?? '09:00';
    _notesController.text = symptom?.notes ?? '';

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
                      Text(symptom == null ? 'Add Symptom' : 'Edit Symptom', style: Theme.of(context).textTheme.titleLarge),
                      IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedSymptom,
                    decoration: const InputDecoration(labelText: 'Symptom'),
                    items: _symptomOptions.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSymptom = value ?? 'Fatigue';
                        _nameController.text = _selectedSymptom;
                      });
                    },
                    validator: (value) => (value == null || value.trim().isEmpty) ? 'Select a symptom.' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _severity,
                    decoration: const InputDecoration(labelText: 'Severity'),
                    items: ['Mild', 'Moderate', 'Severe']
                        .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                        .toList(),
                    onChanged: (value) => setState(() => _severity = value ?? 'Mild'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(labelText: 'Date'),
                    validator: (value) => (value == null || value.trim().isEmpty) ? 'Date is required.' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _timeController,
                    decoration: const InputDecoration(labelText: 'Time'),
                    validator: (value) => (value == null || value.trim().isEmpty) ? 'Time is required.' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Notes'),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => _saveSymptom(symptom: symptom),
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveSymptom({Symptom? symptom}) async {
    if (!_formKey.currentState!.validate()) return;

    final item = (symptom ?? Symptom(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _selectedSymptom,
      severity: _severity,
      date: _dateController.text.trim(),
      time: _timeController.text.trim(),
      notes: _notesController.text.trim(),
    )).copyWith(
      name: _selectedSymptom,
      severity: _severity,
      date: _dateController.text.trim(),
      time: _timeController.text.trim(),
      notes: _notesController.text.trim(),
    );

    final updated = [..._symptoms];
    final index = updated.indexWhere((element) => element.id == item.id);
    if (index >= 0) {
      updated[index] = item;
    } else {
      updated.insert(0, item);
    }

    await StorageService.instance.saveSymptoms(updated);
    if (!mounted) return;
    setState(() => _symptoms = updated);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved successfully')));
  }

  Future<void> _deleteSymptom(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete symptom?'),
        content: const Text('Are you sure you want to delete this symptom record?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed != true) return;
    final updated = _symptoms.where((item) => item.id != id).toList();
    await StorageService.instance.saveSymptoms(updated);
    if (!mounted) return;
    setState(() => _symptoms = updated);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Symptom deleted')));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptom Monitoring'),
        actions: [
          IconButton(onPressed: () => _openForm(), icon: const Icon(Icons.add_circle_outline)),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SectionHeader(title: 'Recent Symptoms'),
            const SizedBox(height: 12),
            if (_symptoms.isEmpty)
              EmptyState(
                title: 'No symptoms recorded yet.',
                subtitle: 'Track nausea, fatigue, pain, dizziness and other symptoms.',
                actionLabel: 'Add Symptom',
                onAction: () => _openForm(),
              )
            else
              ..._symptoms.map((symptom) => Container(
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
                        Text(symptom.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _severityColor(symptom.severity).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(symptom.severity, style: TextStyle(fontSize: 11, color: _severityColor(symptom.severity), fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('${symptom.date} • ${symptom.time}', style: const TextStyle(color: AppTheme.muted)),
                    if (symptom.notes.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(symptom.notes, style: const TextStyle(color: AppTheme.muted)),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        TextButton.icon(onPressed: () => _openForm(symptom: symptom), icon: const Icon(Icons.edit_outlined), label: const Text('Edit')),
                        TextButton.icon(onPressed: () => _deleteSymptom(symptom.id), icon: const Icon(Icons.delete_outline), label: const Text('Delete')),
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

  Color _severityColor(String severity) {
    switch (severity) {
      case 'Severe':
        return AppTheme.coral;
      case 'Moderate':
        return AppTheme.purple;
      default:
        return AppTheme.teal;
    }
  }
}
