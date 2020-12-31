import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'constants.dart';

class Utils {
  static String formatDate(String date, String toFormat) {
    try {
      return DateFormat(toFormat).format(DateTime.parse(date));
    } catch (Exception) {
      return "";
    }
  }

  static void showLocalAppNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      String title,
      String body,
      {String payload = ''}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            EXP_CTRL_CHANNEL_ID, EXP_CTRL_CHANNEL_NAME, EXP_CTRL_CHANNEL_DESC,
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
            styleInformation: BigTextStyleInformation(''));
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: payload);
  }
}

extension DateConversion on String {
  int toMonth() {
    return DateFormat("yyyy-MM-dd").parse(this).month;
  }
}

extension SnackBarExtension on BuildContext {
  void showSnackBar(String message) {
    Scaffold.of(this).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
