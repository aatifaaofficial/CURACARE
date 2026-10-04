class HealthRecord {
  final String id;
  final String date;
  final int painLevel;
  final double temperature;
  final double weight;
  final String energy;
  final String mood;
  final int sleepHours;
  final String notes;

  const HealthRecord({
    required this.id,
    required this.date,
    required this.painLevel,
    required this.temperature,
    required this.weight,
    required this.energy,
    required this.mood,
    required this.sleepHours,
    required this.notes,
  });

  factory HealthRecord.fromJson(Map<String, dynamic> json) {
    return HealthRecord(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      date: json['date'] as String? ?? '2026-09-28',
      painLevel: (json['painLevel'] as num?)?.toInt() ?? 3,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 98.4,
      weight: (json['weight'] as num?)?.toDouble() ?? 62,
      energy: json['energy'] as String? ?? 'Good',
      mood: json['mood'] as String? ?? 'Calm',
      sleepHours: (json['sleepHours'] as num?)?.toInt() ?? 7,
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'painLevel': painLevel,
      'temperature': temperature,
      'weight': weight,
      'energy': energy,
      'mood': mood,
      'sleepHours': sleepHours,
      'notes': notes,
    };
  }

  HealthRecord copyWith({
    String? id,
    String? date,
    int? painLevel,
    double? temperature,
    double? weight,
    String? energy,
    String? mood,
    int? sleepHours,
    String? notes,
  }) {
    return HealthRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      painLevel: painLevel ?? this.painLevel,
      temperature: temperature ?? this.temperature,
      weight: weight ?? this.weight,
      energy: energy ?? this.energy,
      mood: mood ?? this.mood,
      sleepHours: sleepHours ?? this.sleepHours,
      notes: notes ?? this.notes,
    );
  }
}
