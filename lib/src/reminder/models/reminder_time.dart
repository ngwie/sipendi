import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReminderTime extends Equatable {
  final int id;
  final int reminderId;
  final TimeOfDay time;

  const ReminderTime({
    required this.id,
    required this.reminderId,
    required this.time,
  });

  @override
  List<Object> get props => [id];

  factory ReminderTime.fromJson(Map<String, dynamic> data) {
    DateTime dateTime = DateFormat("h:mm a").parse(data['time']);
    TimeOfDay time = TimeOfDay.fromDateTime(dateTime);

    return ReminderTime(
      id: data['id'],
      reminderId: data['reminder_id'],
      time: time,
    );
  }

  static List<ReminderTime> fromJsonList(List list) {
    return list.map((item) => ReminderTime.fromJson(item)).toList();
  }
}
