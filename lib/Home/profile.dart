import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../login/login_screen.dart';
import '../util/constants.dart';
import '../util/drawer_menu.dart';

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
      drawer: const MenuDrawer(),
      appBar: AppBar(
        title: const Text('LDRP-ITR'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            position: PopupMenuPosition.under,
            itemBuilder: ((context) {
              return [
                PopupMenuItem(
                  child: const Text('Refresh'),
                  onTap: () {},
                ),
                PopupMenuItem(
                  child: const Text('Report'),
                  onTap: () {},
                ),
              ];
            }),
          ),
        ],
      ),
      body: RefreshIndicator(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Profile Image
              Center(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(uType)
                      .doc(uId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    // Check for errors
                    if (snapshot.hasError) {
                      return const Placeholder();
                    }

                    // Once complete, show your application
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircleAvatar(
                        radius: 80,
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Stack(
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundImage:
                                NetworkImage(snapshot.data!.data()!['photo']),
                          ),
                          Positioned(
                            bottom: 20,
                            right: 10,
                            child: InkWell(
                              onTap: () async {
                                await showAlert(context);
                                setState(() {});
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

                    // Otherwise, show something whilst waiting for initialization to complete
                  },
                ),
              ),

              //Student Profile Page Fields
              Visibility(
                visible:
                    userType == 'Student', //visible if usertype is 'Student'
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
                visible:
                    userType == 'Teacher', //visible if usertype is 'Teacher'
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
        onRefresh: () async {
          await FirebaseFirestore.instance
              .collection(uType)
              .doc(uId)
              .get()
              .then((value) {
            setState(() {
              photo = value['photo'];
            });
          });
        },
      ),
    );
  }

  //Edit image alert box code
  Future showAlert(context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  title: const Text(
                    "Choose Profile Photo",
                  ),
                  content: Container(
                    height: (this._imageFile != null) ? 170 : 80,
                    // margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                    child: (this._imageFile != null)
                        ? CircleAvatar(
                            radius: 80,
                            backgroundImage: FileImage(this._imageFile!),
                          )
                        : Row(
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
                                    onPressed: () async {
                                      await _pickImageFromCamera();
                                      setState(() {});
                                    },
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
                                    onPressed: () async {
                                      await _pickImageFromGallery();
                                      setState(() {});
                                    },
                                    tooltip: 'Pick from gallery',
                                  ),
                                  const Text('Gallery'),
                                ],
                              ),
                            ],
                          ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        _clearCatchImage();
                      },
                    ),
                    Visibility(
                      visible: this._imageFile != null,
                      child: TextButton(
                        child: const Text('Upload'),
                        onPressed: () async {
                          await _uploadImageToFirebaseStorage().then(
                            (value) {
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                )));
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
      this.setState(() {
        this._imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      this.setState(() {
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
        storageRef.putFile(this._imageFile!).whenComplete(() async {
          await _updateProfileImage();
        });
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
          .update({'photo': url})
          .then((value) => _clearCatchImage())
          .catchError((error) => print(error));
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
}
