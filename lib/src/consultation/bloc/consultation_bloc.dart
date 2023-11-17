import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/consultation.dart';
import '../models/consultation_form_data.dart';

part 'consultation_event.dart';
part 'consultation_state.dart';

const pageSize = 10;

class ConsultationBloc extends Bloc<ConsultationEvent, ConsultationState> {
  ConsultationBloc() : super(const ConsultationState()) {
    on<ConsultationFetched>(_onFetched);
    on<ConsultationAdded>(_onAdded);
  }

  final _supabase = Supabase.instance.client;

  Future<void> _onFetched(
    ConsultationFetched event,
    Emitter<ConsultationState> emit,
  ) async {
    try {
      final from = state.consultations.length;
      final to = from + pageSize;

      final result = await _supabase
          .from('patient_consultation')
          .select('*')
          .order('created_at')
          .range(from, to);

      final consultations = Consultation.fromJsonList(result);

      emit(state.copyWith(
        status: ConsultationStatus.success,
        consultations: {...state.consultations, ...consultations},
        error: null,
        hasReachedMax: consultations.isEmpty,
      ));
    } on PostgrestException catch (error) {
      emit(state.copyWith(
        status: ConsultationStatus.failure,
        error: error.message,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: ConsultationStatus.failure,
        error: error.toString(),
      ));
    }
  }

  Future<void> _onAdded(
    ConsultationAdded event,
    Emitter<ConsultationState> emit,
  ) async {
    try {
      emit(state.copyWith(statusAdd: ConsultationStatus.loading));

      final result = await _supabase.from('patient_consultation').insert({
        'title': event.data.title,
        'body': event.data.body,
        'user_id': _supabase.auth.currentUser?.id,
      }).select();

      final consultations = Consultation.fromJsonList(result);

      emit(
        state.copyWith(
          statusAdd: ConsultationStatus.success,
          consultations: {...consultations, ...state.consultations},
        ),
      );
    } on PostgrestException catch (error) {
      emit(state.copyWith(
        statusAdd: ConsultationStatus.failure,
        errorAdd: error.message,
      ));
    } catch (error) {
      emit(state.copyWith(
        statusAdd: ConsultationStatus.failure,
        errorAdd: error.toString(),
      ));
    }
  }
}
