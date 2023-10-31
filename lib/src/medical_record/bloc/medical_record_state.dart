part of 'medical_record_bloc.dart';

enum MedicalRecordStateStatus { loading, success, failure }

final class MedicalRecordState extends Equatable {
  final MedicalRecordStateStatus status;
  final Set<MedicalRecord> medicalRecords;

  const MedicalRecordState({
    this.status = MedicalRecordStateStatus.loading,
    this.medicalRecords = const {},
  });

  MedicalRecordState copyWith({
    MedicalRecordStateStatus? status,
    Set<MedicalRecord>? medicalRecords,
    bool? hasReachedMax,
  }) {
    return MedicalRecordState(
      status: status ?? this.status,
      medicalRecords: medicalRecords ?? this.medicalRecords,
    );
  }

  @override
  String toString() {
    return '''MedicalRecordState { status: $status, medicalRecords: ${medicalRecords.length} }''';
  }

  @override
  List<Object> get props => [status, medicalRecords];
}
