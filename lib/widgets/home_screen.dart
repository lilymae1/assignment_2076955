import 'package:assignment_2076955/widgets/login_screen.dart';
import 'package:flutter/material.dart';
import 'add_friends.dart';
import 'new_swipe.dart';
import 'update_account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Widget> _tabViews;

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear login session

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  final List<Tab> _tabs = const [
    Tab(icon: Icon(Icons.home), text: 'Home'),
    Tab(icon: Icon(Icons.person), text: 'Add friends'),
    Tab(icon: Icon(Icons.movie), text: 'Start swiping'),
    Tab(icon: Icon(Icons.update), text: 'Update account'),
    Tab(icon: Icon(Icons.logout), text: 'Logout'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    _tabViews = [
      const Center(child: Text("Home Page", style: TextStyle(fontSize: 20))),
      const AddFriends(),
      const NewSwipe(),
      const UpdateAccount(),
      LogoutTab(logoutCallback: _logout),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeScreen'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabViews,
      ),
    );
  }
}

class LogoutTab extends StatefulWidget {
  final Future<void> Function() logoutCallback;

  const LogoutTab({super.key, required this.logoutCallback});

  @override
  State<LogoutTab> createState() => _LogoutTabState();
}

class _LogoutTabState extends State<LogoutTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.logoutCallback();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Logging out..."));
  }
}

