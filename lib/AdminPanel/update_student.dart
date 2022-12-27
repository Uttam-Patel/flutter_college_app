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
  String firstName = '';
  String middleName = '';
  String lastName = '';
  String emailId = '';
  String phoneNo = '';
  String semester1 = '';
  String year1 = '';
  String course1 = '';

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
  final Key = GlobalKey<FormState>();
  final key = GlobalKey<FormState>();
  final choiceKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Student'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 10),
          child: Form(
            key: Key,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              children: [
                //Student enrollment
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(),
                  child: TextFormField(
                    enabled: !isCorrect,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required field';
                      } else if (value.length < 11) {
                        return 'Enrollment number must be 11 characters';
                      }
                      return null;
                    },
                    controller: enrollment,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Student Enrollment',
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                  ),
                ),

                Visibility(
                  visible: isCorrect,
                  child: Column(
                    children: [
                      addProfileField(
                          'Name', '$lastName $firstName $middleName', false),
                      addProfileField('Email', emailId, false),
                      addProfileField('Phone', phoneNo, false),
                      addProfileField('Course', course1, false),
                      addProfileField('Year', year1, false),
                      addProfileField('Semester', semester1, false),
                    ],
                  ),
                ),

                //Get Student Data Button
                Visibility(
                  visible: !isCorrect,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (Key.currentState!.validate()) {
                        await getData();
                        setState(() {
                          isCorrect = !isCorrect;
                        });
                      }
                    },
                    child: const Text('View Student'),
                  ),
                ),
                Visibility(
                  visible: isCorrect,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Edit Details'),
                                scrollable: true,
                                content: Column(
                                  children: [
                                    Visibility(
                                      visible: index == null,
                                      child: Form(
                                        key: choiceKey,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: DropDownTextField(
                                            dropDownList: studentUpdateList,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please select a field';
                                              }
                                              return null;
                                            },
                                            dropDownItemCount: 5,
                                            dropdownRadius: 0,
                                            controller: choice,
                                            textFieldDecoration:
                                                InputDecoration(
                                              labelText: 'Select Field',
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                              errorBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.red,
                                                ),
                                              ),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: index != null,
                                      child: Form(
                                        key: key,
                                        autovalidateMode:
                                            AutovalidateMode.disabled,
                                        child: Column(
                                          children: [
                                            Column(
                                              children: [
                                                //First Name
                                                Visibility(
                                                  visible: index == 1,
                                                  child: AddTextField(
                                                    enabled: true,
                                                    controller: fName,
                                                    label: 'First Name',
                                                    keyboardType:
                                                        TextInputType.name,
                                                    obscureText: false,
                                                  ),
                                                ),

                                                //Middle Name
                                                Visibility(
                                                  visible: index == 3,
                                                  child: AddTextField(
                                                    enabled: true,
                                                    controller: mName,
                                                    label: 'Middle Name',
                                                    keyboardType:
                                                        TextInputType.name,
                                                    obscureText: false,
                                                  ),
                                                ),

                                                //Last Name
                                                Visibility(
                                                  visible: index == 2,
                                                  child: AddTextField(
                                                    enabled: true,
                                                    controller: lName,
                                                    label: 'Last Name',
                                                    keyboardType:
                                                        TextInputType.name,
                                                    obscureText: false,
                                                  ),
                                                ),

                                                //Email Id
                                                Visibility(
                                                  visible: index == 4,
                                                  child: AddTextField(
                                                    enabled: true,
                                                    controller: emailId1,
                                                    label: 'Email Id',
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    obscureText: false,
                                                  ),
                                                ),

                                                //Phone Number
                                                Visibility(
                                                  visible: index == 5,
                                                  child: AddTextField(
                                                    enabled: true,
                                                    controller: phone,
                                                    label: 'Phone Number',
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    obscureText: false,
                                                  ),
                                                ),

                                                //Course
                                                Visibility(
                                                  visible: index == 6,
                                                  child: DropTextField(
                                                    controller: course,
                                                    count: 5,
                                                    dropDownList: courseList,
                                                    label: 'Course',
                                                  ),
                                                ),

                                                //Year
                                                Visibility(
                                                  visible: index == 7,
                                                  child: DropTextField(
                                                    controller: year,
                                                    count: 4,
                                                    dropDownList: yearList,
                                                    label: 'Year',
                                                  ),
                                                ),

                                                //Semester
                                                Visibility(
                                                  visible: index == 8,
                                                  child: DropTextField(
                                                    controller: semester,
                                                    count: 5,
                                                    dropDownList: semesterList,
                                                    label: 'Semester',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        index = null;
                                      });
                                      Navigator.pop(context);
                                      choice.clearDropDown();
                                      fName.clear();
                                      mName.clear();
                                      lName.clear();
                                      emailId1.clear();
                                      phone.clear();
                                      course.clearDropDown();
                                      semester.clearDropDown();
                                      year.clearDropDown();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (choiceKey.currentState!.validate()) {
                                        index = choice.dropDownValue!.value;

                                        // choice.clearDropDown();
                                        // fName.clear();
                                        // mName.clear();
                                        // lName.clear();
                                        // emailId1.clear();
                                        // phone.clear();
                                        // course.clearDropDown();
                                        // semester.clearDropDown();
                                        // year.clearDropDown();
                                      }
                                      if (key.currentState!.validate()) {
                                        choice.clearDropDown();
                                        fName.clear();
                                        mName.clear();
                                        lName.clear();
                                        emailId1.clear();
                                        phone.clear();
                                        course.clearDropDown();
                                        semester.clearDropDown();
                                        year.clearDropDown();
                                      }
                                    },
                                    child: (index == null)
                                        ? Text('Next')
                                        : Text('Update'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text('Edit Details'),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Delete Account'),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getData() async {
    await FirebaseFirestore.instance
        .collection('Student')
        .doc(enrollment.text)
        .get()
        .then((value) {
      firstName = value['firstName'];
    });

    await FirebaseFirestore.instance
        .collection('Student')
        .doc(enrollment.text)
        .get()
        .then((value) {
      lastName = value['lastName'];
    });

    await FirebaseFirestore.instance
        .collection('Student')
        .doc(enrollment.text)
        .get()
        .then((value) {
      middleName = value['middleName'];
    });

    await FirebaseFirestore.instance
        .collection('Student')
        .doc(enrollment.text)
        .get()
        .then((value) {
      emailId = value['email'];
    });

    await FirebaseFirestore.instance
        .collection('Student')
        .doc(enrollment.text)
        .get()
        .then((value) {
      phoneNo = value['phone'];
    });

    await FirebaseFirestore.instance
        .collection('Student')
        .doc(enrollment.text)
        .get()
        .then((value) {
      semester1 = value['semester'];
    });

    await FirebaseFirestore.instance
        .collection('Student')
        .doc(enrollment.text)
        .get()
        .then((value) {
      year1 = value['year'];
    });

    await FirebaseFirestore.instance
        .collection('Student')
        .doc(enrollment.text)
        .get()
        .then((value) {
      course1 = value['course'];
    });
  }
}
