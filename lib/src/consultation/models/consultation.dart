import 'package:equatable/equatable.dart';

final class Consultation extends Equatable {
  const Consultation({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  final int id;
  final String title;
  final String body;
  final DateTime createdAt;

  @override
  List<Object> get props => [id];

  factory Consultation.fromJson(Map<String, dynamic> data) {
    return Consultation(
      id: data['id'],
      title: data['title'],
      body: data['body'],
      createdAt: DateTime.parse(data['created_at']),
    );
  }

  static List<Consultation> fromJsonList(List list) {
    return list.map((item) => Consultation.fromJson(item)).toList();
  }
}
