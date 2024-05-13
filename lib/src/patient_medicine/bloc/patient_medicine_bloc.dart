import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/patient_medicine.dart';

part 'patient_medicine_event.dart';
part 'patient_medicine_state.dart';

class PatientMedicineBloc
    extends Bloc<PatientMedicineEvent, PatientMedicineState> {
  final _supabase = Supabase.instance.client;

  PatientMedicineBloc() : super(PatientMedicineInitial()) {
    on<PatientMedicineFetched>((event, emit) async {
      emit(PatientMedicineLoading(patientMedicines: state.patientMedicines));

      try {
        final patientMedicines = await _getPatientMedicines();

        emit(PatientMedicineSuccess(patientMedicines: {
          ...state.patientMedicines,
          ...patientMedicines
        }));
      } catch (error) {
        emit(PatientMedicineError(
          error: error.toString(),
          patientMedicines: state.patientMedicines,
        ));
      }
    });
  }

  Future<List<PatientMedicine>> _getPatientMedicines() async {
    final response = await _supabase.from('patient_medicine').select('''
            id, 
            user_id, 
            medicine_id, 
            active, 
            start_date, 
            dose, dose_unit, 
            consumption_rule, 
            recurrence_type, 
            recurrence_frequency, 
            medicine(id, name, descriptions)
        ''').eq('active', true);

    return PatientMedicine.fromJsonList(response);
  }
}
