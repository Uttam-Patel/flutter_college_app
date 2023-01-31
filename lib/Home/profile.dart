import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../login/login_screen.dart';
import '../util/constants.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser;

  final String userType = uType;

  final String userId = uId;

  File? _imageFile;
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Profile Image
            Center(
              child: FutureBuilder(
                future:
                    FirebaseFirestore.instance.collection(uType).doc(uId).get(),
                builder: (context, snapshot) {
                  // Check for errors
                  if (snapshot.hasError) {
                    return Container();
                  }

                  // Once complete, show your application
                  if (snapshot.connectionState == ConnectionState.done) {
                    return profileImage(context);
                  }

                  // Otherwise, show something whilst waiting for initialization to complete
                  return processIndicator();
                },
              ),
            ),

            //Student Profile Page Fields
            Visibility(
              visible: userType == 'Student', //visible if usertype is 'Student'
              child: Column(
                children: [
                  addProfileField('Name', '$lName $fName $mName', false),
                  addProfileField('Enrollment Number', userId, false),
                  addProfileField('Email Id', email, false),
                  addProfileField('Phone Number', phone, false),
                  addProfileField('Account Type', accountType, false),
                  addProfileField('Cource', course, false),
                  addProfileField('Year', year, false),
                  addProfileField('Semester', semester, false),
                ],
              ),
            ),
            //Teacher Profile Page Fields
            Visibility(
              visible: userType == 'Teacher', //visible if usertype is 'Teacher'
              child: Column(
                children: [
                  addProfileField('Name', '$lName $fName', false),
                  addProfileField('Teacher Id', userId, false),
                  addProfileField('Phone Number', phone, false),
                  addProfileField('Account Type', accountType, false),
                  addProfileField('Department', department, false),
                ],
              ),
            ),
            Visibility(
              visible: userType == 'Admin', //visible if usertype is 'Teacher'
              child: Column(
                children: [
                  addProfileField('Name', '$lName $fName', false),
                  addProfileField('Admin Id', userId, false),
                  addProfileField('Phone Number', phone, false),
                  addProfileField('Account Type', accountType, false),
                ],
              ),
            ),

            //Sign Out Button
            Center(
              child: ElevatedButton.icon(
                label: Text('Sign Out'),
                icon: Icon(Icons.logout),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then((value) async {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LogIn()),
                        (route) => false);
                    await removeLocalData();
                  });
                },
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(200, 50))),
              ),
            )
          ],
        ),
      ),
    );
  }

  //Edit image alert box code
  AlertDialog showAlert(context) {
    return AlertDialog(
      title: const Text(
        "Choose Profile Photo",
      ),
      content: Container(
        height: (this._imageFile == null) ? 80 : 170,
        // margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          children: [
            (this._imageFile != null) ? pickedImage() : chooseUploadOption()
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
            _clearCatchImage();
          },
        ),
        Visibility(
          visible: this._imageFile != null,
          child: TextButton(
            child: const Text('Upload'),
            onPressed: () async {
              await _uploadImageToFirebaseStorage();
              await _updateProfileImage();
              _clearCatchImage();
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }

  //Profile Image function code
  CircleAvatar processIndicator() {
    return CircleAvatar(
      radius: 80,
      child: CircularProgressIndicator(),
    );
  }

  Stack profileImage(context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 80,
          backgroundImage: NetworkImage(photo),
        ),
        Positioned(
          bottom: 20,
          right: 10,
          child: InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => showAlert(context));
            },
            child: const Icon(
              Icons.photo_camera,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
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

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        this._imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        this._imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImageToFirebaseStorage() async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('images/$uType/profiles/${fName}_$lName');

    try {
      if (this._imageFile != null) {
        storageRef.putFile(this._imageFile!);
      }
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message!),
      ));
    }
  }

  _updateProfileImage() async {
    if (this._imageFile != null) {
      String url = await _updateProfilePhotoPath();
      await FirebaseFirestore.instance
          .collection(uType)
          .doc(uId)
          .update({'photo': url}).catchError((error) => print(error));
    }
  }

  Future<String> _updateProfilePhotoPath() async {
    final imgUrl = FirebaseStorage.instance
        .ref()
        .child('images/$uType/profiles/${fName}_$lName')
        .getDownloadURL();
    return imgUrl;
  }

  void _clearCatchImage() {
    setState(() {
      this._imageFile = null;
    });
  }

  Row chooseUploadOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            IconButton(
              padding: EdgeInsets.all(0),
              icon: const Icon(
                Icons.photo_camera_outlined,
                size: 50,
              ),
              onPressed: () async => _pickImageFromCamera(),
              tooltip: 'Shoot picture',
            ),
            const Text('Camera'),
          ],
        ),
        Column(
          children: [
            IconButton(
              padding: EdgeInsets.all(0),
              icon: const Icon(
                Icons.photo_outlined,
                size: 50,
              ),
              onPressed: () async => _pickImageFromGallery(),
              tooltip: 'Pick from gallery',
            ),
            const Text('Gallery'),
          ],
        ),
      ],
    );
  }

  CircleAvatar pickedImage() {
    return CircleAvatar(
      radius: 80,
      backgroundImage: FileImage(this._imageFile!),
    );
  }
}
