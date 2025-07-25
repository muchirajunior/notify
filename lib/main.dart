import 'package:flutter/material.dart';
import 'package:notify/home.dart';
import 'package:notify/notification_service.dart';
import 'package:workmanager/workmanager.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize(NotificationService.localNotificationsPlugin);
  Workmanager().initialize(
    NotificationService.callbackDispatcher,
    isInDebugMode: true,
  );
  Workmanager().registerPeriodicTask(
    'notify_task',
    'notify_task',
    frequency: const Duration(seconds: 15),
  
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notify App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
