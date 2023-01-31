import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../util/constants.dart';
import '../util/text_field.dart';
import '../Home/profile.dart';

class UpdateStudent extends StatefulWidget {
  const UpdateStudent({super.key});

  @override
  State<UpdateStudent> createState() => _UpdateStudentState();
}

class _UpdateStudentState extends State<UpdateStudent> {
  //TextEditingControllers
  final TextEditingController enrollment = TextEditingController();
  final TextEditingController fName = TextEditingController();
  final TextEditingController mName = TextEditingController();
  final TextEditingController lName = TextEditingController();
  final TextEditingController emailId1 = TextEditingController();
  final TextEditingController phone = TextEditingController();

  //SingleValueDropDownController
  final SingleValueDropDownController semester =
      SingleValueDropDownController();
  final SingleValueDropDownController course = SingleValueDropDownController();
  final SingleValueDropDownController year = SingleValueDropDownController();
  final SingleValueDropDownController choice = SingleValueDropDownController();
  final SingleValueDropDownController studentClass =
      SingleValueDropDownController();

  //Controller Dispose
  @override
  void dispose() {
    fName.dispose();
    mName.dispose();
    lName.dispose();
    emailId1.dispose();
    enrollment.dispose();
    phone.dispose();
    course.dispose();
    semester.dispose();
    year.dispose();
    super.dispose();
    choice.dispose();
  }

  int? index;
  bool isNext = true;
  bool isCorrect = false;
  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Student'),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AddTextField(
                enabled: true,
                label: 'Student Enrollment',
                obscureText: false,
                controller: enrollment,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          enrollment.clear();
                        });
                      },
                      child: Text('Clear'),
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                          Size(150, 50),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (key.currentState!.validate()) {
                          await getStudentData();
                        }
                      },
                      child: const Text('Submit'),
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                          Size(150, 50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getStudentData() async {
    await FirebaseFirestore.instance
        .collection('Student')
        .doc(enrollment.text)
        .get()
        .then(
      (value) {
        setState(() {
          fName.text = value['firstName'];
          lName.text = value['lastName'];
          mName.text = value['middleName'];
          emailId1.text = value['email'];
          phone.text = value['phone'];
          course.setDropDown(value['course']);
          year.setDropDown(value['year']);
          semester.setDropDown(value['semester']);
          studentClass.setDropDown(value['class']);
        });
      },
    ).onError((error, _) {
      print('error => $error');
    });
  }
}
