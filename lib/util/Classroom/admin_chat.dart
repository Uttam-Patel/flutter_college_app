import 'package:flutter/material.dart';
import 'package:flutter_college_app/util/Classroom/chat_room.dart';

import '../constants.dart';

class AdminChat extends StatefulWidget {
  const AdminChat({super.key});

  @override
  State<AdminChat> createState() => _AdminChatState();
}

class _AdminChatState extends State<AdminChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Chat'),
        centerTitle: true,
      ),
      body: ClassChat(
          className:
              '${classNameStream} (${classJoinedYear} - ${classFinalYear})'),
    );
  }
}
