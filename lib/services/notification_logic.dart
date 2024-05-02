import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminder_app/screens/Home.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationLogic {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationsDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
          "Schedule Reminder", " Don\'t Forget to Drink water",
          importance: Importance.max, priority: Priority.max),
    );
  }

  static Future init(BuildContext context, String uid) async {
    tz.initializeTimeZones();
    final android = AndroidInitializationSettings("time_workout");
    final settings = InitializationSettings(android: android);
    await _notifications.initialize(settings,
        onDidReceiveBackgroundNotificationResponse: (payload) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ));

      onNotifications.add(payload as String?);
    });
  }

  static Future showNotifications({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime dateTime,
  }) async {
    if (dateTime.isBefore(DateTime.now())) {
      dateTime = dateTime.add(Duration(days: 1));
    }

    _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      await _notificationsDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
