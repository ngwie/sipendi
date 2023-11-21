part of 'config_cubit.dart';

enum ConfigStatus { initial, success, failure }

final class ConfigState extends Equatable {
  const ConfigState({
    this.status = ConfigStatus.initial,
    this.configs = const <Config>{},
    this.error = '',
  });

  final ConfigStatus status;
  final Set<Config> configs;
  final String error;

  @override
  List<Object> get props => [status, configs];

  ConfigState copyWith({
    ConfigStatus? status,
    Set<Config>? configs,
    String? error,
  }) {
    return ConfigState(
      status: status ?? this.status,
      configs: configs ?? this.configs,
      error: error ?? this.error,
    );
  }
}
