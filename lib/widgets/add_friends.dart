import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database_services.dart';


class AddFriends extends StatefulWidget {
  const AddFriends({super.key});

  @override
  State<AddFriends> createState() => _friendsScreenState();
}

class _friendsScreenState extends State<AddFriends> {

  final _friendUsernameController = TextEditingController();
  Map<String,dynamic>? _foundUser;
  String _message = "";

  Future<void> _addFriend() async {
  final prefs = await SharedPreferences.getInstance();
  int? currentUserId = prefs.getInt('userID');

  if (currentUserId == null || _foundUser == null) return;

  await DatabaseServices.addFriend(currentUserId, _foundUser!['userID']);
  await DatabaseServices.addFriend(_foundUser!['userID'], currentUserId);

  setState(() {
    _message = "Friend added successfully!";
    _foundUser = null;
    _friendUsernameController.clear();
  });
}


  Future<void> _friendSearch() async{
  final prefs = await SharedPreferences.getInstance();
  int? currentUserId = prefs.getInt('userID');

  if (currentUserId == null) {
    setState(() {
      _message = "User not logged in.";
    });
    return;
  }

  String inputUsername = _friendUsernameController.text.trim();
  if (inputUsername.isEmpty) return;

  var user = await DatabaseServices.searchUserByUsername(inputUsername, currentUserId);

  setState(() {
    _foundUser = user;
    _message = user == null ? "No user found." : "";
  });


  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Add a friend"),
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Username input
            TextFormField(
              controller: _friendUsernameController,
              decoration: const InputDecoration(
                labelText: "Friend's Username",
                hintText: "Enter username",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // Search Button
            ElevatedButton(
              onPressed: _friendSearch,
              child: const Text("Search"),
            ),

            const SizedBox(height: 20),

            // Show found user card
            if (_foundUser != null)
              Card(
                child: ListTile(
                  title: Text(_foundUser!['userName']),
                  subtitle: Text("Email: ${_foundUser!['email']}"),
                  trailing: ElevatedButton(
                    onPressed: _addFriend,
                    child: const Text("Add"),
                  ),
                ),
              ),

            // Message (no user found, success, etc.)
            if (_message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _message,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

}