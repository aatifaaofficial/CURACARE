class Appointment {
  final String id;
  final String doctorName;
  final String hospital;
  final String date;
  final String time;
  final String type;
  final String notes;
  final bool isCompleted;

  const Appointment({
    required this.id,
    required this.doctorName,
    required this.hospital,
    required this.date,
    required this.time,
    required this.type,
    required this.notes,
    required this.isCompleted,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      doctorName: json['doctorName'] as String? ?? 'Dr. Michael Anderson',
      hospital: json['hospital'] as String? ?? 'Cancer Care Hospital',
      date: json['date'] as String? ?? '2026-09-28',
      time: json['time'] as String? ?? '10:30',
      type: json['type'] as String? ?? 'Doctor Visit',
      notes: json['notes'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorName': doctorName,
      'hospital': hospital,
      'date': date,
      'time': time,
      'type': type,
      'notes': notes,
      'isCompleted': isCompleted,
    };
  }

  Appointment copyWith({
    String? id,
    String? doctorName,
    String? hospital,
    String? date,
    String? time,
    String? type,
    String? notes,
    bool? isCompleted,
  }) {
    return Appointment(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      hospital: hospital ?? this.hospital,
      date: date ?? this.date,
      time: time ?? this.time,
      type: type ?? this.type,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
