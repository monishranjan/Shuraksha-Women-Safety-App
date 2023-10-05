import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shuraksha1/auth/main_page.dart';
import 'package:shuraksha1/util/background_services.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeService();

  runApp(const MyApp());
}

backgroundService() {
  FlutterBackgroundService().invoke('setAsBackground');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: const MaterialColor(0xffa4001a, <int, Color>{
          50: Color(0x1aa4001a),
          100: Color(0x33a4001a),
          200: Color(0x4da4001a),
          300: Color(0x66a4001a),
          400: Color(0x80a4001a),
          500: Color(0xffa4001a),
          600: Color(0x99a4001a),
          700: Color(0xb3a4001a),
          800: Color(0xcca4001a),
          900: Color(0xe6a4001a),
        }),
      ),
      home: MainPage(),
    );
  }
}