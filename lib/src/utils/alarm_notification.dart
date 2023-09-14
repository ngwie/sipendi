import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

const channelId = 'sipendi_notification_1';
const channelName = 'sipendi_notification';

class AlarmNotification {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const initAndroid = AndroidInitializationSettings('mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: initAndroid);
    await _notification.initialize(initSettings);

    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  static Future<void> show({
    required int id,
    String? title,
    String? body,
  }) async {
    const androidNotificationDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      playSound: true,
      priority: Priority.high,
      importance: Importance.max,
    );
    const notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _notification.show(id, title, body, notificationDetails);
  }

  static Future<void> schedule({
    required int id,
    String? title,
    String? body,
    required TimeOfDay time,
  }) async {
    const androidNotificationDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      playSound: true,
      priority: Priority.high,
      importance: Importance.max,
    );
    const notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _notification.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(time),
      notificationDetails,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancel({required int id}) async {
    await _notification.cancel(id);
  }

  static tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);

    var scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
}
