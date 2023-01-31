import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNewEvent extends StatefulWidget {
  const AddNewEvent({Key? key}) : super(key: key);

  @override
  State<AddNewEvent> createState() => _AddNewEventState();
}

class _AddNewEventState extends State<AddNewEvent> {
  final _formkey = GlobalKey<FormState>();
  int count = 0;

  TextEditingController _titlecontroller = TextEditingController();
  TextEditingController _coordinatorcontroller = TextEditingController();
  TextEditingController _aboutcontroller = TextEditingController();
  TextEditingController linkController = TextEditingController();
  DateTime? dueDate;
  DateTime? now = DateTime.now();
  String lableDate = "";
  String coverPhoto = "";
  File? _imageFile;
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Event"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              SizedBox(height: 12),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Title of Event";
                  }
                },
                controller: _titlecontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.teal,
                  )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.orange,
                    width: 3,
                  )),
                  labelText: "Event Title",
                  labelStyle: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(height: 15),
              InkWell(
                onTap: () async {
                  dueDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2025),
                  );
                  setState(() {
                    if (dueDate != null) {
                      lableDate = DateTimeFormat.format(dueDate!,
                          format: AmericanDateFormats.dayOfWeek);
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey)),
                  height: 60,
                  child: Center(
                      child: dueDate != null
                          ? Text(lableDate)
                          : Text("Chose Due Date")),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Coordinator Name";
                  }
                },
                controller: _coordinatorcontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.red,
                  )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.orange,
                    width: 3,
                  )),
                  labelText: "Coordinator",
                  labelStyle: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter About of Event";
                  }
                },
                maxLines: 10,
                controller: _aboutcontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.teal,
                  )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.orange,
                    width: 3,
                  )),
                  labelText: "About Event",
                  labelStyle: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Joining Link";
                  }
                },
                controller: linkController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.teal,
                  )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.orange,
                    width: 3,
                  )),
                  labelText: "Event Join Link",
                  labelStyle: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              IconButton(
                  onPressed: _pickImageFromGallery,
                  icon: Icon(Icons.browse_gallery)),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () async {
                      // Clear();
                    },
                    child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.blue,
                      ),
                      child: Center(
                          child: Text(
                        "Clear",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (_formkey.currentState!.validate() &&
                          _imageFile != null) {
                        await _uploadImageToFirebaseStorage();
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.blue,
                      ),
                      child: Center(
                          child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future SubmitDetails() async {
    await FirebaseFirestore.instance
        .collection('Events')
        .doc(_titlecontroller.text)
        .set({
      "Title": _titlecontroller.text,
      "Coordinator": _coordinatorcontroller.text,
      "About": _aboutcontroller.text,
      "Due Date": dueDate,
      "Link": coverPhoto,
      "joinLink": linkController.text,
      "createdLink": now,
    }).onError((error, _) => print('Error to creating a New Event : $error'));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New Event Created')),
    );
  }

  Future<void> _uploadImageToFirebaseStorage() async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('images/events/${_titlecontroller.text}');

    try {
      if (this._imageFile != null) {
        storageRef.putFile(this._imageFile!).whenComplete(() async {
          await _updateCoverImage();
          await SubmitDetails();
        });
      }
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message!),
      ));
    }
  }

  _updateCoverImage() async {
    coverPhoto = await _updateCoverPhotoPath();
  }

  Future<String> _updateCoverPhotoPath() async {
    final imgUrl = FirebaseStorage.instance
        .ref()
        .child('images/events/${_titlecontroller.text}')
        .getDownloadURL();
    return imgUrl;
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        this._imageFile = File(pickedFile.path);
      });
    }
  }
}
