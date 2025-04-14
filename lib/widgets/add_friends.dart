import 'package:flutter/material.dart';

class AddFriends extends StatefulWidget {
  const AddFriends({super.key});

  @override
  State<AddFriends> createState() => _friendsScreenState();
}

class _friendsScreenState extends State<AddFriends> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a friend"),
      ),
      body: SafeArea(child: Column(
        children: [
          TextFormField(
            controller: null,
            decoration: const InputDecoration(
            hintText: "Friends user ID",
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
              ),
            ),
          ),
        ],
      )),
    );
    //once logged in you can enter a user id for a friend code 
    //if it matches to an existing friends code it will add to an existing list of freinds??
    //friends list shows up, create a function to display all friends 
    //search on the left friends list and other widgets on the right 
    
  }
}