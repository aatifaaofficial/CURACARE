class TreatmentCycle {
  final int cycleNumber;
  final String date;
  final String status;
  final String notes;

  const TreatmentCycle({
    required this.cycleNumber,
    required this.date,
    required this.status,
    required this.notes,
  });

  factory TreatmentCycle.fromJson(Map<String, dynamic> json) {
    return TreatmentCycle(
      cycleNumber: (json['cycleNumber'] as num?)?.toInt() ?? 1,
      date: json['date'] as String? ?? '2026-08-01',
      status: json['status'] as String? ?? 'Upcoming',
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cycleNumber': cycleNumber,
      'date': date,
      'status': status,
      'notes': notes,
    };
  }

  TreatmentCycle copyWith({
    int? cycleNumber,
    String? date,
    String? status,
    String? notes,
  }) {
    return TreatmentCycle(
      cycleNumber: cycleNumber ?? this.cycleNumber,
      date: date ?? this.date,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}

class Treatment {
  final String type;
  final String doctorName;
  final String hospital;
  final String startDate;
  final int currentCycle;
  final int totalCycles;
  final String nextSession;
  final double progress;
  final String notes;
  final List<TreatmentCycle> cycles;

  const Treatment({
    required this.type,
    required this.doctorName,
    required this.hospital,
    required this.startDate,
    required this.currentCycle,
    required this.totalCycles,
    required this.nextSession,
    required this.progress,
    required this.notes,
    required this.cycles,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    final cycles = (json['cycles'] as List<dynamic>? ?? const [])
        .map((item) => TreatmentCycle.fromJson(item as Map<String, dynamic>))
        .toList();

    return Treatment(
      type: json['type'] as String? ?? 'Chemotherapy',
      doctorName: json['doctorName'] as String? ?? 'Dr. Example',
      hospital: json['hospital'] as String? ?? 'Cancer Care Hospital',
      startDate: json['startDate'] as String? ?? '2026-08-01',
      currentCycle: (json['currentCycle'] as num?)?.toInt() ?? 3,
      totalCycles: (json['totalCycles'] as num?)?.toInt() ?? 6,
      nextSession: json['nextSession'] as String? ?? '2026-09-28',
      progress: (json['progress'] as num?)?.toDouble() ?? 0.5,
      notes: json['notes'] as String? ?? 'Treatment is progressing as planned.',
      cycles: cycles.isEmpty
          ? const [
              TreatmentCycle(cycleNumber: 1, date: '2026-08-01', status: 'Completed', notes: 'Completed successfully.'),
              TreatmentCycle(cycleNumber: 2, date: '2026-08-15', status: 'Completed', notes: 'Completed successfully.'),
              TreatmentCycle(cycleNumber: 3, date: '2026-09-01', status: 'Completed', notes: 'Current cycle in progress.'),
              TreatmentCycle(cycleNumber: 4, date: '2026-09-28', status: 'Upcoming', notes: 'Next planned session.'),
              TreatmentCycle(cycleNumber: 5, date: '2026-10-15', status: 'Upcoming', notes: 'Awaiting schedule.'),
              TreatmentCycle(cycleNumber: 6, date: '2026-11-01', status: 'Upcoming', notes: 'Final cycle.')
            ]
          : cycles,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'doctorName': doctorName,
      'hospital': hospital,
      'startDate': startDate,
      'currentCycle': currentCycle,
      'totalCycles': totalCycles,
      'nextSession': nextSession,
      'progress': progress,
      'notes': notes,
      'cycles': cycles.map((item) => item.toJson()).toList(),
    };
  }

  Treatment copyWith({
    String? type,
    String? doctorName,
    String? hospital,
    String? startDate,
    int? currentCycle,
    int? totalCycles,
    String? nextSession,
    double? progress,
    String? notes,
    List<TreatmentCycle>? cycles,
  }) {
    return Treatment(
      type: type ?? this.type,
      doctorName: doctorName ?? this.doctorName,
      hospital: hospital ?? this.hospital,
      startDate: startDate ?? this.startDate,
      currentCycle: currentCycle ?? this.currentCycle,
      totalCycles: totalCycles ?? this.totalCycles,
      nextSession: nextSession ?? this.nextSession,
      progress: progress ?? this.progress,
      notes: notes ?? this.notes,
      cycles: cycles ?? this.cycles,
    );
  }
}
