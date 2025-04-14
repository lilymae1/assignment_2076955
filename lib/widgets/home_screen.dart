import 'package:flutter/material.dart';
import 'add_friends.dart';
import 'new_swipe.dart';
import 'update_account.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  
  late TabController _tabController;

  final List<Tab> _tabs = const [
    Tab(icon: Icon(Icons.home), text: 'Home'),
    Tab(icon: Icon(Icons.person), text: 'Add friends'),
    Tab(icon: Icon(Icons.movie), text: 'Start swiping'),
    Tab(icon: Icon(Icons.update), text: 'Update account')

  ];

  final List<Widget> _tabViews = const [
    Center(child: Text("🏠 Home Page", style: TextStyle(fontSize: 20))),
    AddFriends(),
    NewSwipe(),
    UpdateAccount()
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
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
