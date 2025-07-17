# Flutter Local Notifications Example

This example demonstrates how to use the `flutter_local_notifications` package to schedule and display notifications in a Flutter application.

## Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
    flutter_local_notifications: ^latest_version
```

Run `flutter pub get` to install the package.

## Basic Usage

### Initialization

Initialize the plugin in your `main.dart` file:

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
            InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    runApp(MyApp());
}
```

### Displaying a Notification

Use the following code to display a simple notification:

```dart
void showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
            AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        importance: Importance.high,
        priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
            NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        0,
        'Hello!',
        'This is a local notification.',
        notificationDetails,
    );
}
```

### Scheduling a Notification

Schedule a notification to appear at a specific time:

```dart
void scheduleNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
            AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        importance: Importance.high,
        priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
            NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Scheduled Notification',
        'This notification is scheduled.',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
    );
}
```

## Additional Resources

Refer to the [flutter_local_notifications documentation](https://pub.dev/packages/flutter_local_notifications) for more details and advanced features.