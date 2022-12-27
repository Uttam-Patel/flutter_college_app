import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_password_generator/random_password_generator.dart';

import '../util/text_field.dart';

class AddTeacher extends StatefulWidget {
  const AddTeacher({super.key});

  @override
  State<AddTeacher> createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  //TextEditingControllers
  final TextEditingController fName = TextEditingController();
  final TextEditingController lName = TextEditingController();
  final TextEditingController emailId = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController tid = TextEditingController();

  //SingleValueDropDownController
  final SingleValueDropDownController department =
      SingleValueDropDownController();

  //Dropdown Lists

  final List<DropDownValueModel> departmentList = const [
    DropDownValueModel(
        name: 'Computer Engineering', value: 'Computer Engineering'),
    DropDownValueModel(
        name: 'Information Technology', value: 'Information Technology'),
    DropDownValueModel(
        name: 'Electronics and Comunication',
        value: 'Electronics and Comunication'),
    DropDownValueModel(name: 'Civil Engineering', value: 'Civil Engineering'),
    DropDownValueModel(
        name: 'Mechanical Engineering', value: 'Mechanical Engineering'),
    DropDownValueModel(
        name: 'Electrical Engineering', value: 'Electrical Engineering'),
    DropDownValueModel(
        name: 'Automobile Engineering', value: 'Automobile Engineering'),
    DropDownValueModel(
        name: 'Science and Humanities', value: 'Science and Humanities'),
    DropDownValueModel(name: 'MBA', value: 'MBA'),
    DropDownValueModel(name: 'MCA', value: 'MCA'),
  ];

  //Controller Dispose
  @override
  void dispose() {
    fName.dispose();
    lName.dispose();
    emailId.dispose();
    phone.dispose();
    department.dispose();
    tid.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Teacher'),
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

                //Last Name
                AddTextField(
                  enabled: true,
                  controller: lName,
                  label: 'Last Name',
                  keyboardType: TextInputType.name,
                  obscureText: false,
                ),

                //Teacher ID
                AddTextField(
                  enabled: true,
                  controller: tid,
                  label: 'Teacher ID',
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
                  controller: department,
                  count: 5,
                  dropDownList: departmentList,
                  label: 'Department',
                ),

                //Buttons 'Create Teacher' and 'Clear'
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //'Create Teacher' Button
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
                        child: Text('Create Teacher'),
                      ),

                      //'Clear' Button
                      ElevatedButton(
                        onPressed: () {
                          fName.clear();
                          lName.clear();
                          emailId.clear();
                          phone.clear();
                          tid.clear();
                          department.clearDropDown();
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
        .collection('Teacher')
        .doc(tid.text)
        .set({
          'firstName': fName.text,
          'lastName': lName.text,
          'email': emailId.text,
          'teacherId': tid.text,
          'phone': phone.text,
          'department': department.dropDownValue!.value,
          'accountType': 'Teacher',
          'photo':
              'https://t4.ftcdn.net/jpg/00/97/00/09/360_F_97000908_wwH2goIihwrMoeV9QF3BW6HtpsVFaNVM.jpg',
        })
        .onError((error, _) => print('Error creating Teacher : $error'))
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
          const SnackBar(content: Text('Teacher Created')),
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
