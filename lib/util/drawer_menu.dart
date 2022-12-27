import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../login/login_screen.dart';
import '../login/user_login.dart';
import 'constants.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 150,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'),
                fit: BoxFit.cover,
              )),
              child: Center(
                child: CircleAvatar(
                  radius: 40,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/dp.jpg',
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
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
                  Navigator.pushNamed(context, '/adminPanel');
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => const LogIn())));
                  await removeLocalData();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
