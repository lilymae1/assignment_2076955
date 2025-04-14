import 'package:flutter/material.dart';
import 'widgets/login_screen.dart';

void main() {
  runApp(const filmSwiper());
}

class filmSwiper extends StatelessWidget {
  const filmSwiper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //hides debug banner
      home: LoginScreen(), // default screen
    );
  }
}
