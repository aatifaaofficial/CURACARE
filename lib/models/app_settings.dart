class AppSettings {
  final bool notifications;
  final bool medicationReminders;
  final bool appointmentReminders;
  final bool treatmentReminders;
  final bool darkMode;
  final String language;
  final bool privacyAccepted;

  const AppSettings({
    required this.notifications,
    required this.medicationReminders,
    required this.appointmentReminders,
    required this.treatmentReminders,
    required this.darkMode,
    required this.language,
    required this.privacyAccepted,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      notifications: json['notifications'] as bool? ?? true,
      medicationReminders: json['medicationReminders'] as bool? ?? true,
      appointmentReminders: json['appointmentReminders'] as bool? ?? true,
      treatmentReminders: json['treatmentReminders'] as bool? ?? true,
      darkMode: json['darkMode'] as bool? ?? false,
      language: json['language'] as String? ?? 'English',
      privacyAccepted: json['privacyAccepted'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications,
      'medicationReminders': medicationReminders,
      'appointmentReminders': appointmentReminders,
      'treatmentReminders': treatmentReminders,
      'darkMode': darkMode,
      'language': language,
      'privacyAccepted': privacyAccepted,
    };
  }

  AppSettings copyWith({
    bool? notifications,
    bool? medicationReminders,
    bool? appointmentReminders,
    bool? treatmentReminders,
    bool? darkMode,
    String? language,
    bool? privacyAccepted,
  }) {
    return AppSettings(
      notifications: notifications ?? this.notifications,
      medicationReminders: medicationReminders ?? this.medicationReminders,
      appointmentReminders: appointmentReminders ?? this.appointmentReminders,
      treatmentReminders: treatmentReminders ?? this.treatmentReminders,
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
      privacyAccepted: privacyAccepted ?? this.privacyAccepted,
    );
  }
}
