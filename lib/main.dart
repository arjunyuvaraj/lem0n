import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lemon/authentication/authentication_page.dart';
import 'package:lemon/firebase_options.dart';
import 'package:lemon/services/authentication_service.dart';
import 'package:lemon/theme/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // final authService = AuthenticationService();
  // await authService.addMockStudents("Bergen County Academies", count: 100);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lem0n',
      theme: lightTheme,
      home: AuthenticationPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
