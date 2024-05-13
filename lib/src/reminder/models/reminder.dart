import 'package:equatable/equatable.dart';

import 'reminder_time.dart';

class Reminder extends Equatable {
  final int id;
  final bool active;
  final String context;
  final int? referenceId;
  final String? referenceName;
  final String recurrenceType;
  final List<ReminderTime> times;

  const Reminder({
    required this.id,
    required this.active,
    required this.context,
    this.referenceId,
    this.referenceName,
    required this.recurrenceType,
    required this.times,
  });

  @override
  List<Object> get props => [id];

  factory Reminder.fromJson(Map<String, dynamic> data) {
    return Reminder(
      id: data['id'],
      active: data['active'] == 0 ? false : true,
      context: data['context'],
      referenceId: data['reference_id'],
      referenceName: data['reference_name'],
      recurrenceType: data['recurrence_type'],
      times: ReminderTime.fromJsonList(data['time_list']),
    );
  }

  static List<Reminder> fromJsonList(List list) {
    return list.map((item) => Reminder.fromJson(item)).toList();
  }
}
