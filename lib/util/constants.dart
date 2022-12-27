import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String uType = '';
String uId = '';

Future setLocalData() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('uId', uId);
  pref.setString('uType', uType);
}

Future getLocalData() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  uType = pref.getString('uType') ?? uType;
  uId = pref.getString('uId') ?? uId;
}

Future removeLocalData() async {
  final pref = await SharedPreferences.getInstance();
  await pref.remove('uType');
  await pref.remove('uId');
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
