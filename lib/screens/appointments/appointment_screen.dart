import 'package:flutter/material.dart';

import '../../models/appointment.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  List<Appointment> _appointments = [];
  bool _loading = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _doctorController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String _type = 'Doctor Visit';

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  @override
  void dispose() {
    _doctorController.dispose();
    _hospitalController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadAppointments() async {
    final appointments = await StorageService.instance.getAppointments();
    if (!mounted) return;
    setState(() {
      _appointments = appointments;
      _loading = false;
    });
  }

  void _openForm({Appointment? appointment}) {
    _doctorController.text = appointment?.doctorName ?? '';
    _hospitalController.text = appointment?.hospital ?? '';
    _dateController.text = appointment?.date ?? DateTime.now().toIso8601String().split('T').first;
    _timeController.text = appointment?.time ?? '10:30';
    _notesController.text = appointment?.notes ?? '';
    _type = appointment?.type ?? 'Doctor Visit';

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
                      Text(appointment == null ? 'Add Appointment' : 'Edit Appointment', style: Theme.of(context).textTheme.titleLarge),
                      IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(controller: _doctorController, decoration: const InputDecoration(labelText: 'Doctor Name'), validator: (value) => (value == null || value.trim().isEmpty) ? 'Doctor name is required.' : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _hospitalController, decoration: const InputDecoration(labelText: 'Hospital/Clinic'), validator: (value) => (value == null || value.trim().isEmpty) ? 'Hospital/clinic is required.' : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _dateController, decoration: const InputDecoration(labelText: 'Date'), validator: (value) => (value == null || value.trim().isEmpty) ? 'Date is required.' : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _timeController, decoration: const InputDecoration(labelText: 'Time'), validator: (value) => (value == null || value.trim().isEmpty) ? 'Time is required.' : null),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _type,
                    decoration: const InputDecoration(labelText: 'Appointment Type'),
                    items: ['Doctor Visit', 'Treatment', 'Follow-up', 'Test', 'Other']
                        .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                        .toList(),
                    onChanged: (value) => setState(() => _type = value ?? 'Doctor Visit'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(controller: _notesController, maxLines: 3, decoration: const InputDecoration(labelText: 'Notes')),
                  const SizedBox(height: 20),
                  SizedBox(width: double.infinity, child: FilledButton(onPressed: () => _saveAppointment(appointment), child: const Text('Save'))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveAppointment(Appointment? appointment) async {
    if (!_formKey.currentState!.validate()) return;

    final item = (appointment ?? Appointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      doctorName: _doctorController.text.trim(),
      hospital: _hospitalController.text.trim(),
      date: _dateController.text.trim(),
      time: _timeController.text.trim(),
      type: _type,
      notes: _notesController.text.trim(),
      isCompleted: false,
    )).copyWith(
      doctorName: _doctorController.text.trim(),
      hospital: _hospitalController.text.trim(),
      date: _dateController.text.trim(),
      time: _timeController.text.trim(),
      type: _type,
      notes: _notesController.text.trim(),
    );

    final updated = [..._appointments];
    final index = updated.indexWhere((element) => element.id == item.id);
    if (index >= 0) {
      updated[index] = item;
    } else {
      updated.insert(0, item);
    }

    await StorageService.instance.saveAppointments(updated);
    if (!mounted) return;
    setState(() => _appointments = updated);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved successfully')));
  }

  Future<void> _deleteAppointment(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete appointment?'),
        content: const Text('Are you sure you want to delete this appointment?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed != true) return;
    final updated = _appointments.where((item) => item.id != id).toList();
    await StorageService.instance.saveAppointments(updated);
    if (!mounted) return;
    setState(() => _appointments = updated);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment deleted')));
  }

  Future<void> _markCompleted(Appointment appointment) async {
    final updated = _appointments.map((item) {
      if (item.id == appointment.id) {
        return item.copyWith(isCompleted: !item.isCompleted);
      }
      return item;
    }).toList();

    await StorageService.instance.saveAppointments(updated);
    if (!mounted) return;
    setState(() => _appointments = updated);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final upcoming = _appointments.where((item) => !item.isCompleted).toList();
    final past = _appointments.where((item) => item.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: [
          IconButton(onPressed: () => _openForm(), icon: const Icon(Icons.add_circle_outline)),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SectionHeader(title: 'Upcoming'),
            const SizedBox(height: 12),
            if (upcoming.isEmpty)
              const Text('No upcoming appointments.', style: TextStyle(color: AppTheme.muted))
            else
              ...upcoming.map((item) => _appointmentTile(item)),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Past'),
            const SizedBox(height: 12),
            if (past.isEmpty)
              const Text('No past appointments.', style: TextStyle(color: AppTheme.muted))
            else
              ...past.map((item) => _appointmentTile(item)),
          ],
        ),
      ),
    );
  }

  Widget _appointmentTile(Appointment appointment) {
    return Container(
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
              Expanded(child: Text(appointment.doctorName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: appointment.isCompleted ? AppTheme.teal.withValues(alpha: 0.12) : AppTheme.blue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(appointment.isCompleted ? 'Completed' : 'Upcoming', style: TextStyle(fontSize: 11, color: appointment.isCompleted ? AppTheme.teal : AppTheme.blue, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('${appointment.type} • ${appointment.hospital}', style: const TextStyle(color: AppTheme.muted)),
          const SizedBox(height: 6),
          Text('${appointment.date} • ${appointment.time}', style: const TextStyle(color: AppTheme.muted)),
          if (appointment.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(appointment.notes, style: const TextStyle(color: AppTheme.muted)),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonal(onPressed: () => _markCompleted(appointment), child: Text(appointment.isCompleted ? 'Re-open' : 'Mark Completed')),
              TextButton.icon(onPressed: () => _openForm(appointment: appointment), icon: const Icon(Icons.edit_outlined), label: const Text('Edit')),
              TextButton.icon(onPressed: () => _deleteAppointment(appointment.id), icon: const Icon(Icons.delete_outline), label: const Text('Delete')),
            ],
          )
        ],
      ),
    );
  }
}
