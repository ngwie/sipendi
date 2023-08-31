import 'package:sipendi/src/models/medicine_model.dart';

class UserMedicineModel {
  final int id;
  final String userId;
  final int medicineId;
  final bool active;
  final String startDate;
  final int dose;
  final String doseUnit;
  final String consumptionRule;
  final int recurrenceFrequency;
  final String recurrenceType;
  final String? notes;
  final MedicineModel medicine;

  UserMedicineModel({
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

  factory UserMedicineModel.formHash(Map<String, dynamic> data) {
    return UserMedicineModel(
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
      medicine: MedicineModel.formHash(data['medicine']),
    );
  }

  static List<UserMedicineModel> fromHashList(List list) {
    return list.map((item) => UserMedicineModel.formHash(item)).toList();
  }
}
