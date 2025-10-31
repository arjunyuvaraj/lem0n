import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lemon/utilities/codes.dart';

class NotificationService {
  // Singleton instance
  NotificationService._privateConstructor();
  static final NotificationService instance =
      NotificationService._privateConstructor();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize notifications (foreground & iOS permissions)
  Future<void> initializeNotifications() async {
    print("[NotificationService] Initializing...");

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
        "[NotificationService] Foreground message received: ${message.messageId}",
      );
      final notification = message.notification;

      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'default_channel_id',
              'Default Channel',
              channelDescription: 'Default channel for notifications',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
        );
      }
    });
  }

  /// Internal: Send a notification to a single FCM token via Node.js server
  static Future<void> _sendToServer({
    required String token,
    required String title,
    required String body,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token, 'title': title, 'body': body}),
      );

      if (response.statusCode != 200) {
        print(
          '[NotificationService] Failed to send notification to $token: ${response.body}',
        );
      } else {
        print('[NotificationService] Notification sent to $token');
      }
    } catch (e) {
      print('[NotificationService] Error sending notification to $token: $e');
    }
  }

  /// Send a notification to the current device
  static Future<void> sendToCurrentDevice({
    required String title,
    required String body,
  }) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) {
        print('[NotificationService] FCM token not ready yet.');
        return;
      }
      await _sendToServer(token: token, title: title, body: body);
    } catch (e) {
      print(
        '[NotificationService] Error sending notification to current device: $e',
      );
    }
  }

  /// Get FCM token for a specific user UID
  static Future<String?> getTokenForUser(String uid) async {
    final currentSchool = Codes().currentSchool;
    final doc = await FirebaseFirestore.instance
        .collection(currentSchool)
        .doc(currentSchool)
        .collection('Students')
        .doc(uid)
        .get();

    if (doc.exists) {
      final token = doc.data()?['fcmToken'];
      print('[NotificationService] Token for $uid: $token');
      return token;
    } else {
      print('[NotificationService] No document found for user $uid');
      return null;
    }
  }

  /// Send a notification to multiple users (e.g., "next five")
  static Future<void> sendToUsers({
    required List<String> uids,
    required String title,
    required String body,
  }) async {
    for (String uid in uids) {
      final token = await getTokenForUser(uid);
      if (token != null) {
        await _sendToServer(token: token, title: title, body: body);
      } else {
        print('[NotificationService] No FCM token found for user $uid');
      }
    }
  }
}
