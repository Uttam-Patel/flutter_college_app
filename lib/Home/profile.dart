import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login/login_screen.dart';
import '../util/constants.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser;

  final String userType = uType;

  final String userId = uId;

  String lName = '';
  String fName = '';
  String mName = '';
  String email = '';
  String phone = '';
  String course = '';
  String year = '';
  String semester = '';
  String department = '';
  String accountType = '';

  String photo = '';

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    userData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Profile Image
            Center(child: profileImage(context)),

            //Student Profile Page Fields
            Visibility(
              visible: userType == 'Student', //visible if usertype is 'Student'
              child: Column(
                children: [
                  addProfileField('Name', '$lName $fName $mName', false),
                  addProfileField('Enrollment Number', userId, false),
                  addProfileField('Email Id', email, false),
                  addProfileField('Phone Number', phone, false),
                  addProfileField('Account Type', accountType, false),
                  addProfileField('Cource', course, false),
                  addProfileField('Year', year, false),
                  addProfileField('Semester', semester, false),
                ],
              ),
            ),
            //Teacher Profile Page Fields
            Visibility(
              visible: userType == 'Teacher', //visible if usertype is 'Teacher'
              child: Column(
                children: [
                  addProfileField('Name', '$lName $fName', false),
                  addProfileField('Teacher Id', userId, false),
                  addProfileField('Phone Number', phone, false),
                  addProfileField('Account Type', accountType, false),
                  addProfileField('Department', department, false),
                ],
              ),
            ),
            Visibility(
              visible: userType == 'Admin', //visible if usertype is 'Teacher'
              child: Column(
                children: [
                  addProfileField('Name', '$lName $fName', false),
                  addProfileField('Admin Id', userId, false),
                  addProfileField('Phone Number', phone, false),
                  addProfileField('Account Type', accountType, false),
                ],
              ),
            ),

            //Sign Out Button
            Center(
              child: ElevatedButton.icon(
                label: Text('Sign Out'),
                icon: Icon(Icons.logout),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then((value) async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => LogIn())));
                    await removeLocalData();
                  });
                },
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(200, 50))),
              ),
            )
          ],
        ),
      ),
    );
  }

  //Edit image alert box code
  AlertDialog showAlert(context) {
    return AlertDialog(
      title: const Text(
        "Choose Profile Photo",
      ),
      content: Container(
        height: 60,
        // margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.file_upload_outlined,
            size: 50,
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Upload'),
          onPressed: () {},
        ),
      ],
    );
  }

  //Profile Image function code
  Stack profileImage(context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 80,
          backgroundImage: NetworkImage(photo),
        ),
        Positioned(
          bottom: 20,
          right: 10,
          child: InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => showAlert(context));
            },
            child: const Icon(
              Icons.photo_camera,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

//Profile Page Build
  Container addProfileField(String label, String fieldText, bool enabled) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            enabled: enabled,
            decoration: InputDecoration(
              labelText: fieldText,
              border: const OutlineInputBorder(),
            ),
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

          if (userType == 'Student') {
            semester = snapshot.data()!['semester'];
            year = snapshot.data()!['year'];
            course = snapshot.data()!['course'];
          }
          if (userType == 'Teacher') {
            department = snapshot.data()!['department'];
          }
        });
      }
    });
  }
}
