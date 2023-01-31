import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_college_app/login/login_screen.dart';
import '../home.dart';
import 'constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Image.asset('assets/images/appicon.jpg')],
      ),
      nextScreen: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              userData();
              getLocalData();
              return HomePage();
            } else {
              return WelcomeScreen();
            }
          }),
      splashIconSize: 300,
      duration: 3000,
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
          studentClass = snapshot.data()!['class'];

          if (uType == 'Student') {
            semester = snapshot.data()!['semester'];
            year = snapshot.data()!['year'];
            course = snapshot.data()!['course'];
          }
          if (uType == 'Teacher') {
            department = snapshot.data()!['department'];
          }
        });
      }
    });
    await setLocalData();
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Welcome",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold))
        ],
      ),
      nextScreen: LogIn(),
      splashIconSize: 300,
      duration: 1800,
    );
  }
}
