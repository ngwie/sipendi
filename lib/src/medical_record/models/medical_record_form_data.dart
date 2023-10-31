import 'package:equatable/equatable.dart';

import 'medical_record_type.dart';

class MedicalRecordFormData extends Equatable {
  const MedicalRecordFormData({required this.type, required this.value});

  final MedicalRecordType type;
  final String value;

  @override
  List<Object> get props => [type, value];
}
