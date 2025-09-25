import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lemon/authentication/authentication_page.dart';
import 'package:lemon/firebase_options.dart';
import 'package:lemon/theme/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lemon',
      theme: lightTheme,
      home: AuthenticationPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
