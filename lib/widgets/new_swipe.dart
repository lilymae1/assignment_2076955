import 'package:flutter/material.dart';

class NewSwipe extends StatefulWidget {
  const NewSwipe({super.key});

  @override
  State<NewSwipe> createState() => _swipeScreenState();
}


//get all films from tmdb 
//have a form to filter with toggles for ages and genre 
//get all relevent films 
//load releveant info inot cards then swipe them
//find a way to have a notif to another user when they log in and use that to start matching in your session? hard part 
//need to save the session 

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