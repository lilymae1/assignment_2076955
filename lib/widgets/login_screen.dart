import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'create_account.dart';
import '../services/database_services.dart'; // Import your DB functions

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginNameController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  Future<void> _loginUser() async {
    final username = _loginNameController.text.trim();
    final password = _loginPasswordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showDialog("Please enter both username and password.");
      return;
    }

    final dbService = DatabaseServices(); // create an instance
    final user = await dbService.getUserByUsername(username);

    if (user != null && user['password'] == password) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      _showDialog("Incorrect username or password.");
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
              ElevatedButton.icon(
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
            ],
          ),
        ),
      ),
    );
  }
}
