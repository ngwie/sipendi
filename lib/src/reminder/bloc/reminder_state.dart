part of 'reminder_bloc.dart';

sealed class ReminderState extends Equatable {
  final Set<Reminder> reminders;

  const ReminderState({
    this.reminders = const {},
  });

  @override
  List<Object> get props => [reminders];

  @override
  String toString() {
    return '''ReminderState { reminders: ${reminders.length} }''';
  }
}

final class ReminderInitial extends ReminderState {}

final class ReminderLoading extends ReminderState {
  const ReminderLoading({super.reminders});
}

final class ReminderSuccess extends ReminderState {
  const ReminderSuccess({required super.reminders});
}

final class ReminderError extends ReminderState {
  final String error;

  const ReminderError({required this.error, super.reminders});
}
