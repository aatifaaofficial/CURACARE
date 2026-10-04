import 'package:flutter/material.dart';

import '../../models/health_record.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key, this.initialFormOpen = false});

  final bool initialFormOpen;

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  bool _loading = true;
  List<HealthRecord> _records = [];
  late final TextEditingController _dateController;
  late final TextEditingController _temperatureController;
  late final TextEditingController _weightController;
  late final TextEditingController _sleepController;
  late final TextEditingController _notesController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _energy = 'Good';
  String _mood = 'Calm';
  double _painValue = 3;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _temperatureController = TextEditingController();
    _weightController = TextEditingController();
    _sleepController = TextEditingController();
    _notesController = TextEditingController();
    _loadRecords();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _temperatureController.dispose();
    _weightController.dispose();
    _sleepController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadRecords() async {
    final records = await StorageService.instance.getHealthRecords();
    if (!mounted) return;
    setState(() {
      _records = records;
      _loading = false;
    });
    if (widget.initialFormOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openForm());
    }
  }

  Future<void> _saveRecord({HealthRecord? existing}) async {
    if (!_formKey.currentState!.validate()) return;

    final record = (existing ?? HealthRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: _dateController.text.trim(),
      painLevel: _painValue.round(),
      temperature: double.tryParse(_temperatureController.text.trim()) ?? 98.4,
      weight: double.tryParse(_weightController.text.trim()) ?? 62,
      energy: _energy,
      mood: _mood,
      sleepHours: int.tryParse(_sleepController.text.trim()) ?? 7,
      notes: _notesController.text.trim(),
    )).copyWith(
      date: _dateController.text.trim(),
      painLevel: _painValue.round(),
      temperature: double.tryParse(_temperatureController.text.trim()) ?? 98.4,
      weight: double.tryParse(_weightController.text.trim()) ?? 62,
      energy: _energy,
      mood: _mood,
      sleepHours: int.tryParse(_sleepController.text.trim()) ?? 7,
      notes: _notesController.text.trim(),
    );

    final updated = [..._records];
    final index = updated.indexWhere((item) => item.id == record.id);
    if (index >= 0) {
      updated[index] = record;
    } else {
      updated.insert(0, record);
    }

    await StorageService.instance.saveHealthRecords(updated);
    if (!mounted) return;
    setState(() => _records = updated);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved successfully')),
    );
  }

  Future<void> _deleteRecord(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete health record?'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed != true) return;
    final updated = _records.where((item) => item.id != id).toList();
    await StorageService.instance.saveHealthRecords(updated);
    if (!mounted) return;
    setState(() => _records = updated);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Record deleted')),
    );
  }

  void _openForm({HealthRecord? record}) {
    _dateController.text = record?.date ?? DateTime.now().toIso8601String().split('T').first;
    _temperatureController.text = (record?.temperature ?? 98.4).toString();
    _weightController.text = (record?.weight ?? 62).toString();
    _sleepController.text = (record?.sleepHours ?? 7).toString();
    _notesController.text = record?.notes ?? '';
    _painValue = (record?.painLevel ?? 3).toDouble();
    _energy = record?.energy ?? 'Good';
    _mood = record?.mood ?? 'Calm';

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
                      Text(record == null ? 'Add Health Record' : 'Edit Health Record', style: Theme.of(context).textTheme.titleLarge),
                      IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(labelText: 'Date', hintText: 'YYYY-MM-DD'),
                    validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter a date.' : null,
                  ),
                  const SizedBox(height: 12),
                  Text('Pain Level: ${_painValue.round()}/10', style: const TextStyle(fontWeight: FontWeight.w600)),
                  Slider(
                    value: _painValue,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    onChanged: (value) => setState(() => _painValue = value),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _temperatureController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Temperature (°F)'),
                    validator: (value) => (value == null || value.trim().isEmpty) ? 'Temperature is required.' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Weight (kg)'),
                    validator: (value) => (value == null || value.trim().isEmpty) ? 'Weight is required.' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _energy,
                    decoration: const InputDecoration(labelText: 'Energy'),
                    items: ['Low', 'Average', 'Good', 'Excellent']
                        .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                        .toList(),
                    onChanged: (value) => setState(() => _energy = value ?? 'Good'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _mood,
                    decoration: const InputDecoration(labelText: 'Mood'),
                    items: ['Happy', 'Calm', 'Okay', 'Sad', 'Stressed']
                        .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                        .toList(),
                    onChanged: (value) => setState(() => _mood = value ?? 'Calm'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _sleepController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Sleep Hours'),
                    validator: (value) => (value == null || value.trim().isEmpty) ? 'Sleep hours are required.' : null,
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
                      onPressed: () => _saveRecord(existing: record),
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

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Monitoring'),
        actions: [
          IconButton(
            onPressed: () => _openForm(),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SectionHeader(title: 'Today’s Summary'),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                StatCard(title: 'Pain Level', value: '${_records.firstOrNull?.painLevel ?? 3} / 10', icon: Icons.sentiment_satisfied_alt_outlined, color: AppTheme.purple),
                StatCard(title: 'Temperature', value: '${_records.firstOrNull?.temperature ?? 98.4}°F', icon: Icons.thermostat_outlined, color: AppTheme.coral),
                StatCard(title: 'Weight', value: '${_records.firstOrNull?.weight ?? 62} kg', icon: Icons.monitor_weight_outlined, color: AppTheme.blue),
                StatCard(title: 'Energy', value: _records.firstOrNull?.energy ?? 'Good', icon: Icons.bolt_outlined, color: AppTheme.teal),
                StatCard(title: 'Mood', value: _records.firstOrNull?.mood ?? 'Calm', icon: Icons.mood_outlined, color: AppTheme.blue),
                StatCard(title: 'Sleep', value: '${_records.firstOrNull?.sleepHours ?? 7} hours', icon: Icons.bedtime_outlined, color: AppTheme.purple),
              ],
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Health History'),
            const SizedBox(height: 12),
            if (_records.isEmpty)
              EmptyState(
                title: 'No health records yet.',
                subtitle: 'Keep track of pain, temperature, weight, energy and mood.',
                actionLabel: 'Add Health',
                onAction: () => _openForm(),
              )
            else
              ..._records.map((record) => Container(
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
                        Text(record.date, style: const TextStyle(fontWeight: FontWeight.w800)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.blue.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('${record.painLevel}/10 pain', style: const TextStyle(fontSize: 11, color: AppTheme.blue, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _HealthChip(label: 'Temperature', value: '${record.temperature}°F'),
                        _HealthChip(label: 'Weight', value: '${record.weight} kg'),
                        _HealthChip(label: 'Energy', value: record.energy),
                        _HealthChip(label: 'Mood', value: record.mood),
                        _HealthChip(label: 'Sleep', value: '${record.sleepHours} hrs'),
                      ],
                    ),
                    if (record.notes.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(record.notes, style: const TextStyle(color: AppTheme.muted)),
                    ],
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        TextButton.icon(onPressed: () => _openForm(record: record), icon: const Icon(Icons.edit_outlined), label: const Text('Edit')),
                        TextButton.icon(onPressed: () => _deleteRecord(record.id), icon: const Icon(Icons.delete_outline), label: const Text('Delete')),
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

class _HealthChip extends StatelessWidget {
  const _HealthChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text('$label: $value', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.ink)),
    );
  }
}

extension on List<HealthRecord> {
  HealthRecord? get firstOrNull => isEmpty ? null : first;
}
