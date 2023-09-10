import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReminderModel {
  final int id;
  final bool active;
  final String context;
  final int? referenceId;
  final String? referenceName;
  final String recurrenceType;
  final List<ReminderTimeModel> times;

  ReminderModel({
    required this.id,
    required this.active,
    required this.context,
    this.referenceId,
    this.referenceName,
    required this.recurrenceType,
    required this.times,
  });

  factory ReminderModel.fromHash(Map<String, dynamic> data) {
    return ReminderModel(
      id: data['id'],
      active: data['active'] == 0 ? false : true,
      context: data['context'],
      referenceId: data['reference_id'],
      referenceName: data['reference_name'],
      recurrenceType: data['recurrence_type'],
      times: ReminderTimeModel.formHashList(data['time_list']),
    );
  }

  static List<ReminderModel> fromHashList(List list) {
    return list.map((item) => ReminderModel.fromHash(item)).toList();
  }
}

class ReminderTimeModel {
  final int id;
  final int reminderId;
  final TimeOfDay time;

  ReminderTimeModel({
    required this.id,
    required this.reminderId,
    required this.time,
  });

  factory ReminderTimeModel.fromHash(Map<String, dynamic> data) {
    DateTime dateTime = DateFormat("HH:mm").parse(data['time']);
    TimeOfDay time = TimeOfDay.fromDateTime(dateTime);

    return ReminderTimeModel(
      id: data['id'],
      reminderId: data['reminder_id'],
      time: time,
    );
  }

  static List<ReminderTimeModel> formHashList(List list) {
    return list.map((item) => ReminderTimeModel.fromHash(item)).toList();
  }
}
