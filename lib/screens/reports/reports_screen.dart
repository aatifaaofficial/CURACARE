import 'package:flutter/material.dart';

import '../../models/medical_report.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<MedicalReport> _reports = [];
  bool _loading = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'All';

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _doctorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _type = 'Blood Test';
  String _status = 'Reviewed';

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _titleController.dispose();
    _dateController.dispose();
    _doctorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadReports() async {
    final reports = await StorageService.instance.getReports();
    if (!mounted) return;
    setState(() {
      _reports = reports;
      _loading = false;
    });
  }

  void _openForm({MedicalReport? report}) {
    _titleController.text = report?.title ?? '';
    _dateController.text = report?.date ?? DateTime.now().toIso8601String().split('T').first;
    _doctorController.text = report?.doctor ?? '';
    _descriptionController.text = report?.description ?? '';
    _type = report?.type ?? 'Blood Test';
    _status = report?.status ?? 'Reviewed';

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
                      Text(report == null ? 'Add Report' : 'Edit Report', style: Theme.of(context).textTheme.titleLarge),
                      IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title'), validator: (value) => (value == null || value.trim().isEmpty) ? 'Title is required.' : null),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _type,
                    decoration: const InputDecoration(labelText: 'Type'),
                    items: ['Blood Test', 'CBC', 'Imaging', 'Prescription', 'Doctor Notes', 'Other']
                        .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                        .toList(),
                    onChanged: (value) => setState(() => _type = value ?? 'Blood Test'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(controller: _dateController, decoration: const InputDecoration(labelText: 'Date'), validator: (value) => (value == null || value.trim().isEmpty) ? 'Date is required.' : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _doctorController, decoration: const InputDecoration(labelText: 'Doctor'), validator: (value) => (value == null || value.trim().isEmpty) ? 'Doctor is required.' : null),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: ['Reviewed', 'Pending', 'Uploaded']
                        .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                        .toList(),
                    onChanged: (value) => setState(() => _status = value ?? 'Reviewed'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(controller: _descriptionController, maxLines: 4, decoration: const InputDecoration(labelText: 'Description')),
                  const SizedBox(height: 20),
                  SizedBox(width: double.infinity, child: FilledButton(onPressed: () => _saveReport(report), child: const Text('Save'))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveReport(MedicalReport? report) async {
    if (!_formKey.currentState!.validate()) return;

    final item = (report ?? MedicalReport(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      type: _type,
      date: _dateController.text.trim(),
      doctor: _doctorController.text.trim(),
      description: _descriptionController.text.trim(),
      status: _status,
    )).copyWith(
      title: _titleController.text.trim(),
      type: _type,
      date: _dateController.text.trim(),
      doctor: _doctorController.text.trim(),
      description: _descriptionController.text.trim(),
      status: _status,
    );

    final updated = [..._reports];
    final index = updated.indexWhere((element) => element.id == item.id);
    if (index >= 0) {
      updated[index] = item;
    } else {
      updated.insert(0, item);
    }

    await StorageService.instance.saveReports(updated);
    if (!mounted) return;
    setState(() => _reports = updated);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved successfully')));
  }

  Future<void> _deleteReport(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete report?'),
        content: const Text('Are you sure you want to delete this medical report?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed != true) return;
    final updated = _reports.where((item) => item.id != id).toList();
    await StorageService.instance.saveReports(updated);
    if (!mounted) return;
    setState(() => _reports = updated);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report deleted')));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final filteredReports = _reports.where((report) {
      final q = _searchController.text.trim().toLowerCase();
      final matchesQuery = q.isEmpty || report.title.toLowerCase().contains(q) || report.doctor.toLowerCase().contains(q);
      final matchesType = _selectedType == 'All' || report.type == _selectedType;
      return matchesQuery && matchesType;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Reports'),
        actions: [
          IconButton(onPressed: () => _openForm(), icon: const Icon(Icons.add_circle_outline)),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search reports'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedType,
              decoration: const InputDecoration(labelText: 'Filter by report type'),
              items: ['All', 'Blood Test', 'CBC', 'Imaging', 'Prescription', 'Doctor Notes', 'Other']
                  .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedType = value ?? 'All');
              },
            ),
            const SizedBox(height: 20),
            if (filteredReports.isEmpty)
              EmptyState(
                title: 'No medical reports yet.',
                subtitle: 'Add your blood tests, imaging summaries and care notes.',
                actionLabel: 'Add Report',
                onAction: () => _openForm(),
              )
            else
              ...filteredReports.map((report) => Container(
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
                        Expanded(child: Text(report.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.blue.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(report.type, style: const TextStyle(fontSize: 11, color: AppTheme.blue, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('${report.date} • ${report.doctor}', style: const TextStyle(color: AppTheme.muted)),
                    const SizedBox(height: 8),
                    Text(report.description, style: const TextStyle(color: AppTheme.muted)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(report.status, style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.teal)),
                        const Spacer(),
                        TextButton.icon(onPressed: () => _openForm(report: report), icon: const Icon(Icons.edit_outlined), label: const Text('Edit')),
                        TextButton.icon(onPressed: () => _deleteReport(report.id), icon: const Icon(Icons.delete_outline), label: const Text('Delete')),
                      ],
                    )
                  ],
                ),
              )),
          ],
        ),
      ),
    );
  }
}
