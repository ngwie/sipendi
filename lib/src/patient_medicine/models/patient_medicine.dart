import 'package:equatable/equatable.dart';

import 'medicine.dart';

class PatientMedicine extends Equatable {
  final int id;
  final String userId;
  final int medicineId;
  final bool active;
  final String startDate;
  final int dose;
  final String doseUnit;
  final String consumptionRule;
  final String recurrenceType;
  final int recurrenceFrequency;
  final String? notes;
  final Medicine medicine;

  const PatientMedicine({
    required this.id,
    required this.userId,
    required this.medicineId,
    required this.active,
    required this.startDate,
    required this.dose,
    required this.doseUnit,
    required this.consumptionRule,
    required this.recurrenceFrequency,
    required this.recurrenceType,
    this.notes,
    required this.medicine,
  });

  @override
  List<Object> get props => [id];

  factory PatientMedicine.formJson(Map<String, dynamic> data) {
    return PatientMedicine(
      id: data['id'],
      userId: data['user_id'],
      medicineId: data['medicine_id'],
      active: data['active'],
      startDate: data['start_date'],
      dose: data['dose'],
      doseUnit: data['dose_unit'],
      consumptionRule: data['consumption_rule'],
      recurrenceFrequency: data['recurrence_frequency'],
      recurrenceType: data['recurrence_type'],
      notes: data['notes'],
      medicine: Medicine.formJson(data['medicine']),
    );
  }

  static List<PatientMedicine> fromJsonList(List list) {
    return list.map((item) => PatientMedicine.formJson(item)).toList();
  }
}
