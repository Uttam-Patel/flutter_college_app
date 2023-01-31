import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_college_app/AdminPanel/admin_panel.dart';
import '../login/login_screen.dart';
import 'constants.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  image: DecorationImage(
                      image: AssetImage("assets/images/bg.jpg"),
                      fit: BoxFit.cover),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                              radius: 70.0,
                              backgroundImage: NetworkImage(photo)),
                          Positioned(
                            bottom: 10.0,
                            right: 10.0,
                            child: InkWell(
                              onTap: () {},
                              child: Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
              Text(
                email,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const ListTile(
                leading: Icon(Icons.info),
                title: Text('About'),
              ),
              const ListTile(
                leading: Icon(Icons.help),
                title: Text('Help'),
              ),
              Visibility(
                visible: uType == 'Admin',
                child: ListTile(
                  leading: Icon(Icons.security),
                  title: Text('Admin Panel'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AdminPanel()));
                  },
                ),
              ),
              const ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Log Out'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut().then((value) async {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LogIn()),
                        (route) => false);
                    await removeLocalData();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
