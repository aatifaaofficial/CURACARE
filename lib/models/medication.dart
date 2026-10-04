class Medication {
  final String id;
  final String name;
  final String dosage;
  final String frequency;
  final String time;
  final String startDate;
  final String endDate;
  final String instructions;
  final String notes;
  final String status;

  const Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.time,
    required this.startDate,
    required this.endDate,
    required this.instructions,
    required this.notes,
    required this.status,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] as String? ?? 'Vitamin D',
      dosage: json['dosage'] as String? ?? '1000 IU',
      frequency: json['frequency'] as String? ?? 'Daily',
      time: json['time'] as String? ?? '08:00',
      startDate: json['startDate'] as String? ?? '2026-08-01',
      endDate: json['endDate'] as String? ?? '2026-12-31',
      instructions: json['instructions'] as String? ?? 'Take after breakfast.',
      notes: json['notes'] as String? ?? '',
      status: json['status'] as String? ?? 'Upcoming',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'time': time,
      'startDate': startDate,
      'endDate': endDate,
      'instructions': instructions,
      'notes': notes,
      'status': status,
    };
  }

  Medication copyWith({
    String? id,
    String? name,
    String? dosage,
    String? frequency,
    String? time,
    String? startDate,
    String? endDate,
    String? instructions,
    String? notes,
    String? status,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      time: time ?? this.time,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      instructions: instructions ?? this.instructions,
      notes: notes ?? this.notes,
      status: status ?? this.status,
    );
  }
}
