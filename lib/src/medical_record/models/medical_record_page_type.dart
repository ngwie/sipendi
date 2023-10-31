import 'medical_record_type.dart';

enum MedicalRecordPageType {
  bloodSugar,
  hemoglobin,
  bloodPressure,
  cholesterol,
  bodyWeight,
  abdominalCircumference,
}

extension MedicalRecordResourceType on MedicalRecordPageType {
  List<MedicalRecordType> get resourceTypes {
    switch (this) {
      case MedicalRecordPageType.bloodPressure:
        return [
          MedicalRecordType.blood_pressure_systolic,
          MedicalRecordType.blood_pressure_diastolic
        ];
      case MedicalRecordPageType.bloodSugar:
        return [MedicalRecordType.blood_sugar];
      case MedicalRecordPageType.hemoglobin:
        return [MedicalRecordType.hemoglobin_a1c];
      case MedicalRecordPageType.cholesterol:
        return [MedicalRecordType.cholesterol];
      case MedicalRecordPageType.bodyWeight:
        return [MedicalRecordType.body_weight];
      case MedicalRecordPageType.abdominalCircumference:
        return [MedicalRecordType.abdominal_circumference];
      default:
        return [MedicalRecordType.body_height];
    }
  }
}

extension MedicalRecordPageTypeTitle on MedicalRecordPageType {
  String get title {
    switch (this) {
      case MedicalRecordPageType.bloodPressure:
        return 'Tekanan Darah';
      case MedicalRecordPageType.bloodSugar:
        return 'Gula Darah';
      case MedicalRecordPageType.hemoglobin:
        return 'HbA1C';
      case MedicalRecordPageType.cholesterol:
        return 'Kolesterol';
      case MedicalRecordPageType.bodyWeight:
        return 'Berat Badan';
      case MedicalRecordPageType.abdominalCircumference:
        return 'Lingkar Perut';
      default:
        return '';
    }
  }
}
