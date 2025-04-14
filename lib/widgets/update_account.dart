import 'package:flutter/material.dart';

class UpdateAccount extends StatefulWidget {
  const UpdateAccount({super.key});

  @override
  State<UpdateAccount> createState() => _swipeScreenState();
}

class _swipeScreenState extends State<UpdateAccount> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Account"),
      ),
      body: SafeArea(child: Column(
        children: [
          
        ],
      )),
    );
  }
}