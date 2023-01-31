import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '/AdminPanel/admin_panel.dart';

import 'AdminPanel/add_class.dart';
import 'AdminPanel/add_student.dart';
import 'AdminPanel/add_teacher.dart';
import 'AdminPanel/update_student.dart';
import 'home.dart';
import 'login/login_screen.dart';

Future main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Roboto"),
      title: 'Login UI',
      home: LogIn(),
      // home: StreamBuilder(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: ((context, snapshot) {
      //     if (snapshot.hasData) {
      //       return Home();
      //     } else {
      //       return LogIn();
      //     }
      //   }),
      // ),
    );
  }
}
