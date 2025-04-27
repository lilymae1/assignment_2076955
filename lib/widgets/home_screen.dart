import 'package:assignment_2076955/widgets/login_screen.dart';
import 'package:flutter/material.dart';
import 'add_friends.dart';
import 'new_swipe.dart';
import 'update_account.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database_services.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late Timer _refreshTimer;

  List<Map<String, dynamic>> _friends = [];
  int? _userID;

  late TabController _tabController;

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
    _loadFriends();

    _refreshTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _loadFriends(),
    );

    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        _loadFriends(); // Refresh when switching back to Home tab
      }
    });
  }

  Future<void> _loadFriends() async {
    final prefs = await SharedPreferences.getInstance();
    int? userID = prefs.getInt('userID');
    if (userID != null) {
      List<Map<String, dynamic>> friends = await DatabaseServices.getFriends(userID);
      setState(() {
        _userID = userID;
        _friends = friends;
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear login session

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshTimer.cancel();
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
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to Home Page',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your Friends',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 80,
                  child: _friends.isEmpty
                      ? const Text("You haven't added any friends yet.")
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _friends.length,
                          itemBuilder: (context, index) {
                            final friend = _friends[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Chip(
                                avatar: const Icon(Icons.person),
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(friend['userName']),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () async {
                                        await DatabaseServices.deleteFriend(_userID!, friend['userID']);
                                        await DatabaseServices.deleteFriend(friend['userID'], _userID!);
                                        _loadFriends();
                                      },
                                      child: const Icon(Icons.close, size: 18, color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const Divider(),
                const SizedBox(height: 20),
                const Text(
                  'Home Content Goes Here...',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          AddFriends(onFriendAdded: _loadFriends),
          NewSwipe(sessionId: ''),
          const UpdateAccount(),
          LogoutTab(logoutCallback: _logout),
        ],
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
