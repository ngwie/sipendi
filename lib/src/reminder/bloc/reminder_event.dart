part of 'reminder_bloc.dart';

sealed class ReminderEvent extends Equatable {
  const ReminderEvent();

  @override
  List<Object> get props => [];
}

final class ReminderFetched extends ReminderEvent {}

final class ReminderAdded extends ReminderEvent {
  final String reminderContext;
  final int referenceId;
  final String referenceName;
  final List<String> reminderTimes;

  const ReminderAdded({
    required this.reminderContext,
    required this.referenceId,
    required this.referenceName,
    required this.reminderTimes,
  });
}

final class ReminderRemoved extends ReminderEvent {
  final int id;

  const ReminderRemoved({required this.id});
}
