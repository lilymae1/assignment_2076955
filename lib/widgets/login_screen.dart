import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'create_account.dart';
import '../services/database_services.dart'; // Import your DB functions
import 'debug_db_viewer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _loginNameController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  bool _isLoading = false;


  Future<void> _loginUser() async {
  setState(() => _isLoading = true);

  final username = _loginNameController.text.trim();
  final password = _loginPasswordController.text;

  if (username.isEmpty || password.isEmpty) {
    setState(() => _isLoading = false);
    _showDialog("Please enter both username and password.");
    return;
  }

  try {
    final dbService = DatabaseServices();
    final user = await dbService.getUserByUsername(username);

    if (user != null && user['password'] == password) {

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', username);//save login details

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      _showDialog("Incorrect username or password.");
    }
  } catch (e) {
    _showDialog("Something went wrong: $e");
  } finally {
    setState(() => _isLoading = false);
  }
}

void _showDialog(String message) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Login Failed"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        )
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _loginNameController,
                decoration: const InputDecoration(
                  hintText: "Enter User Name",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _loginPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Enter Password",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                onPressed: _loginUser,
                icon: const Icon(Icons.login),
                label: const Text("Login"),
              ),
              const SizedBox(
                height: 3,
                child: ColoredBox(color: Colors.purple),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateAccount()),
                  );
                },
                icon: const Icon(Icons.person),
                label: const Text("Create account"),
              ),
              const SizedBox(
                height: 3,
                child: ColoredBox(color: Colors.purple),
              ),
              ElevatedButton.icon(
                onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DebugDBViewer()),
                );
              },
                icon: const Icon(Icons.bug_report),
                label: const Text("Debug DB Viewer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
