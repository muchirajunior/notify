import 'package:flutter/material.dart';
import 'package:notify/notification_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: const Text('Notify App'),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to the Notify App!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () async{
                await NotificationService.requestPermissions(); 
                NotificationService.showNotification(
                  plugin: NotificationService.localNotificationsPlugin,
                  id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
                  title:  'Hello',
                  body:  'This is a notification from the Notify App!',
                );
              },
              child: const Text('Press Me'),
            ),
          ],
        ),
      ),
    );
  }
}