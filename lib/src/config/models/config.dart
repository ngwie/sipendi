import 'package:equatable/equatable.dart';

final class Config extends Equatable {
  const Config({
    required this.id,
    required this.key,
    required this.value,
  });

  final int id;
  final String key;
  final String value;

  @override
  List<Object> get props => [id];

  factory Config.fromJson(Map<String, dynamic> data) {
    return Config(
      id: data['id'],
      key: data['key'],
      value: data['value'],
    );
  }

  static List<Config> fromJsonList(List list) {
    return list.map((item) => Config.fromJson(item)).toList();
  }
}
