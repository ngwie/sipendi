import 'package:equatable/equatable.dart';

class ConsultationFormData extends Equatable {
  const ConsultationFormData({required this.title, required this.body});

  final String title;
  final String body;

  @override
  List<Object> get props => [title, body];
}
