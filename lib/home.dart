import 'package:flutter/material.dart';
import '../Home/class.dart';
import '../Home/dashboard.dart';
import '../Home/live_class.dart';
import '../Home/profile.dart';
import 'util/constants.dart';
import 'util/drawer_menu.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  PageStorageBucket bucket = PageStorageBucket();
  final List screens = [
    const Dashboard(),
    const Classroom(),
    const LiveClass(),
    Profile(),
  ];
  Widget currentScreen = const Dashboard();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocalData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: (index == 0)
            ? const Text('Dashboard')
            : ((index == 1)
                ? const Text('Classroom')
                : ((index == 2)
                    ? const Text('LiveClass')
                    : const Text('User Profile'))),
        actions: [
          PopupMenuButton(
            position: PopupMenuPosition.under,
            itemBuilder: ((context) {
              return [
                PopupMenuItem(
                  child: const Text('Refresh'),
                  onTap: () {},
                ),
                PopupMenuItem(
                  child: const Text('Report'),
                  onTap: () {},
                ),
              ];
            }),
          ),
        ],
      ),
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        currentIndex: index,
        onTap: (index) {
          setState(() {
            this.index = index;
            currentScreen = screens[index];
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Classroom',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            label: 'Live Class',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_ind),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
