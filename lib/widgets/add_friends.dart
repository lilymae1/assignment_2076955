import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database_services.dart';


class AddFriends extends StatefulWidget {
  const AddFriends({super.key});

  @override
  State<AddFriends> createState() => _friendsScreenState();
}

class _friendsScreenState extends State<AddFriends> {

  final _friendIDController = TextEditingController();

  Future<void> _friendSearch() async{
    //use the database functions to find user and display based on search 
    //have an add button next to the record 
    //attach record to the fucntion which makes a new friend connection 
    //just do it as a follow for now then make the friendships request based?
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a friend"),
      ),
      body: SafeArea(child: Column(
        children: [
          TextFormField(
            controller: _friendIDController,
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