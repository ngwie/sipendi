part of 'consultation_bloc.dart';

sealed class ConsultationEvent extends Equatable {
  const ConsultationEvent();

  @override
  List<Object> get props => [];
}

final class ConsultationFetched extends ConsultationEvent {}

final class ConsultationAdded extends ConsultationEvent {
  const ConsultationAdded({required this.data});

  final ConsultationFormData data;

  @override
  List<Object> get props => [data];
}
