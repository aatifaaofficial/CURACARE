import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_notification.dart';
import '../models/app_settings.dart';
import '../models/appointment.dart';
import '../models/health_record.dart';
import '../models/medical_report.dart';
import '../models/medication.dart';
import '../models/patient.dart';
import '../models/symptom.dart';
import '../models/treatment.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  static const String _patientKey = 'patient';
  static const String _healthRecordsKey = 'health_records';
  static const String _symptomsKey = 'symptoms';
  static const String _medicationsKey = 'medications';
  static const String _treatmentKey = 'treatment';
  static const String _appointmentsKey = 'appointments';
  static const String _reportsKey = 'reports';
  static const String _notificationsKey = 'notifications';
  static const String _settingsKey = 'settings';
  static const String _profileValuesVersionKey = 'patient_profile_values_v1';

  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    if (_prefs!.getString(_patientKey) == null) {
      await _prefs!.setString(_patientKey, jsonEncode(_defaultPatient().toJson()));
    }
    if (_prefs!.getBool(_profileValuesVersionKey) != true) {
      final patient = Patient.fromJson(jsonDecode(_prefs!.getString(_patientKey)!) as Map<String, dynamic>);
      final updatedPatient = patient.copyWith(
        name: 'JYOTI',
        age: 22,
        gender: 'Female',
        bloodGroup: 'AB+',
        emergencyContact: '01602381861',
        caregiverName: 'Rina Singh',
        caregiverPhone: '',
        doctorName: 'Dr. Example',
        doctorPhone: '',
        hospital: 'Cancer Care Hospital',
      );
      await _prefs!.setString(_patientKey, jsonEncode(updatedPatient.toJson()));
      await _prefs!.setBool(_profileValuesVersionKey, true);
    }
    if (_prefs!.getString(_healthRecordsKey) == null) {
      await _prefs!.setString(_healthRecordsKey, jsonEncode(_defaultHealthRecords().map((record) => record.toJson()).toList()));
    }
    if (_prefs!.getString(_symptomsKey) == null) {
      await _prefs!.setString(_symptomsKey, jsonEncode(_defaultSymptoms().map((symptom) => symptom.toJson()).toList()));
    }
    if (_prefs!.getString(_medicationsKey) == null) {
      await _prefs!.setString(_medicationsKey, jsonEncode(_defaultMedications().map((medication) => medication.toJson()).toList()));
    }
    if (_prefs!.getString(_treatmentKey) == null) {
      await _prefs!.setString(_treatmentKey, jsonEncode(_defaultTreatment().toJson()));
    }
    if (_prefs!.getString(_appointmentsKey) == null) {
      await _prefs!.setString(_appointmentsKey, jsonEncode(_defaultAppointments().map((appointment) => appointment.toJson()).toList()));
    }
    if (_prefs!.getString(_reportsKey) == null) {
      await _prefs!.setString(_reportsKey, jsonEncode(_defaultReports().map((report) => report.toJson()).toList()));
    }
    if (_prefs!.getString(_notificationsKey) == null) {
      await _prefs!.setString(_notificationsKey, jsonEncode(_defaultNotifications().map((notification) => notification.toJson()).toList()));
    }
    if (_prefs!.getString(_settingsKey) == null) {
      await _prefs!.setString(_settingsKey, jsonEncode(_defaultSettings().toJson()));
    }
  }

  Future<Patient> getPatient() async {
    await initialize();
    final raw = _prefs!.getString(_patientKey);
    if (raw == null || raw.isEmpty) {
      return _defaultPatient();
    }
    return Patient.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> savePatient(Patient patient) async {
    await initialize();
    await _prefs!.setString(_patientKey, jsonEncode(patient.toJson()));
  }

  Future<List<HealthRecord>> getHealthRecords() async {
    await initialize();
    final raw = _prefs!.getString(_healthRecordsKey);
    if (raw == null || raw.isEmpty) return _defaultHealthRecords();
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => HealthRecord.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveHealthRecords(List<HealthRecord> records) async {
    await initialize();
    await _prefs!.setString(_healthRecordsKey, jsonEncode(records.map((e) => e.toJson()).toList()));
  }

  Future<List<Symptom>> getSymptoms() async {
    await initialize();
    final raw = _prefs!.getString(_symptomsKey);
    if (raw == null || raw.isEmpty) return _defaultSymptoms();
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => Symptom.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveSymptoms(List<Symptom> symptoms) async {
    await initialize();
    await _prefs!.setString(_symptomsKey, jsonEncode(symptoms.map((e) => e.toJson()).toList()));
  }

  Future<List<Medication>> getMedications() async {
    await initialize();
    final raw = _prefs!.getString(_medicationsKey);
    if (raw == null || raw.isEmpty) return _defaultMedications();
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => Medication.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveMedications(List<Medication> medications) async {
    await initialize();
    await _prefs!.setString(_medicationsKey, jsonEncode(medications.map((e) => e.toJson()).toList()));
  }

  Future<Treatment> getTreatment() async {
    await initialize();
    final raw = _prefs!.getString(_treatmentKey);
    if (raw == null || raw.isEmpty) return _defaultTreatment();
    return Treatment.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveTreatment(Treatment treatment) async {
    await initialize();
    await _prefs!.setString(_treatmentKey, jsonEncode(treatment.toJson()));
  }

  Future<List<Appointment>> getAppointments() async {
    await initialize();
    final raw = _prefs!.getString(_appointmentsKey);
    if (raw == null || raw.isEmpty) return _defaultAppointments();
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => Appointment.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveAppointments(List<Appointment> appointments) async {
    await initialize();
    await _prefs!.setString(_appointmentsKey, jsonEncode(appointments.map((e) => e.toJson()).toList()));
  }

  Future<List<MedicalReport>> getReports() async {
    await initialize();
    final raw = _prefs!.getString(_reportsKey);
    if (raw == null || raw.isEmpty) return _defaultReports();
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => MedicalReport.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveReports(List<MedicalReport> reports) async {
    await initialize();
    await _prefs!.setString(_reportsKey, jsonEncode(reports.map((e) => e.toJson()).toList()));
  }

  Future<List<AppNotificationItem>> getNotifications() async {
    await initialize();
    final raw = _prefs!.getString(_notificationsKey);
    if (raw == null || raw.isEmpty) return _defaultNotifications();
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => AppNotificationItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveNotifications(List<AppNotificationItem> notifications) async {
    await initialize();
    await _prefs!.setString(_notificationsKey, jsonEncode(notifications.map((e) => e.toJson()).toList()));
  }

  Future<AppSettings> getSettings() async {
    await initialize();
    final raw = _prefs!.getString(_settingsKey);
    if (raw == null || raw.isEmpty) return _defaultSettings();
    return AppSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveSettings(AppSettings settings) async {
    await initialize();
    await _prefs!.setString(_settingsKey, jsonEncode(settings.toJson()));
  }

  static Patient _defaultPatient() {
    return const Patient(
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
  }

  static List<HealthRecord> _defaultHealthRecords() {
    return [
      const HealthRecord(
        id: 'h1',
        date: '2026-09-25',
        painLevel: 3,
        temperature: 98.4,
        weight: 62,
        energy: 'Good',
        mood: 'Calm',
        sleepHours: 7,
        notes: 'Energy stable with lighter discomfort today.',
      ),
      const HealthRecord(
        id: 'h2',
        date: '2026-09-20',
        painLevel: 4,
        temperature: 98.8,
        weight: 61.8,
        energy: 'Average',
        mood: 'Okay',
        sleepHours: 6,
        notes: 'Some fatigue after treatment cycle.',
      ),
      const HealthRecord(
        id: 'h3',
        date: '2026-09-15',
        painLevel: 2,
        temperature: 98.2,
        weight: 62.2,
        energy: 'Excellent',
        mood: 'Happy',
        sleepHours: 8,
        notes: 'Feeling well throughout the day.',
      ),
    ];
  }

  static List<Symptom> _defaultSymptoms() {
    return [
      const Symptom(
        id: 's1',
        name: 'Fatigue',
        severity: 'Moderate',
        date: '2026-09-26',
        time: '15:30',
        notes: 'Feeling tired after activity.',
      ),
      const Symptom(
        id: 's2',
        name: 'Nausea',
        severity: 'Mild',
        date: '2026-09-24',
        time: '09:15',
        notes: 'Improved after hydration and a light snack.',
      ),
    ];
  }

  static List<Medication> _defaultMedications() {
    return [
      const Medication(
        id: 'm1',
        name: 'Vitamin D',
        dosage: '1000 IU',
        frequency: 'Daily',
        time: '08:00',
        startDate: '2026-08-01',
        endDate: '2026-12-31',
        instructions: 'Take after breakfast.',
        notes: 'Support wellness and energy.',
        status: 'Taken',
      ),
      const Medication(
        id: 'm2',
        name: 'Anti-Nausea',
        dosage: '10 mg',
        frequency: 'Twice daily',
        time: '14:00',
        startDate: '2026-09-01',
        endDate: '2026-10-15',
        instructions: 'Take with food and water.',
        notes: 'As prescribed by physician.',
        status: 'Upcoming',
      ),
    ];
  }

  static Treatment _defaultTreatment() {
    return const Treatment(
      type: 'Chemotherapy',
      doctorName: 'Dr. Example',
      hospital: 'Cancer Care Hospital',
      startDate: '2026-08-01',
      currentCycle: 3,
      totalCycles: 6,
      nextSession: '2026-09-28',
      progress: 0.5,
      notes: 'Treatment is progressing as planned.',
      cycles: [
        TreatmentCycle(cycleNumber: 1, date: '2026-08-01', status: 'Completed', notes: 'Completed successfully.'),
        TreatmentCycle(cycleNumber: 2, date: '2026-08-15', status: 'Completed', notes: 'Completed successfully.'),
        TreatmentCycle(cycleNumber: 3, date: '2026-09-01', status: 'Completed', notes: 'Current cycle in progress.'),
        TreatmentCycle(cycleNumber: 4, date: '2026-09-28', status: 'Upcoming', notes: 'Next planned session.'),
        TreatmentCycle(cycleNumber: 5, date: '2026-10-15', status: 'Upcoming', notes: 'Awaiting schedule.'),
        TreatmentCycle(cycleNumber: 6, date: '2026-11-01', status: 'Upcoming', notes: 'Final cycle.'),
      ],
    );
  }

  static List<Appointment> _defaultAppointments() {
    return [
      const Appointment(
        id: 'a1',
        doctorName: 'Dr. Michael Anderson',
        hospital: 'Oncology Clinic',
        date: '2026-09-28',
        time: '10:30',
        type: 'Doctor Visit',
        notes: 'Follow-up discussion about progress and medication review.',
        isCompleted: false,
      ),
      const Appointment(
        id: 'a2',
        doctorName: 'Dr. Helen Wu',
        hospital: 'Radiology Center',
        date: '2026-09-12',
        time: '11:00',
        type: 'Test',
        notes: 'Routine blood work and imaging review.',
        isCompleted: true,
      ),
    ];
  }

  static List<MedicalReport> _defaultReports() {
    return [
      const MedicalReport(
        id: 'r1',
        title: 'CBC Review',
        type: 'Blood Test',
        date: '2026-09-18',
        doctor: 'Dr. Example',
        description: 'CBC analysis reviewed for stable counts and overall tolerance.',
        status: 'Reviewed',
      ),
      const MedicalReport(
        id: 'r2',
        title: 'Imaging Summary',
        type: 'Imaging',
        date: '2026-09-05',
        doctor: 'Dr. Michael Anderson',
        description: 'Review of progress imaging and treatment response.',
        status: 'Pending',
      ),
    ];
  }

  static List<AppNotificationItem> _defaultNotifications() {
    return [
      const AppNotificationItem(
        id: 'n1',
        title: 'Medication Reminder',
        description: 'Time to take Vitamin D.',
        date: '2026-09-28',
        time: '08:00',
        read: false,
      ),
      const AppNotificationItem(
        id: 'n2',
        title: 'Appointment Reminder',
        description: 'Your oncology review is scheduled for tomorrow.',
        date: '2026-09-27',
        time: '18:00',
        read: true,
      ),
      const AppNotificationItem(
        id: 'n3',
        title: 'Health Record Reminder',
        description: 'Update today’s health check-in to stay on track.',
        date: '2026-09-26',
        time: '20:00',
        read: false,
      ),
    ];
  }

  static AppSettings _defaultSettings() {
    return const AppSettings(
      notifications: true,
      medicationReminders: true,
      appointmentReminders: true,
      treatmentReminders: true,
      darkMode: false,
      language: 'English',
      privacyAccepted: true,
    );
  }
}
