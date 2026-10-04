import 'package:flutter/material.dart';

import '../../models/appointment.dart';
import '../../models/health_record.dart';
import '../../models/medication.dart';
import '../../models/patient.dart';
import '../../models/symptom.dart';
import '../../models/treatment.dart';
import '../../screens/appointments/appointment_screen.dart';
import '../../screens/emergency/emergency_screen.dart';
import '../../screens/health/health_screen.dart';
import '../../screens/medication/medication_screen.dart';
import '../../screens/notifications/notifications_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/reports/reports_screen.dart';
import '../../screens/symptoms/symptom_screen.dart';
import '../../screens/treatment/treatment_screen.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/appointment_card.dart';
import '../../widgets/emergency_card.dart';
import '../../widgets/health_progress_chart.dart';
import '../../widgets/health_summary_card.dart';
import '../../widgets/medication_card.dart';
import '../../widgets/quick_action_card.dart';
import '../../widgets/treatment_overview_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
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
  Treatment _treatment = const Treatment(
    type: 'Chemotherapy',
    doctorName: 'Dr. Example',
    hospital: 'Cancer Care Hospital',
    startDate: '2026-08-01',
    currentCycle: 3,
    totalCycles: 6,
    nextSession: '2026-09-28',
    progress: 0.5,
    notes: 'Treatment is progressing as planned.',
    cycles: [],
  );
  List<HealthRecord> _healthRecords = const [];
  List<Medication> _medications = const [];
  List<Appointment> _appointments = const [];
  List<Symptom> _symptoms = const [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final patient = await StorageService.instance.getPatient();
    final treatment = await StorageService.instance.getTreatment();
    final health = await StorageService.instance.getHealthRecords();
    final medications = await StorageService.instance.getMedications();
    final appointments = await StorageService.instance.getAppointments();
    final symptoms = await StorageService.instance.getSymptoms();

    if (!mounted) return;
    setState(() {
      _patient = patient;
      _treatment = treatment;
      _healthRecords = health;
      _medications = medications;
      _appointments = appointments;
      _symptoms = symptoms;
    });
  }

  Future<void> _openReportScreen(Widget screen) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    if (!mounted) return;
    await _loadData();
  }

  Future<void> _toggleMedication(Medication medication) async {
    final updated = _medications.map((item) {
      if (item.id == medication.id) {
        return item.copyWith(status: item.status == 'Taken' ? 'Upcoming' : 'Taken');
      }
      return item;
    }).toList();

    await StorageService.instance.saveMedications(updated);
    if (!mounted) return;
    setState(() => _medications = updated);
  }

  Future<void> _confirmEmergency() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact emergency support?'),
        content: const Text('This will prepare a call to your saved emergency contact. Continue only if you need urgent support.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), style: FilledButton.styleFrom(backgroundColor: AppTheme.coral), child: const Text('Continue')),
        ],
      ),
    );

    if (confirmed == true) {
      _openReportScreen(const EmergencyScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeContent = _HomeContent(
      patient: _patient,
      treatment: _treatment,
      healthRecords: _healthRecords,
      medications: _medications,
      appointments: _appointments,
      symptoms: _symptoms,
      onViewTreatment: () => _openReportScreen(const TreatmentScreen()),
      onMedicationCheck: (medication) => _toggleMedication(medication),
      onAppointment: () => _openReportScreen(const AppointmentScreen()),
      onQuickAction: (action) {
        switch (action) {
          case 'health':
            _openReportScreen(const HealthScreen(initialFormOpen: true));
            break;
          case 'healthDetails':
            _openReportScreen(const HealthScreen());
            break;
          case 'symptom':
            _openReportScreen(const SymptomScreen(initialAddMode: true));
            break;
          case 'medication':
            _openReportScreen(const MedicationScreen());
            break;
          case 'appointment':
            _openReportScreen(const AppointmentScreen());
            break;
          case 'report':
            _openReportScreen(const ReportsScreen());
            break;
          case 'notifications':
            _openReportScreen(const NotificationsScreen());
            break;
          default:
            break;
        }
      },
      onEmergency: _confirmEmergency,
      onProfileTap: () => _openReportScreen(const ProfileScreen()),
      onNotificationTap: () => _openReportScreen(const NotificationsScreen()),
    );

    final screens = [
      homeContent,
      const HealthScreen(),
      const TreatmentScreen(),
      const ReportsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: screens,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
          if (index == 0) _loadData();
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'HOME'),
          NavigationDestination(icon: Icon(Icons.favorite_outline), selectedIcon: Icon(Icons.favorite), label: 'HEALTH'),
          NavigationDestination(icon: Icon(Icons.medical_services_outlined), selectedIcon: Icon(Icons.medical_services), label: 'TREATMENT'),
          NavigationDestination(icon: Icon(Icons.folder_open_outlined), selectedIcon: Icon(Icons.folder), label: 'REPORTS'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'PROFILE'),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.patient,
    required this.treatment,
    required this.healthRecords,
    required this.medications,
    required this.appointments,
    required this.symptoms,
    required this.onViewTreatment,
    required this.onMedicationCheck,
    required this.onAppointment,
    required this.onQuickAction,
    required this.onEmergency,
    required this.onProfileTap,
    required this.onNotificationTap,
  });

  final Patient patient;
  final Treatment treatment;
  final List<HealthRecord> healthRecords;
  final List<Medication> medications;
  final List<Appointment> appointments;
  final List<Symptom> symptoms;
  final VoidCallback onViewTreatment;
  final Future<void> Function(Medication medication) onMedicationCheck;
  final VoidCallback onAppointment;
  final ValueChanged<String> onQuickAction;
  final VoidCallback onEmergency;
  final VoidCallback onProfileTap;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    final latestRecord = healthRecords.isNotEmpty ? healthRecords.first : const HealthRecord(
      id: 'default',
      date: '2026-09-28',
      painLevel: 3,
      temperature: 98.4,
      weight: 62,
      energy: 'Good',
      mood: 'Calm',
      sleepHours: 7,
      notes: 'Healthy and stable day.',
    );

    final nextAppointment = appointments.isNotEmpty ? appointments.where((item) => !item.isCompleted).toList().firstOrNull : null;
    final visibleMedications = medications.take(2).toList();
    final recentSymptoms = symptoms.take(3).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth >= 600 ? 32.0 : 20.0;
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 18, horizontalPadding, 26),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _Header(
                    patientName: patient.name,
                    onNotifications: onNotificationTap,
                    onProfile: onProfileTap,
                  ),
                  const SizedBox(height: 26),
                  TreatmentOverviewCard(
                    treatment: treatment,
                    onViewTreatment: onViewTreatment,
                  ),
                  const SizedBox(height: 28),
                  _SectionTitle(title: "Today's Health", action: 'View details', onAction: () => onQuickAction('healthDetails')),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: constraints.maxWidth >= 520 ? 4 : 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: constraints.maxWidth >= 520 ? 1.05 : 1.22,
                    children: [
                      HealthSummaryCard(title: 'Pain Level', value: '${latestRecord.painLevel} / 10', icon: Icons.sentiment_satisfied_alt_outlined, color: AppTheme.purple, note: 'Manageable'),
                      HealthSummaryCard(title: 'Temperature', value: '${latestRecord.temperature.toStringAsFixed(1)}°F', icon: Icons.thermostat_outlined, color: AppTheme.coral, note: 'Normal range'),
                      HealthSummaryCard(title: 'Weight', value: '${latestRecord.weight.toStringAsFixed(0)} kg', icon: Icons.monitor_weight_outlined, color: AppTheme.blue, note: 'Stable'),
                      HealthSummaryCard(title: 'Energy', value: latestRecord.energy, icon: Icons.bolt_outlined, color: AppTheme.teal, note: 'Feeling well'),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _SectionTitle(title: "Today's Medication", action: 'View All', onAction: () => onQuickAction('medication')),
                  const SizedBox(height: 12),
                  if (visibleMedications.isEmpty)
                    const Text('No medications yet.', style: TextStyle(color: AppTheme.muted))
                  else
                    ...visibleMedications.map((medication) => MedicationCard(
                      name: medication.name,
                      time: medication.time,
                      status: medication.status,
                      isTaken: medication.status == 'Taken',
                      onCheck: () => onMedicationCheck(medication),
                    )),
                  const SizedBox(height: 18),
                  const _SectionTitle(title: 'Upcoming Appointment'),
                  const SizedBox(height: 12),
                  nextAppointment != null
                      ? AppointmentCard(
                          doctorName: nextAppointment.doctorName,
                          hospital: nextAppointment.hospital,
                          date: nextAppointment.date,
                          time: nextAppointment.time,
                          onViewDetails: onAppointment,
                        )
                      : Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Text('No upcoming appointments.', style: TextStyle(color: AppTheme.muted)),
                        ),
                  const SizedBox(height: 28),
                  HealthProgressChart(records: healthRecords),
                  const SizedBox(height: 28),
                  const _SectionTitle(title: 'Quick Actions'),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: constraints.maxWidth >= 520 ? 5 : 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: constraints.maxWidth >= 520 ? 1.1 : 1.3,
                    children: [
                      QuickActionCard(label: 'Add Health', icon: Icons.favorite_outline, color: AppTheme.blue, onTap: () => onQuickAction('health')),
                      QuickActionCard(label: 'Add Symptom', icon: Icons.sick_outlined, color: AppTheme.purple, onTap: () => onQuickAction('symptom')),
                      QuickActionCard(label: 'Medication', icon: Icons.medication_outlined, color: AppTheme.teal, onTap: () => onQuickAction('medication')),
                      QuickActionCard(label: 'Appointment', icon: Icons.calendar_month_outlined, color: AppTheme.blue, onTap: () => onQuickAction('appointment')),
                      QuickActionCard(label: 'Medical Report', icon: Icons.description_outlined, color: AppTheme.coral, onTap: () => onQuickAction('report')),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const _SectionTitle(title: 'Recent Symptoms'),
                  const SizedBox(height: 12),
                  if (recentSymptoms.isEmpty)
                    const Text('No symptoms recorded yet.', style: TextStyle(color: AppTheme.muted))
                  else
                    ...recentSymptoms.map((symptom) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppTheme.purple.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.favorite_outline, color: AppTheme.purple),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(symptom.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                                const SizedBox(height: 4),
                                Text('${symptom.severity} • ${symptom.date}', style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                  const SizedBox(height: 28),
                  EmergencyCard(emergencyContact: patient.emergencyContact, onEmergencyHelp: onEmergency),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.patientName, required this.onNotifications, required this.onProfile});

  final String patientName;
  final VoidCallback onNotifications;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello, $patientName 👋', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.ink)),
              const SizedBox(height: 6),
              Text('Take care of yourself today.', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        Stack(
          children: [
            IconButton(
              onPressed: onNotifications,
              style: IconButton.styleFrom(backgroundColor: Colors.white),
              icon: const Icon(Icons.notifications_none_rounded, color: AppTheme.ink),
            ),
            Positioned(
              right: 7,
              top: 6,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.coral,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.background, width: 1.5),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onProfile,
          child: const CircleAvatar(
            radius: 21,
            backgroundColor: Color(0xFFDDEAF7),
            child: Icon(Icons.person, color: AppTheme.blue, size: 24),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        if (action != null) TextButton(onPressed: onAction, child: Text(action!)),
      ],
    );
  }
}

extension on List<Appointment> {
  Appointment? get firstOrNull => isEmpty ? null : first;
}
