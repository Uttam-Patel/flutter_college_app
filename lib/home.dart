import 'package:cloud_firestore/cloud_firestore.dart';
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
    userData();
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
                  onTap: () {
                    setState(() {
                      getLocalData();
                      userData();
                    });
                  },
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

  Future userData() async {
    await FirebaseFirestore.instance
        .collection(uType)
        .doc(uId)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          fName = snapshot.data()!['firstName'];
          lName = snapshot.data()!['lastName'];
          phone = snapshot.data()!['phone'];
          accountType = snapshot.data()!['accountType'];
          email = snapshot.data()!['email'];
          photo = snapshot.data()!['photo'];

          if (uType == 'Student') {
            semester = snapshot.data()!['semester'];
            year = snapshot.data()!['year'];
            course = snapshot.data()!['course'];
            studentClass = snapshot.data()!['class'];
          }
          if (uType == 'Teacher') {
            department = snapshot.data()!['department'];
          }
        });
      }
    });
  }
}
