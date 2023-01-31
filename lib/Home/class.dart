import 'package:flutter/material.dart';
import 'package:flutter_college_app/util/Classroom/chat_room.dart';
import 'package:flutter_college_app/util/Classroom/class_list.dart';
import 'package:flutter_college_app/util/Classroom/class_notes.dart';
import 'package:flutter_college_app/util/Classroom/member_list.dart';

import '../util/Classroom/class_streams.dart';
import '../util/constants.dart';

class Classroom extends StatelessWidget {
  const Classroom({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            overlayColor: MaterialStateProperty.all(Colors.blue),
            tabs: <Tab>[
              Tab(child: Text('Class Stream')),
              Tab(
                child: Text('Notes'),
              ),
              Tab(
                child: Text('Assignments'),
              ),
              Tab(
                child: Text('Chat'),
              ),
              Tab(
                child: Text('Members'),
              ),
              Tab(
                child: Text('Faculties'),
              )
            ]),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: (uType == 'Student')
                  ? ClassStream(
                      className: studentClass,
                    )
                  : ClassList(
                      nav: 's',
                    ),
            ),
            Center(
              child: (uType == 'Student')
                  ? ClassNotes(
                      className: studentClass,
                    )
                  : ClassList(
                      nav: 'n',
                    ),
            ),
            Center(
              child: Text('Assignments'),
            ),
            Center(
              child: (uType == 'Student')
                  ? ClassChat(
                      className: studentClass,
                    )
                  : ClassList(
                      nav: 'c',
                    ),
            ),
            Center(
              child: (uType == 'Student')
                  ? MemberList(
                      className: studentClass,
                    )
                  : ClassList(
                      nav: 'm',
                    ),
            ),
            Center(
              child: (uType == 'Student')
                  ? TeacherList(
                      className: studentClass,
                    )
                  : ClassList(
                      nav: 'f',
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
