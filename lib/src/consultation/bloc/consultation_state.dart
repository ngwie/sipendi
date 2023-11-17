part of 'consultation_bloc.dart';

enum ConsultationStatus { initial, loading, success, failure }

final class ConsultationState extends Equatable {
  const ConsultationState({
    this.status = ConsultationStatus.initial,
    this.consultations = const <Consultation>{},
    this.hasReachedMax = false,
    this.error = '',
    this.statusAdd = ConsultationStatus.initial,
    this.errorAdd = '',
  });

  final ConsultationStatus status;
  final Set<Consultation> consultations;
  final bool hasReachedMax;
  final String error;
  final ConsultationStatus statusAdd;
  final String errorAdd;

  ConsultationState copyWith({
    ConsultationStatus? status,
    Set<Consultation>? consultations,
    bool? hasReachedMax,
    String? error,
    ConsultationStatus? statusAdd,
    String? errorAdd,
  }) {
    return ConsultationState(
      status: status ?? this.status,
      consultations: consultations ?? this.consultations,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      error: error ?? this.error,
      statusAdd: statusAdd ?? this.statusAdd,
      errorAdd: errorAdd ?? this.errorAdd,
    );
  }

  @override
  String toString() {
    return '''ConsultationList { status: $status, hasReachedMax: $hasReachedMax, consultations: ${consultations.length} }''';
  }

  @override
  List<Object> get props =>
      [status, consultations, hasReachedMax, error, statusAdd, errorAdd];
}
