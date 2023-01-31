import 'package:flutter/material.dart';

import '../constants.dart';
import 'class_streams.dart';

class AddStream extends StatefulWidget {
  const AddStream({super.key});

  @override
  State<AddStream> createState() => _AddStreamState();
}

class _AddStreamState extends State<AddStream> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Stream'),
        centerTitle: true,
      ),
      body: ClassStream(
          className:
              '${classNameStream} (${classJoinedYear} - ${classFinalYear})'),
    );
  }
}
