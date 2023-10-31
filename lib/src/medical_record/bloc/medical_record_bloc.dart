import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/medical_record.dart';
import '../models/medical_record_form_data.dart';
import '../models/medical_record_type.dart';

part 'medical_record_event.dart';
part 'medical_record_state.dart';

class MedicalRecordBloc extends Bloc<MedicalRecordEvent, MedicalRecordState> {
  MedicalRecordBloc() : super(const MedicalRecordState()) {
    on<MedicalRecordFetched>(_onFetched);
    on<MedicalRecordAdded>(_onAdded);
  }

  final _supabase = Supabase.instance.client;

  Future<void> _onFetched(
    MedicalRecordFetched event,
    Emitter<MedicalRecordState> emit,
  ) async {
    try {
      emit(state.copyWith(status: MedicalRecordStateStatus.loading));

      final result = await _supabase
          .from('medical_record')
          .select("*")
          .in_('type', event.types.map((type) => type.name).toList())
          .order('created_at')
          .limit(event.types.length * 10);

      final records = MedicalRecord.fromJsonList(result);

      emit(state.copyWith(
        status: MedicalRecordStateStatus.success,
        medicalRecords: {...state.medicalRecords, ...records},
      ));
    } catch (error) {
      emit(state.copyWith(status: MedicalRecordStateStatus.failure));
    }
  }

  Future<void> _onAdded(
    MedicalRecordAdded event,
    Emitter<MedicalRecordState> emit,
  ) async {
    /*
    - handle error
    - handle loading
    - handle top provider
     */
    try {
      final payload = event.data
          .map((data) => {
                'type': data.type.name,
                'value': data.value,
                'user_id': _supabase.auth.currentUser?.id,
              })
          .toList();

      final result =
          await _supabase.from('medical_record').insert(payload).select();

      final records = MedicalRecord.fromJsonList(result);

      emit(state.copyWith(
        status: MedicalRecordStateStatus.success,
        medicalRecords: {...state.medicalRecords, ...records},
      ));
    } catch (error) {
      // handle error
      print(error);
    }
  }
}
