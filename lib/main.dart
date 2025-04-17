import 'package:flutter/material.dart';
import 'widgets/login_screen.dart';
import 'widgets/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  final prefs = await SharedPreferences.getInstance();
  final bool loggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(filmSwiper(isLoggedIn: loggedIn));
}

class filmSwiper extends StatelessWidget {
  final bool isLoggedIn;

  const filmSwiper({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //hides debug banner
      home: isLoggedIn ? HomeScreen() : LoginScreen(), // default screen
    );
  }
}
