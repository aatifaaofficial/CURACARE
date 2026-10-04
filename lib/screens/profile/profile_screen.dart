import 'package:flutter/material.dart';

import '../../models/patient.dart';
import '../../screens/about/about_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Patient _patient = const Patient(
    name: 'JYOTI',
    age: 22,
    gender: 'Female',
    bloodGroup: 'AB+',
    emergencyContact: '01602381861',
    caregiverName: 'Rina Singh',
    doctorName: 'Dr. Example',
    hospital: 'Cancer Care Hospital',
    diagnosis: 'Breast Cancer',
    treatmentInfo: 'Chemotherapy',
  );
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPatient();
  }

  Future<void> _loadPatient() async {
    final patient = await StorageService.instance.getPatient();
    if (!mounted) return;
    setState(() {
      _patient = patient;
      _loading = false;
    });
  }

  Future<void> _editProfile() async {
    final nameController = TextEditingController(text: _patient.name);
    final ageController = TextEditingController(text: _patient.age.toString());
    final genderController = TextEditingController(text: _patient.gender);
    final bloodController = TextEditingController(text: _patient.bloodGroup);
    final emergencyController = TextEditingController(text: _patient.emergencyContact);
    final caregiverController = TextEditingController(text: _patient.caregiverName);
    final caregiverPhoneController = TextEditingController(text: _patient.caregiverPhone);
    final doctorController = TextEditingController(text: _patient.doctorName);
    final doctorPhoneController = TextEditingController(text: _patient.doctorPhone);
    final hospitalController = TextEditingController(text: _patient.hospital);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 340,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                const SizedBox(height: 12),
                TextField(controller: ageController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Age')),
                const SizedBox(height: 12),
                TextField(controller: genderController, decoration: const InputDecoration(labelText: 'Gender')),
                const SizedBox(height: 12),
                TextField(controller: bloodController, decoration: const InputDecoration(labelText: 'Blood Group')),
                const SizedBox(height: 12),
                TextField(controller: emergencyController, decoration: const InputDecoration(labelText: 'Emergency Contact')),
                const SizedBox(height: 12),
                TextField(controller: caregiverController, decoration: const InputDecoration(labelText: 'Caregiver')),
                const SizedBox(height: 12),
                TextField(controller: caregiverPhoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Caregiver Phone')),
                const SizedBox(height: 12),
                TextField(controller: doctorController, decoration: const InputDecoration(labelText: 'Doctor')),
                const SizedBox(height: 12),
                TextField(controller: doctorPhoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Doctor Phone')),
                const SizedBox(height: 12),
                TextField(controller: hospitalController, decoration: const InputDecoration(labelText: 'Hospital')),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != true) return;

    final updated = _patient.copyWith(
      name: nameController.text.trim().isNotEmpty ? nameController.text.trim() : _patient.name,
      age: int.tryParse(ageController.text) ?? _patient.age,
      gender: genderController.text.trim().isNotEmpty ? genderController.text.trim() : _patient.gender,
      bloodGroup: bloodController.text.trim().isNotEmpty ? bloodController.text.trim() : _patient.bloodGroup,
      emergencyContact: emergencyController.text.trim().isNotEmpty ? emergencyController.text.trim() : _patient.emergencyContact,
      caregiverName: caregiverController.text.trim().isNotEmpty ? caregiverController.text.trim() : _patient.caregiverName,
      caregiverPhone: caregiverPhoneController.text.trim(),
      doctorName: doctorController.text.trim().isNotEmpty ? doctorController.text.trim() : _patient.doctorName,
      doctorPhone: doctorPhoneController.text.trim(),
      hospital: hospitalController.text.trim().isNotEmpty ? hospitalController.text.trim() : _patient.hospital,
    );

    await StorageService.instance.savePatient(updated);
    if (!mounted) return;
    setState(() => _patient = updated);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully')));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: AppTheme.blue.withValues(alpha: 0.12),
                    child: Text(_patient.name.isNotEmpty ? _patient.name.substring(0, 1) : 'J', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppTheme.blue)),
                  ),
                  const SizedBox(height: 12),
                  Text(_patient.name, style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _editProfile,
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Color(0x0B19324D), blurRadius: 12, offset: Offset(0, 4))],
              ),
              child: Column(
                children: [
                  _DetailRow(label: 'Age', value: _patient.age.toString()),
                  _DetailRow(label: 'Gender', value: _patient.gender),
                  _DetailRow(label: 'Blood Group', value: _patient.bloodGroup),
                  _DetailRow(label: 'Emergency Contact', value: _patient.emergencyContact),
                  _DetailRow(label: 'Caregiver', value: _patient.caregiverName),
                  _DetailRow(label: 'Caregiver Phone', value: _patient.caregiverPhone.isEmpty ? 'Not provided' : _patient.caregiverPhone),
                  _DetailRow(label: 'Doctor', value: _patient.doctorName),
                  _DetailRow(label: 'Doctor Phone', value: _patient.doctorPhone.isEmpty ? 'Not provided' : _patient.doctorPhone),
                  _DetailRow(label: 'Hospital', value: _patient.hospital),
                  _DetailRow(label: 'Treatment', value: _patient.treatmentInfo),
                  _DetailRow(label: 'Diagnosis', value: _patient.diagnosis),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About CancerCare'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen())),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.muted, fontWeight: FontWeight.w700)),
          Expanded(child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }
}
