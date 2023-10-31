import 'package:equatable/equatable.dart';

// ignore_for_file: constant_identifier_names
enum MedicalRecordType {
  body_height,
  body_weight,
  hemoglobin_a1c,
  blood_sugar,
  blood_pressure_systolic,
  blood_pressure_diastolic,
  cholesterol,
  abdominal_circumference
}

extension MedicalRecordTypeUnit on MedicalRecordType {
  String get unit {
    switch (this) {
      case MedicalRecordType.blood_pressure_diastolic:
      case MedicalRecordType.blood_pressure_systolic:
        return 'mm/Hg';
      case MedicalRecordType.hemoglobin_a1c:
        return '%';
      case MedicalRecordType.blood_sugar:
      case MedicalRecordType.cholesterol:
        return 'mg/dL';
      case MedicalRecordType.body_weight:
        return 'Kilogram';
      case MedicalRecordType.body_height:
      case MedicalRecordType.abdominal_circumference:
        return 'Sentimeter';
      default:
        return '';
    }
  }
}

extension MedicalRecordTypeLabel on MedicalRecordType {
  String label({int? val}) {
    switch (this) {
      case MedicalRecordType.blood_pressure_diastolic:
        return 'Diasole';
      case MedicalRecordType.blood_pressure_systolic:
        return 'Sistole';
      case MedicalRecordType.hemoglobin_a1c:
        return 'HbA1c';
      case MedicalRecordType.blood_sugar:
        if (val == null) {
          return 'Gula Darah';
        } else if (val < 100) {
          return 'Normal';
        } else if (val >= 100 && val <= 125) {
          return 'Prediabetes';
        } else {
          return 'Diabetes';
        }
      case MedicalRecordType.cholesterol:
        if (val == null) {
          return 'Kolesterol';
        } else if (val < 100) {
          return 'Optimal';
        } else if (val >= 100 && val < 130) {
          return 'Near Optimal';
        } else if (val >= 130 && val < 160) {
          return 'Borderline High';
        } else if (val >= 160 && val < 190) {
          return 'High';
        } else {
          return 'Very High';
        }
      case MedicalRecordType.body_weight:
      case MedicalRecordType.body_height:
      case MedicalRecordType.abdominal_circumference:
      default:
        return '';
    }
  }
}

class MedicalRecord extends Equatable {
  const MedicalRecord({
    required this.id,
    required this.userId,
    required this.type,
    required this.value,
    required this.createdAt,
  });

  final int id;
  final String userId;
  final MedicalRecordType type;
  final String value;
  final DateTime createdAt;

  @override
  List<Object> get props => [id];

  factory MedicalRecord.fromJson(Map<String, dynamic> data) {
    return MedicalRecord(
      id: data['id'],
      userId: data['user_id'],
      type: MedicalRecordType.values.byName(data['type']),
      value: data['value'],
      createdAt: DateTime.parse(data['created_at']),
    );
  }

  static List<MedicalRecord> fromJsonList(List list) {
    return list.map((item) => MedicalRecord.fromJson(item)).toList();
  }
}
