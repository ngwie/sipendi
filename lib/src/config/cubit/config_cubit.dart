import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/config.dart';

part 'config_state.dart';

class ConfigCubit extends Cubit<ConfigState> {
  ConfigCubit() : super(const ConfigState());

  final _supabase = Supabase.instance.client;

  Future<void> fetch() async {
    try {
      if (state.status == ConfigStatus.success) return;

      final result = await _supabase.from('config').select('*');
      final configs = Config.fromJsonList(result);

      emit(state.copyWith(
        status: ConfigStatus.success,
        configs: {...configs},
      ));
    } on PostgrestException catch (error) {
      emit(state.copyWith(
        status: ConfigStatus.failure,
        error: error.message,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: ConfigStatus.failure,
        error: error.toString(),
      ));
    }
  }

  String get(String key) {
    try {
      final config = state.configs.firstWhere((config) => config.key == key);
      return config.value;
    } catch (error) {
      return '';
    }
  }
}
