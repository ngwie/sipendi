import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../utils/alarm_notification.dart';
import '../../utils/sqlite_db.dart';
import '../models/reminder.dart';

part 'reminder_event.dart';
part 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  ReminderBloc() : super(ReminderInitial()) {
    on<ReminderFetched>((event, emit) async {
      try {
        emit(ReminderLoading(reminders: state.reminders));

        final List<Reminder> reminders = await _getReminders();

        emit(ReminderSuccess(reminders: {...reminders}));
      } catch (error) {
        emit(ReminderError(
          error: error.toString(),
          reminders: state.reminders,
        ));
      }
    });

    on<ReminderAdded>((event, emit) async {
      try {
        final reminder = await _insertReminder(
          event.reminderContext,
          event.referenceId,
          event.referenceName,
          event.reminderTimes,
        );

        await _setAlarm(reminder);
      } catch (error) {
        emit(ReminderError(
          error: error.toString(),
          reminders: state.reminders,
        ));
      }
    });

    on<ReminderRemoved>((event, emit) async {
      try {
        final reminder = await _getReminder(event.id);

        await _cancelAlarm(reminder);
        await _deleteReminder(event.id);
      } catch (error) {
        emit(ReminderError(
          error: error.toString(),
          reminders: state.reminders,
        ));
      }
    });
  }

  Future<Reminder> _insertReminder(
    String reminderContext,
    int referenceId,
    String referenceName,
    List<String> reminderTimes,
  ) async {
    final reminderId = await SqliteDb.client.insert('reminder', {
      'active': 1,
      'context': reminderContext,
      'reference_id': referenceId,
      'reference_name': referenceName,
      'recurrence_type': 'every_day',
    });

    Batch batch = SqliteDb.client.batch();
    for (var time in reminderTimes) {
      batch.insert(
        'reminder_time',
        {'reminder_id': reminderId, 'time': time},
      );
    }
    await batch.commit(noResult: true);

    return await _getReminder(reminderId);
  }

  Future<List<Reminder>> _getReminders() async {
    final reminders = await SqliteDb.client.query('reminder');
    final reminderTimes = await SqliteDb.client.query('reminder_time');

    return reminders.map((reminder) {
      final times = reminderTimes
          .where((time) => time['reminder_id'] == reminder['id'])
          .toList();
      return Reminder.fromJson({...reminder, 'time_list': times});
    }).toList();
  }

  Future<Reminder> _getReminder(int id) async {
    final reminders = await SqliteDb.client.query(
      'reminder',
      where: 'id = ?',
      whereArgs: [id],
    );
    final reminderTimes = await SqliteDb.client.query(
      'reminder_time',
      where: 'reminder_id = ?',
      whereArgs: [id],
    );

    return Reminder.fromJson({...reminders.first, 'time_list': reminderTimes});
  }

  Future<void> _deleteReminder(int id) async {
    await SqliteDb.client.delete(
      'reminder_time',
      where: 'reminder_id = ?',
      whereArgs: [id],
    );

    await SqliteDb.client.delete(
      'reminder',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> _setAlarm(Reminder reminder) async {
    String title = '';
    String body = '';

    if (reminder.context == 'taking_medicine') {
      title = 'Pengingat Obat';
      body = 'Waktunya minum obat ${reminder.referenceName}';
    } else {
      title = 'Pengingat';
      body = 'Waktunya mengukur ${reminder.referenceName}';
    }

    for (var reminderTime in reminder.times) {
      await AlarmNotification.schedule(
        id: reminderTime.id,
        time: reminderTime.time,
        title: title,
        body: body,
      );
    }
  }

  Future<void> _cancelAlarm(Reminder reminder) async {
    for (var reminderTime in reminder.times) {
      await AlarmNotification.cancel(id: reminderTime.id);
    }
  }
}
