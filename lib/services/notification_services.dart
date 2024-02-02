import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<String> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('password_icon');
    
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      //onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, 
      iOS: initializationSettingsIOS, 
      macOS: null
    );
    
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);//onSelectNotification: selectNotification);

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails("String", "String", importance: Importance.max, priority: Priority.high);

    String pin = Random().nextInt(999999).toString(); 
    await flutterLocalNotificationsPlugin.show(1, 'Pin de contraseña', pin,
      const NotificationDetails(android: androidDetails),
    );

    return pin;
  }

}