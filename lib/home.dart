import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
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
    const Profile(),
  ];
  Widget currentScreen = const Dashboard();

  List classNames = [];
  List<DropDownValueModel> classNamesDropDownList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: (index == 0)
            ? const Text('LDRP-ITR')
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
    if (uType.isEmpty) {
      await getLocalData().then((value) => FirebaseFirestore.instance
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
          }));
    } else {
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
          await setLocalData();
        }
      });
    }
  }

  Future getClassNames() async {
    if (uType == 'Admin') {
      await FirebaseFirestore.instance
          .collection('Class')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          classNames.add(doc["className"] +
              ' (' +
              doc["joinedYear"] +
              ' - ' +
              doc["finalYear"] +
              ')');
        });
      });

      if (uType == 'Teacher') {
        await FirebaseFirestore.instance
            .collection('Class')
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            if (uId == doc['mentorID']) {
              classNames.add(doc["className"] +
                  ' (' +
                  doc["joinedYear"] +
                  ' - ' +
                  doc["finalYear"] +
                  ')');
            }
          });
        });
      }
    }

    Future buildClassList() async {
      await getClassNames();
      for (int i = 0; i < classNames.length; i++) {
        setState(() {
          classNamesDropDownList
              .add(DropDownValueModel(name: classNames[i], value: [i]));
        });
      }
    }
  }
}
