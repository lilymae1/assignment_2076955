import 'package:flutter/material.dart';

class NewSwipe extends StatefulWidget {
  const NewSwipe({super.key});

  @override
  State<NewSwipe> createState() => _swipeScreenState();
}

class _swipeScreenState extends State<NewSwipe> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New swipe"),
      ),
      body: SafeArea(child: Column(
        children: [
          
        ],
      )),
    );
  }
}