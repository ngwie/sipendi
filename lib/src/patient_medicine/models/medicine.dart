import 'package:equatable/equatable.dart';

class Medicine extends Equatable {
  final int id;
  final String name;
  final String? descriptions;

  const Medicine({
    required this.id,
    required this.name,
    this.descriptions,
  });

  @override
  List<Object> get props => [id];

  factory Medicine.formJson(Map<String, dynamic> data) {
    return Medicine(
      id: data['id'],
      name: data['name'],
      descriptions: data['descriptions'],
    );
  }

  static List<Medicine> fromJsonList(List list) {
    return list.map((item) => Medicine.formJson(item)).toList();
  }
}
