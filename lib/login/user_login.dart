import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_college_app/util/constants.dart';

import '../home.dart';
import 'login_screen.dart';

class UserLogIn extends StatefulWidget {
  final String user;
  final String idType;
  const UserLogIn({super.key, required this.user, required this.idType});

  @override
  State<UserLogIn> createState() => _UserLogInState();
}

class _UserLogInState extends State<UserLogIn> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? docSnap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //print Login usertype
          Text(
            'Log In as - ${widget.user}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(
            height: 30,
          ),

          //userId textfield
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 45),
            decoration: const BoxDecoration(),
            child: TextField(
              controller: idController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                border: InputBorder.none,
                hintText: '${widget.user} ${widget.idType}',
                hintStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.deepPurple,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),

          //password textfield
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 45),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                border: InputBorder.none,
                hintText: '${widget.user} Password',
                hintStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.deepPurple,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),

          //log in and back buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //log in button
                ElevatedButton(
                  onPressed: () async {
                    //set userType and userId as per choosen login type (Student, Teacher, Admin)

                    //wait for getEmail
                    await getEmail(widget.user, idController.text);
                    await logIn(widget.user, idController.text);
                  },
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                      const Size(200, 50),
                    ),
                  ),
                  child: Text('Login'),
                ),

                //back icon button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  //function to get user email using userId and store it in a variable
  Future getEmail(String collection, String id) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(id)
        .get()
        .then((value) => docSnap = value['email']);
  }

  //user log in function
  Future logIn(String collection, String id) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: docSnap ?? '0',
        password: passwordController.text,
      )
          .then((value) async {
        uType = widget.user;
        uId = idController.text;
        await setLocalData();
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
      });
    } on FirebaseAuthException catch (error) {
      print(error.message!);
    }
  }
}
