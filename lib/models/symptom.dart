class Symptom {
  final String id;
  final String name;
  final String severity;
  final String date;
  final String time;
  final String notes;

  const Symptom({
    required this.id,
    required this.name,
    required this.severity,
    required this.date,
    required this.time,
    required this.notes,
  });

  factory Symptom.fromJson(Map<String, dynamic> json) {
    return Symptom(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] as String? ?? 'Fatigue',
      severity: json['severity'] as String? ?? 'Moderate',
      date: json['date'] as String? ?? '2026-09-28',
      time: json['time'] as String? ?? '09:00',
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'severity': severity,
      'date': date,
      'time': time,
      'notes': notes,
    };
  }

  Symptom copyWith({
    String? id,
    String? name,
    String? severity,
    String? date,
    String? time,
    String? notes,
  }) {
    return Symptom(
      id: id ?? this.id,
      name: name ?? this.name,
      severity: severity ?? this.severity,
      date: date ?? this.date,
      time: time ?? this.time,
      notes: notes ?? this.notes,
    );
  }
}
