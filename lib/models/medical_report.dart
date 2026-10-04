class MedicalReport {
  final String id;
  final String title;
  final String type;
  final String date;
  final String doctor;
  final String description;
  final String status;

  const MedicalReport({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.doctor,
    required this.description,
    required this.status,
  });

  factory MedicalReport.fromJson(Map<String, dynamic> json) {
    return MedicalReport(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] as String? ?? 'Blood Test',
      type: json['type'] as String? ?? 'Blood Test',
      date: json['date'] as String? ?? '2026-09-20',
      doctor: json['doctor'] as String? ?? 'Dr. Example',
      description: json['description'] as String? ?? 'Standard review report.',
      status: json['status'] as String? ?? 'Reviewed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'date': date,
      'doctor': doctor,
      'description': description,
      'status': status,
    };
  }

  MedicalReport copyWith({
    String? id,
    String? title,
    String? type,
    String? date,
    String? doctor,
    String? description,
    String? status,
  }) {
    return MedicalReport(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      date: date ?? this.date,
      doctor: doctor ?? this.doctor,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }
}
