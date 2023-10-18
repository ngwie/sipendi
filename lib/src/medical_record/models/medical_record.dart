import 'package:equatable/equatable.dart';

// ignore_for_file: constant_identifier_names
enum MedicalRecordType {
  body_height,
  body_weight,
  hemoglobin_a1c,
  blood_sugar,
  blood_pressure_systolic,
  blood_Pressure_diastolic,
  cholesterol,
  abdominal_circumference
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
