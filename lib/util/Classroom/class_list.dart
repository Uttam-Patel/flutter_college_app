import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_college_app/util/Classroom/admin_chat.dart';

import '../constants.dart';
import 'teacher_notes.dart';
import 'teacher_stream.dart';

class ClassList extends StatefulWidget {
  final String nav;
  const ClassList({super.key, required this.nav});

  @override
  State<ClassList> createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  List className = [];
  List joinedYear = [];
  List finalYear = [];
  List classDepartment = [];
  List classSemester = [];
  List classMentor = [];
  List classPhoto = [];

  @override
  void initState() {
    getClasses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (className.isEmpty) {
      return const Center(
        child: Text('No Class Found'),
      );
    } else {
      return ListView.builder(
        itemCount: className.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
            child: InkWell(
              onTap: () {
                setState(() {
                  classNameStream = className[index];
                  classJoinedYear = joinedYear[index];
                  classFinalYear = finalYear[index];
                });
                switch (widget.nav) {
                  case 's':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddStream(),
                      ),
                    );
                    break;
                  case 'c':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminChat(),
                      ),
                    );
                    break;
                  case 'n':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddNotes(),
                      ),
                    );
                    break;
                  default:
                }
                if (widget.nav == 's') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddStream(),
                    ),
                  );
                }
                if (widget.nav == 'c') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminChat(),
                    ),
                  );
                }
                if (widget.nav == 'c') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminChat(),
                    ),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.lightBlue,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              className[index],
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            Text(
                              '${joinedYear[index]} - ${finalYear[index]}',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            Text(
                              '${classSemester[index]} - ${classDepartment[index]}',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            Text(
                              classMentor[index],
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(classPhoto[index]),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Future getClasses() async {
    if (uType == 'Admin') {
      await FirebaseFirestore.instance
          .collection('Class')
          .get()
          .then((value) => value.docs.forEach((doc) {
                setState(() {
                  className.add(doc['className']);
                  joinedYear.add(doc['joinedYear']);
                  finalYear.add(doc['finalYear']);
                  classDepartment.add(doc['department']);
                  classMentor.add(doc['mentor']);
                  classSemester.add(doc['semester']);
                  classPhoto.add(doc['photo']);
                });
              }));
    }

    if (uType == 'Teacher') {
      await FirebaseFirestore.instance
          .collection('Class')
          .get()
          .then((value) => value.docs.forEach((doc) {
                setState(() {
                  if (doc['mentorID'] == uId) {
                    className.add(doc['className']);
                    joinedYear.add(doc['joinedYear']);
                    finalYear.add(doc['finalYear']);
                    classDepartment.add(doc['department']);
                    classMentor.add(doc['mentor']);
                    classPhoto.add(doc['photo']);
                    classSemester.add(doc['semester']);
                  }
                });
              }));
    }
  }
}
