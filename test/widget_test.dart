import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:curacare/main.dart';
import 'package:curacare/models/health_record.dart';
import 'package:curacare/screens/health/health_screen.dart';
import 'package:curacare/screens/profile/profile_screen.dart';
import 'package:curacare/services/storage_service.dart';
import 'package:curacare/widgets/health_progress_chart.dart';

void main() {
  test('storage initializes default data with empty preferences', () async {
    SharedPreferences.setMockInitialValues({
      'patient': jsonEncode({
        'name': 'JYOTI',
        'age': 29,
        'gender': 'Female',
        'bloodGroup': 'A+',
        'emergencyContact': '+1 (555) 010-2200',
        'caregiverName': 'Rina Singh',
        'doctorName': 'Dr. Example',
        'hospital': 'Cancer Care Hospital',
        'diagnosis': 'Breast Cancer',
        'treatmentInfo': 'Chemotherapy',
      }),
    });

    await StorageService.instance.initialize();

    final patient = await StorageService.instance.getPatient();
    expect(patient.name, 'JYOTI');
    expect(patient.age, 22);
    expect(patient.bloodGroup, 'AB+');
    expect(patient.emergencyContact, '01602381861');
    expect(patient.caregiverPhone, isEmpty);
    expect(patient.doctorPhone, isEmpty);
    expect(await StorageService.instance.getHealthRecords(), isNotEmpty);
  });

  testWidgets('Profile displays the updated saved patient values', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
    await tester.pumpAndSettle();

    expect(find.text('22'), findsOneWidget);
    expect(find.text('AB+'), findsOneWidget);
    expect(find.text('01602381861'), findsOneWidget);
    expect(find.text('Not provided'), findsNWidgets(2));
  });

  testWidgets('CancerCare home screen renders key sections', (tester) async {
    await tester.pumpWidget(const CancerCareApp());

    expect(find.text('Hello, JYOTI 👋'), findsOneWidget);
    expect(find.text('Treatment Overview'), findsOneWidget);
    expect(find.text("Today's Health"), findsOneWidget);

    await tester.ensureVisible(find.text('View details'));
    await tester.tap(find.text('View details'));
    await tester.pumpAndSettle();
    expect(find.byType(HealthScreen), findsOneWidget);
  });

  testWidgets('health chart filters records by selected period', (tester) async {
    final oldRecordDate = DateTime.now().subtract(const Duration(days: 10));
    final date = '${oldRecordDate.year}-${oldRecordDate.month.toString().padLeft(2, '0')}-${oldRecordDate.day.toString().padLeft(2, '0')}';
    final record = HealthRecord(
      id: 'chart-record',
      date: date,
      painLevel: 4,
      temperature: 98.4,
      weight: 62,
      energy: 'Good',
      mood: 'Calm',
      sleepHours: 7,
      notes: '',
    );

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: HealthProgressChart(records: [record]))));
    expect(find.text('No health records in this period.'), findsOneWidget);

    await tester.tap(find.text('30 Days'));
    await tester.pumpAndSettle();
    expect(find.text('No health records in this period.'), findsNothing);
  });
}
