part of 'patient_medicine_bloc.dart';

sealed class PatientMedicineEvent extends Equatable {
  const PatientMedicineEvent();

  @override
  List<Object> get props => [];
}

final class PatientMedicineFetched extends PatientMedicineEvent {}

final class PatientMedicineAdded extends PatientMedicineEvent {
  final String medicineId;

  const PatientMedicineAdded({required this.medicineId});
}

final class PatientMedicineRemoved extends PatientMedicineEvent {
  final int id;

  const PatientMedicineRemoved({required this.id});
}
