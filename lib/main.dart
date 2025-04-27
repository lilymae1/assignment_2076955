import 'package:flutter/material.dart';
import 'widgets/login_screen.dart';
import 'widgets/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'services/notification_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  final prefs = await SharedPreferences.getInstance();
  final bool loggedIn = prefs.getBool('isLoggedIn') ?? false;

  await Firebase.initializeApp();

  await NotificationService.initialize();
  runApp(filmSwiper(isLoggedIn: loggedIn));
}



class filmSwiper extends StatelessWidget {
  final bool isLoggedIn;

  const filmSwiper({super.key, required this.isLoggedIn});

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false, //hides debug banner
      home: isLoggedIn ? HomeScreen() : LoginScreen(), // default screen
    );
  }
}
