import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lemon/authentication/authentication_page.dart';
import 'package:lemon/services/notification_service.dart';
import 'package:lemon/firebase_options.dart';
import 'package:lemon/theme/light_theme.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handles background messages
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Background message received: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Request permissions
  await _requestNotificationPermission();

  // Initialize NotificationService singleton
  await NotificationService.instance.initializeNotifications();

  runApp(const MyApp());
}

Future<void> _requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');

    // Listen for when token becomes available
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      print('FCM Token (ready): $token');
      // Save token to Firestore
    });

    // Optional: try to get token once immediately
    try {
      String? token = await messaging.getToken();
      if (token != null) {
        print('FCM Token (initial attempt): $token');
        // Save token to Firestore
      }
    } catch (e) {
      print('FCM Token not ready yet: $e');
      // Will be picked up by onTokenRefresh
    }
  } else {
    print('User declined or has not accepted permission');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // Listen for notification taps
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked: ${message.data}');
      // TODO: Navigate or handle notification tap
    });

    return MaterialApp(
      title: 'Lem0n',
      theme: lightTheme,
      home: AuthenticationPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
