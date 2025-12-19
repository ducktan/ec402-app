import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FCMService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initFCM(String jwt) async {
    final messaging = FirebaseMessaging.instance;

    // 1. Request permission
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    }

    // 2. Get FCM token
    String? token = await messaging.getToken();
    print("FCM TOKEN: $token");

    if (token != null) {
      await sendTokenToBackend(token, jwt);
    }

    // 3. Init local notification
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // 4. Listen foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message received: ${message.notification?.title}");

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_id',
              'channel_name',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    });
  }

  static Future<void> sendTokenToBackend(String token, String jwt) async {
    final res = await http.post(
      Uri.parse("http://192.168.23.1:5000/api/users/save-fcm-token"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $jwt",
      },
      body: jsonEncode({"fcmToken": token}),
    );
    print("Saved FCM token response: ${res.body}");
  }
}
