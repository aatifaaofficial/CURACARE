class AppNotificationItem {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final bool read;

  const AppNotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.read,
  });

  factory AppNotificationItem.fromJson(Map<String, dynamic> json) {
    return AppNotificationItem(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] as String? ?? 'Medication Reminder',
      description: json['description'] as String? ?? 'Take your medication on time.',
      date: json['date'] as String? ?? '2026-09-28',
      time: json['time'] as String? ?? '08:00',
      read: json['read'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'read': read,
    };
  }

  AppNotificationItem copyWith({
    String? id,
    String? title,
    String? description,
    String? date,
    String? time,
    bool? read,
  }) {
    return AppNotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      read: read ?? this.read,
    );
  }
}
