class Patient {
  final String name;
  final int age;
  final String gender;
  final String bloodGroup;
  final String emergencyContact;
  final String caregiverName;
  final String caregiverPhone;
  final String doctorName;
  final String doctorPhone;
  final String hospital;
  final String diagnosis;
  final String treatmentInfo;

  const Patient({
    required this.name,
    required this.age,
    required this.gender,
    required this.bloodGroup,
    required this.emergencyContact,
    required this.caregiverName,
    this.caregiverPhone = '',
    required this.doctorName,
    this.doctorPhone = '',
    required this.hospital,
    required this.diagnosis,
    required this.treatmentInfo,
  });

  Patient copyWith({
    String? name,
    int? age,
    String? gender,
    String? bloodGroup,
    String? emergencyContact,
    String? caregiverName,
    String? caregiverPhone,
    String? doctorName,
    String? doctorPhone,
    String? hospital,
    String? diagnosis,
    String? treatmentInfo,
  }) {
    return Patient(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      caregiverName: caregiverName ?? this.caregiverName,
      caregiverPhone: caregiverPhone ?? this.caregiverPhone,
      doctorName: doctorName ?? this.doctorName,
      doctorPhone: doctorPhone ?? this.doctorPhone,
      hospital: hospital ?? this.hospital,
      diagnosis: diagnosis ?? this.diagnosis,
      treatmentInfo: treatmentInfo ?? this.treatmentInfo,
    );
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      name: json['name'] as String? ?? 'JYOTI',
      age: json['age'] as int? ?? 22,
      gender: json['gender'] as String? ?? 'Female',
      bloodGroup: json['bloodGroup'] as String? ?? 'AB+',
      emergencyContact: json['emergencyContact'] as String? ?? '01602381861',
      caregiverName: json['caregiverName'] as String? ?? 'Rina Singh',
      caregiverPhone: json['caregiverPhone'] as String? ?? '',
      doctorName: json['doctorName'] as String? ?? 'Dr. Example',
      doctorPhone: json['doctorPhone'] as String? ?? '',
      hospital: json['hospital'] as String? ?? 'Cancer Care Hospital',
      diagnosis: json['diagnosis'] as String? ?? 'Breast Cancer',
      treatmentInfo: json['treatmentInfo'] as String? ?? 'Chemotherapy',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'emergencyContact': emergencyContact,
      'caregiverName': caregiverName,
      'caregiverPhone': caregiverPhone,
      'doctorName': doctorName,
      'doctorPhone': doctorPhone,
      'hospital': hospital,
      'diagnosis': diagnosis,
      'treatmentInfo': treatmentInfo,
    };
  }
}
