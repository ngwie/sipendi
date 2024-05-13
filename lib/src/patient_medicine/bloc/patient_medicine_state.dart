part of 'patient_medicine_bloc.dart';

sealed class PatientMedicineState extends Equatable {
  final Set<PatientMedicine> patientMedicines;

  const PatientMedicineState({this.patientMedicines = const {}});

  @override
  List<Object> get props => [patientMedicines];
}

final class PatientMedicineInitial extends PatientMedicineState {}

final class PatientMedicineLoading extends PatientMedicineState {
  const PatientMedicineLoading({super.patientMedicines});
}

final class PatientMedicineSuccess extends PatientMedicineState {
  const PatientMedicineSuccess({required super.patientMedicines});
}

final class PatientMedicineError extends PatientMedicineState {
  final String error;

  const PatientMedicineError({required this.error, super.patientMedicines});
}
