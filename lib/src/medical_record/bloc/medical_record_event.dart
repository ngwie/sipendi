part of 'medical_record_bloc.dart';

sealed class MedicalRecordEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class MedicalRecordFetched extends MedicalRecordEvent {
  MedicalRecordFetched({required this.types});

  final List<MedicalRecordType> types;

  @override
  List<Object> get props => [types];
}
