import 'package:flutter/material.dart';
import 'package:flutter_college_app/util/chat_room.dart';

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
              Tab(
                child: Column(
                  children: [
                    Icon(Icons.stream),
                    Text('Class Stream'),
                  ],
                ),
              ),
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
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: Text('Class Stream'),
            ),
            Center(
              child: Text('Notes'),
            ),
            Center(
              child: Text('Assignments'),
            ),
            Center(
              child: ClassChat(),
            ),
            Center(
              child: Text('Members'),
            ),
            Center(
              child: Text('Faculties'),
            ),
          ],
        ),
      ),
    );
  }
}
