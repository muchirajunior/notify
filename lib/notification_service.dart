import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

class NotificationService {
  static FlutterLocalNotificationsPlugin localNotificationsPlugin =  FlutterLocalNotificationsPlugin();

    static AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
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

  static Future<bool> requestPermissions() async {
    try {
     if(await Permission.notification.isDenied) {
        final PermissionStatus status = await Permission.notification.request();
        if (status.isGranted) {
          log('Notification permission granted');
        } else {
          log('Notification permission denied');
        }
        return status.isGranted;
      } else if (await Permission.notification.isPermanentlyDenied) {
        log('Notification permission permanently denied');
        return false;
      } else {
        log('Notification permission already granted');
        return true;
      }
    } catch (e) {
      log(e.toString(), name: 'NotificationService.requestPermissions');
      return false;
    }
  
  }

  @pragma('vm:entry-point')
  static  void callbackDispatcher() {
  Workmanager().executeTask((task, _) async {
    log('Workmanager task executed: $task');
    showNotification(plugin: localNotificationsPlugin, id: DateTime.now().microsecondsSinceEpoch, title: 'Hello User', body: 'This is a notification from the Notify App!');
    return Future.value(true);
  });
}
 
}