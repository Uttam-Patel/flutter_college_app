import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class MemberList extends StatefulWidget {
  final String className;
  const MemberList({super.key, required this.className});

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  List mPhoto = [];
  List firstName = [];
  List lastName = [];
  List enrollmentNo = [];

  @override
  void initState() {
    // TODO: implement initState
    getStudentDetailes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class Members'),
      ),
      body: ListView.builder(
          itemCount: mPhoto.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(mPhoto[index]),
              ),
              title: Text('${firstName[index]} ${lastName[index]}'),
              subtitle: Text('${enrollmentNo[index]}'),
            );
          }),
    );
  }

  Future getStudentDetailes() async {
    await FirebaseFirestore.instance
        .collection('Class')
        .doc(widget.className)
        .collection('Student')
        .get()
        .then((value) => value.docs.forEach((doc) {
              setState(() {
                mPhoto.add(doc['photo']);
                firstName.add(doc['firstName']);
                lastName.add(doc['lastName']);
                enrollmentNo.add(doc['enrollment']);
              });
            }));
  }
}

class TeacherList extends StatefulWidget {
  final String className;
  const TeacherList({super.key, required this.className});

  @override
  State<TeacherList> createState() => _TeacherListState();
}

class _TeacherListState extends State<TeacherList> {
  List mPhoto = [];
  List firstName = [];
  List lastName = [];
  List teacherID = [];

  @override
  void initState() {
    getTeacherDetailes();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class Members'),
      ),
      body: ListView.builder(
          itemCount: mPhoto.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(mPhoto[index]),
              ),
              title: Text('${firstName[index]} ${lastName[index]}'),
              subtitle: Text('${teacherID[index]}'),
            );
          }),
    );
  }

  Future getTeacherDetailes() async {
    await FirebaseFirestore.instance
        .collection('Class')
        .doc(widget.className)
        .collection('Teacher')
        .get()
        .then((value) => value.docs.forEach((doc) {
              setState(() {
                mPhoto.add(doc['photo']);
                firstName.add(doc['firstName']);
                lastName.add(doc['lastName']);
                teacherID.add(doc['teacherId']);
              });
            }))
        .onError((error, stackTrace) => print(error));
  }
}

class ClassMemberList extends StatefulWidget {
  const ClassMemberList({super.key});

  @override
  State<ClassMemberList> createState() => _ClassMemberListState();
}

class _ClassMemberListState extends State<ClassMemberList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Members'),
        centerTitle: true,
      ),
      body: MemberList(
          className:
              '${classNameStream} (${classJoinedYear} - ${classFinalYear})'),
    );
  }
}

class ClassTeacherList extends StatefulWidget {
  const ClassTeacherList({super.key});

  @override
  State<ClassTeacherList> createState() => _ClassTeacherListState();
}

class _ClassTeacherListState extends State<ClassTeacherList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Faculties'),
        centerTitle: true,
      ),
      body: TeacherList(
          className:
              '${classNameStream} (${classJoinedYear} - ${classFinalYear})'),
    );
  }
}
