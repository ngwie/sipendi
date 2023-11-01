part of 'medical_record_bloc.dart';

enum MedicalRecordStateStatus { initial, loading, success, failure }

final class MedicalRecordState extends Equatable {
  final MedicalRecordStateStatus status;
  final String error;
  final MedicalRecordStateStatus statusAdd;
  final String errorAdd;
  final Set<MedicalRecord> medicalRecords;

  const MedicalRecordState({
    this.status = MedicalRecordStateStatus.initial,
    this.error = '',
    this.statusAdd = MedicalRecordStateStatus.initial,
    this.errorAdd = '',
    this.medicalRecords = const {},
  });

  MedicalRecordState copyWith({
    MedicalRecordStateStatus? status,
    String? error,
    MedicalRecordStateStatus? statusAdd,
    String? errorAdd,
    Set<MedicalRecord>? medicalRecords,
  }) {
    return MedicalRecordState(
      status: status ?? this.status,
      error: error ?? this.error,
      statusAdd: statusAdd ?? this.statusAdd,
      errorAdd: errorAdd ?? this.errorAdd,
      medicalRecords: medicalRecords ?? this.medicalRecords,
    );
  }

  @override
  String toString() {
    return '''MedicalRecordState { status: $status, medicalRecords: ${medicalRecords.length} }''';
  }

  @override
  List<Object> get props =>
      [status, error, statusAdd, errorAdd, medicalRecords];
}
