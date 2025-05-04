import 'package:flutter/material.dart';
import 'package:phoneme/screens/child_login_screen.dart';
import 'package:phoneme/screens/login_screen.dart';
import 'package:phoneme/screens/father_home.dart';
import 'package:phoneme/screens/parent_profile_screen.dart';
import 'package:phoneme/screens/specialist_dashboard.dart';
import 'package:phoneme/screens/child_home.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Define la ruta inicial
      routes: {
        '/': (context) => SplashScreen(), // Pantalla inicial (splash screen)
        '/login': (context) => LoginScreen(),
        '/father_home': (context) => FatherHomeScreen(),
        '/parent_profile': (context) => ParentProfileScreen(),
        '/specialist_dashboard': (context) => DashboardScreen(), // ID del especialista
        '/child_home': (context) => ChildHomeScreen(),
        '/child_login': (context) => LoginNinoScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login'); // Redirige a la pantalla de login
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/logo.png', width: 200, height: 200), // Logo del splash screen
      ),
    );
  }
}
