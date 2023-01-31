import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_college_app/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

String uType = '';
String uId = '';
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
String studentClass = '';
String photo = '';

//For class stream
String classNameStream = '';
String classJoinedYear = '';
String classFinalYear = '';

//For Events
String clicked_event_title = "";
String clicked_event_about = "";
String clicked_event_coordinator = "";
Timestamp? timestamp;
DateTime? clicked_event_duedate;
String? clicked_event_link;

Future setLocalData() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setString("uType", uType);
  sp.setString("email", email);
  sp.setString("uId", uId);
  sp.setString("fName", fName);
  sp.setString("mName", mName);
  sp.setString("lName", lName);
  sp.setString("course", course);
  sp.setString("studentClass", studentClass);
  sp.setString("phone", phone);
  sp.setString("department", department);
  sp.setString("photo", photo);
  sp.setString("year", year);
  sp.setString("accountType", accountType);
  sp.setString("semester", semester);
}

Future getLocalData() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  uType = sp.getString("uType") ?? uType;
  email = sp.getString("email") ?? email;
  uId = sp.getString("uId") ?? uId;
  fName = sp.getString("fName") ?? fName;
  mName = sp.getString(
        "mName",
      ) ??
      mName;
  lName = sp.getString(
        "lName",
      ) ??
      lName;
  course = sp.getString(
        "course",
      ) ??
      course;
  studentClass = sp.getString(
        "studentClass",
      ) ??
      studentClass;
  phone = sp.getString(
        "phone",
      ) ??
      phone;
  department = sp.getString(
        "department",
      ) ??
      department;
  photo = sp.getString(
        "photo",
      ) ??
      photo;
  year = sp.getString(
        "year",
      ) ??
      year;
  accountType = sp.getString(
        "accountType",
      ) ??
      accountType;
  semester = sp.getString(
        "semester",
      ) ??
      semester;
}

Future removeLocalData() async {
  final sp = await SharedPreferences.getInstance();
  await sp.remove('uType');
  await sp.remove('email');
  await sp.remove('uId');
  await sp.remove('fName');
  await sp.remove('mName');
  await sp.remove('lName');
  await sp.remove('course');
  await sp.remove('studentClass');
  await sp.remove('phone');
  await sp.remove('department');
  await sp.remove('photo');
  await sp.remove('year');
  await sp.remove('accountType');
  await sp.remove('semester');
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

//Dropdown Lists

const List<DropDownValueModel> yearList = [
  DropDownValueModel(name: '1st', value: '1st'),
  DropDownValueModel(name: '2nd', value: '2nd'),
  DropDownValueModel(name: '3rd', value: '3rd'),
  DropDownValueModel(name: '4th', value: '4th'),
];

const List<DropDownValueModel> semesterList = [
  DropDownValueModel(name: '1st', value: '1st'),
  DropDownValueModel(name: '2nd', value: '2nd'),
  DropDownValueModel(name: '3rd', value: '3rd'),
  DropDownValueModel(name: '4th', value: '4th'),
  DropDownValueModel(name: '5th', value: '5th'),
  DropDownValueModel(name: '6th', value: '6th'),
  DropDownValueModel(name: '7th', value: '7th'),
  DropDownValueModel(name: '8th', value: '8th'),
];

const List<DropDownValueModel> courseList = [
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

const List<DropDownValueModel> studentUpdateList = [
  DropDownValueModel(name: 'First Name', value: 1),
  DropDownValueModel(name: 'Last Name', value: 2),
  DropDownValueModel(name: 'Middle Name', value: 3),
  DropDownValueModel(name: 'Email', value: 4),
  DropDownValueModel(name: 'Phone', value: 5),
  DropDownValueModel(name: 'Course', value: 6),
  DropDownValueModel(name: 'Year', value: 7),
  DropDownValueModel(name: 'Semester', value: 8),
];
