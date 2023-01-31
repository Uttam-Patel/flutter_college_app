import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

import '../util/constants.dart';
import '../util/text_field.dart';

class AddClass extends StatefulWidget {
  const AddClass({super.key});

  @override
  State<AddClass> createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  final TextEditingController className = TextEditingController();
  final TextEditingController finalYear = TextEditingController();
  final TextEditingController initYear = TextEditingController();
  final SingleValueDropDownController teachers =
      SingleValueDropDownController();
  final SingleValueDropDownController department =
      SingleValueDropDownController();
  final SingleValueDropDownController semester =
      SingleValueDropDownController();

  List<String> teacherID = [];
  List<String> teacherF = [];
  List<String> teacherL = [];
  List<DropDownValueModel> teachersList = [];
  List selectedTeachers = [];
  List tPhoto = [];

  @override
  void initState() {
    buildTeachersList();
    super.initState();
  }

  //Controller Dispose
  @override
  void dispose() {
    className.dispose();
    department.dispose();
    semester.dispose();
    initYear.dispose();
    finalYear.dispose();
    teachers.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Class'),
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
                //Class Name
                AddTextField(
                  enabled: true,
                  controller: className,
                  label: 'Class Name',
                  keyboardType: TextInputType.name,
                  obscureText: false,
                ),

                DropTextField(
                  controller: department,
                  count: 5,
                  dropDownList: courseList,
                  label: 'Department',
                ),

                DropTextField(
                  controller: semester,
                  count: 6,
                  dropDownList: semesterList,
                  label: 'Semester',
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid year';
                        } else if (value.length != 4) {
                          return 'Please enter 4 character year';
                        }
                        return null;
                      },
                      controller: initYear,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Joining Year',
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid year';
                        } else if (value.length != 4) {
                          return 'Please enter 4 character year';
                        }
                        return null;
                      },
                      controller: finalYear,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Finish Year',
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                    ),
                  ),
                ),

                //Add Teachers
                DropTextField(
                  controller: teachers,
                  count: 6,
                  dropDownList: teachersList,
                  label: 'Mentor',
                ),

                //Buttons 'Create Class' and 'Clear'
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //'Create Student' Button
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            print(selectedTeachers);
                            await createClass();
                          }
                        },
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(
                            const Size(150, 50),
                          ),
                        ),
                        child: Text('Create Class'),
                      ),

                      //'Clear' Button
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            className.clear();
                            initYear.clear();
                            finalYear.clear();
                            teachers.setDropDown(null);
                            semester.setDropDown(null);
                            department.setDropDown(null);
                          });
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

  Future getTeacherNames() async {
    await FirebaseFirestore.instance
        .collection('Teacher')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          teacherID.add(doc["teacherId"]);
          teacherL.add(doc["lastName"]);
          teacherF.add(doc["firstName"]);
          tPhoto.add(doc['photo']);
        });
      });
    });
  }

  Future buildTeachersList() async {
    await getTeacherNames();
    for (int i = 0; i < teacherID.length; i++) {
      setState(() {
        teachersList.add(DropDownValueModel(
            name: "${teacherID[i]} - ${teacherF[i]}  ${teacherL[i]}",
            value: i));
      });
    }
  }

  Future createClass() async {
    await FirebaseFirestore.instance
        .collection('Class')
        .doc('${className.text} (${initYear.text} - ${finalYear.text})')
        .set({
          'className': className.text,
          'department': department.dropDownValue!.value,
          'joinedYear': initYear.text,
          'finalYear': finalYear.text,
          'semester': semester.dropDownValue!.value,
          'mentor': teachers.dropDownValue!.name,
          'mentorID': teacherID[teachers.dropDownValue!.value],
          'mentorLastName': teacherL[teachers.dropDownValue!.value],
          'mentorFirstName': teacherF[teachers.dropDownValue!.value],
          'photo': tPhoto[teachers.dropDownValue!.value]
        })
        .onError((error, _) => print('Error creating Class : $error'))
        .then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Class Created')),
          );
        });
    await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(teacherID[teachers.dropDownValue!.value])
        .update({
          'Class': FieldValue.arrayUnion(
              ['${className.text} (${initYear.text} - ${finalYear.text})']),
        })
        .onError((error, _) => print('Error creating Class : $error'))
        .then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Class Created')),
          );
        });

    await FirebaseFirestore.instance
        .collection('Class')
        .doc('${className.text} (${initYear.text} - ${finalYear.text})')
        .collection('Teacher')
        .doc(teacherID[teachers.dropDownValue!.value])
        .set({
      'teacherID': teacherID[teachers.dropDownValue!.value],
      'firstName': teacherF[teachers.dropDownValue!.value],
      'lastName': teacherL[teachers.dropDownValue!.value],
      'name': teachersList[teachers.dropDownValue!.value],
      'photo': tPhoto[teachers.dropDownValue!.value],
    });
  }
}
