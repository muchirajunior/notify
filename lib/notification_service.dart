import 'dart:developer';
import 'dart:isolate';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static FlutterLocalNotificationsPlugin localNotificationsPlugin =  FlutterLocalNotificationsPlugin();

    static AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@minimap/ic_launcher');
    static   final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    static final LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(defaultActionName: 'Notify');
     
 
  static  initialize(FlutterLocalNotificationsPlugin plugin)async{
    try {
     
       final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux,
      );
      await plugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
          // Handle notification response
          log('Notification tapped: ${notificationResponse.id}');
        },
      );
    } on Exception catch (e) {
      log(e.toString(), name: 'NotificationService.initialize');
    }
  }

  static Future<void> showNotification({
    required FlutterLocalNotificationsPlugin plugin,
    required int id,
    required String title,
    required String body,
  }) async {AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'com_notify_app',
      'com_notify_app',
      channelDescription: 'Notify App Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await plugin.show(id, title, body, platformChannelSpecifics);
  }


  static Future<void> runBGService() async {
    final ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(_backgroundHandler, receivePort.sendPort, debugName: 'NotificationServiceBackground');
    receivePort.listen((dynamic message) {
      // Handle messages from the background isolate
      log('Message from background isolate: $message');
    });
  }

  static Future<void> _backgroundHandler(SendPort port) async {
    final FlutterLocalNotificationsPlugin plugin =  FlutterLocalNotificationsPlugin();
    while (true) {
      
      await Future.delayed(const Duration(seconds: 5));
      final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux,
      );
      await plugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
          // Handle notification response
          log('Notification tapped: ${notificationResponse.id}');
        },
      );
      await NotificationService.showNotification(
        plugin: plugin,
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title: 'Background Notification',
        body: 'This is a notification from the background service!',
      );
      port.send('Background notification sent');
    }
  }
 
}