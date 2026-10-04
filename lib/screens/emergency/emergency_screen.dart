import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  String _emergencyContact = '+1 (555) 010-2200';
  String _caregiver = 'Rina Singh';
  String _caregiverPhone = '';
  String _doctor = 'Dr. Example';
  String _doctorPhone = '';
  String _hospital = 'Cancer Care Hospital';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final patient = await StorageService.instance.getPatient();
    if (!mounted) return;
    setState(() {
      _emergencyContact = patient.emergencyContact;
      _caregiver = patient.caregiverName;
      _caregiverPhone = patient.caregiverPhone;
      _doctor = patient.doctorName;
      _doctorPhone = patient.doctorPhone;
      _hospital = patient.hospital;
    });
  }

  Future<void> _launchPhone(String phone) async {
    final number = phone.replaceAll(RegExp(r'[^+\d]'), '');
    if (!RegExp(r'\d').hasMatch(number)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add a valid phone number in your profile first.')));
      return;
    }
    final uri = Uri(scheme: 'tel', path: number);
    if (!await launchUrl(uri)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to open phone dialer.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Support')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF2F0),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppTheme.coral.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Emergency Contact', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppTheme.ink)),
                  const SizedBox(height: 12),
                  _InfoRow(label: 'Contact', value: _emergencyContact),
                  _InfoRow(label: 'Caregiver', value: _caregiverPhone.isEmpty ? '$_caregiver (phone not provided)' : '$_caregiver • $_caregiverPhone'),
                  _InfoRow(label: 'Doctor', value: _doctorPhone.isEmpty ? '$_doctor (phone not provided)' : '$_doctor • $_doctorPhone'),
                  _InfoRow(label: 'Hospital', value: _hospital),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => _launchPhone(_emergencyContact),
              icon: const Icon(Icons.call),
              label: const Text('Call Emergency'),
              style: FilledButton.styleFrom(backgroundColor: AppTheme.coral),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => _launchPhone(_caregiverPhone),
              icon: const Icon(Icons.person_outline),
              label: const Text('Call Caregiver'),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => _launchPhone(_doctorPhone),
              icon: const Icon(Icons.medical_services_outlined),
              label: const Text('Call Doctor'),
              style: FilledButton.styleFrom(backgroundColor: AppTheme.blue),
            ),
            const SizedBox(height: 20),
            const Text(
              'CancerCare is a supportive tracking application and does not replace professional medical advice, diagnosis, or treatment.',
              style: TextStyle(color: AppTheme.muted),
            ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 90, child: Text(label, style: const TextStyle(color: AppTheme.muted, fontWeight: FontWeight.w700))),
          Expanded(child: Text(value, style: const TextStyle(color: AppTheme.ink, fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }
}
