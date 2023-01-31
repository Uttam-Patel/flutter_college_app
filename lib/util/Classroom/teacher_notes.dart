import 'package:flutter/material.dart';

import '../constants.dart';
import 'class_notes.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Stream'),
        centerTitle: true,
      ),
      body: ClassNotes(
          className:
              '${classNameStream} (${classJoinedYear} - ${classFinalYear})'),
    );
  }
}
