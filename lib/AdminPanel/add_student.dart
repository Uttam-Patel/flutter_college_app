import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_password_generator/random_password_generator.dart';

import '../util/constants.dart';
import '../util/text_field.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  //TextEditingControllers
  final TextEditingController fName = TextEditingController();
  final TextEditingController mName = TextEditingController();
  final TextEditingController lName = TextEditingController();
  final TextEditingController enrollment = TextEditingController();
  final TextEditingController emailId = TextEditingController();
  final TextEditingController phone = TextEditingController();

  //SingleValueDropDownController
  final SingleValueDropDownController semester =
      SingleValueDropDownController();
  final SingleValueDropDownController course = SingleValueDropDownController();
  final SingleValueDropDownController year = SingleValueDropDownController();

  //Controller Dispose
  @override
  void dispose() {
    fName.dispose();
    mName.dispose();
    lName.dispose();
    emailId.dispose();
    enrollment.dispose();
    phone.dispose();
    course.dispose();
    semester.dispose();
    year.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Student'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 10),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              children: [
                //First Name
                AddTextField(
                  enabled: true,
                  controller: fName,
                  label: 'First Name',
                  keyboardType: TextInputType.name,
                  obscureText: false,
                ),

                //Middle Name
                AddTextField(
                  enabled: true,
                  controller: mName,
                  label: 'Middle Name',
                  keyboardType: TextInputType.name,
                  obscureText: false,
                ),

                //Last Name
                AddTextField(
                  enabled: true,
                  controller: lName,
                  label: 'Last Name',
                  keyboardType: TextInputType.name,
                  obscureText: false,
                ),

                //Enrollment Number
                AddTextField(
                  enabled: true,
                  controller: enrollment,
                  label: 'Enrollment Number',
                  keyboardType: TextInputType.name,
                  obscureText: false,
                ),

                //Email Id
                AddTextField(
                  enabled: true,
                  controller: emailId,
                  label: 'Email Id',
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                ),

                //Phone Number
                AddTextField(
                  enabled: true,
                  controller: phone,
                  label: 'Phone Number',
                  keyboardType: TextInputType.phone,
                  obscureText: false,
                ),

                //Course
                DropTextField(
                  controller: course,
                  count: 5,
                  dropDownList: courseList,
                  label: 'Course',
                ),

                //Year
                DropTextField(
                  controller: year,
                  count: 4,
                  dropDownList: yearList,
                  label: 'Year',
                ),

                //Semester
                DropTextField(
                  controller: semester,
                  count: 5,
                  dropDownList: semesterList,
                  label: 'Semester',
                ),

                //Buttons 'Create Student' and 'Clear'
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //'Create Student' Button
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            addUser();
                            await signUp();
                            passwordReset();
                          }
                        },
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(
                            const Size(150, 50),
                          ),
                        ),
                        child: Text('Create Student'),
                      ),

                      //'Clear' Button
                      ElevatedButton(
                        onPressed: () {
                          fName.clear();
                          mName.clear();
                          lName.clear();
                          emailId.clear();
                          enrollment.clear();
                          phone.clear();
                          course.clearDropDown();
                          semester.clearDropDown();
                          year.clearDropDown();
                        },
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(
                            const Size(150, 50),
                          ),
                        ),
                        child: Text('Clear'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Random Password Generator
  String getPassword() {
    final RandomPasswordGenerator randomPassword = RandomPasswordGenerator();
    String newPassword = randomPassword.randomPassword(
      passwordLength: 6,
      specialChar: true,
      letters: true,
      numbers: true,
      uppercase: false,
    );
    return newPassword;
  }

  Future addUser() async {
    await FirebaseFirestore.instance
        .collection('Student')
        .doc(enrollment.text)
        .set({
          'firstName': fName.text,
          'lastName': lName.text,
          'middleName': mName.text,
          'email': emailId.text,
          'enrollment': enrollment.text,
          'phone': phone.text,
          'course': course.dropDownValue!.value,
          'year': year.dropDownValue!.value,
          'semester': semester.dropDownValue!.value,
          'accountType': 'Student',
          'photo':
              'https://t4.ftcdn.net/jpg/00/97/00/09/360_F_97000908_wwH2goIihwrMoeV9QF3BW6HtpsVFaNVM.jpg',
        })
        .onError((error, _) => print('Error creating Student : $error'))
        .then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data Processing...')),
          );
        });
  }

  Future signUp() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailId.text.trim(),
        password: getPassword(),
      )
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student Created')),
        );
      });
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future passwordReset() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(
      email: emailId.text.trim(),
    )
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset mail sended')),
      );
    });
  }
}
