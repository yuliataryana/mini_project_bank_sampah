import 'package:flutter/material.dart';
import 'package:mini_project_bank_sampah/view/pages/history_page.dart';
import 'package:mini_project_bank_sampah/view/pages/home_page.dart';
import 'package:mini_project_bank_sampah/view/pages/notification_page.dart';
import 'package:mini_project_bank_sampah/view/pages/profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // create scaffold with body tabbarview,
    // and bottom navigation bar
    // there is 4 items [home,history,notification,profile]

    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: const [
          HomePage(),
          HistoryPage(),
          // NotificationPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabController.index,
        onTap: (index) {
          _tabController.animateTo(index);
        },
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_edu_outlined),
            label: "History",
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.notifications),
          //   label: "Notification",
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
