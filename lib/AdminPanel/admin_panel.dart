import 'package:flutter/material.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Panel',
        ),
        centerTitle: true,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.05,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/adminPanel/addStudent');
            },
            child: Card(
              elevation: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_add_alt,
                    size: 35,
                  ),
                  Text('New Student'),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/adminPanel/updateStudent');
            },
            child: Card(
              elevation: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_outline_outlined,
                    size: 35,
                  ),
                  Text('Update Student'),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/adminPanel/addTeacher');
            },
            child: Card(
              elevation: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.group_add_outlined,
                    size: 35,
                  ),
                  Text('New Teacher'),
                ],
              ),
            ),
          ),
          Card(
            elevation: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.group_outlined,
                  size: 35,
                ),
                Text('Update Teacher'),
              ],
            ),
          ),
          Card(
            elevation: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_home_work_outlined,
                  size: 35,
                ),
                Text('New Class'),
              ],
            ),
          ),
          Card(
            elevation: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home_work_outlined,
                  size: 35,
                ),
                Text('Update Class'),
              ],
            ),
          ),
          Card(
            elevation: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_available_outlined,
                  size: 35,
                ),
                Text('Add Event'),
              ],
            ),
          ),
          Card(
            elevation: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_repeat_outlined,
                  size: 35,
                ),
                Text('Update Event'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
