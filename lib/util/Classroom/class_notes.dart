import 'dart:io';

import 'package:date_time_format/date_time_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../constants.dart';

class ClassNotes extends StatefulWidget {
  final String className;
  const ClassNotes({super.key, required this.className});

  @override
  State<ClassNotes> createState() => _ClassNotesState();
}

class _ClassNotesState extends State<ClassNotes> {
  File? file;
  List files = [];
  List fileNames = [];
  List fileSize = [];
  List fileType = [];
  List fileDownload = [];
  List fileDownloadLink = [];
  bool uploadCompleted = false;
  final postTime = DateTime.now();
  firebase_auth.User? user;
  late DatabaseReference firebaseMsgDbRef;

  final TextEditingController textController = TextEditingController();
  bool isComposing = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    this.firebaseMsgDbRef = FirebaseDatabase.instance
        .ref()
        .child('Notes/Classes/${widget.className}');
    this.user = firebase_auth.FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          buildNoteList(),
          const Divider(height: 2.0),
          buildNoteMsgRow()
        ],
      ),
    );
  }

  Widget buildNoteList() {
    return Flexible(
      child: Scrollbar(
        child: FirebaseAnimatedList(
          defaultChild: const Center(child: CircularProgressIndicator()),
          query: firebaseMsgDbRef,
          sort: (a, b) => b.key!.compareTo(a.key!),
          padding: const EdgeInsets.all(8.0),
          reverse: false,
          itemBuilder: (
            BuildContext ctx,
            DataSnapshot snapshot,
            Animation<double> animation,
            int idx,
          ) =>
              NoteMsgFromSnapshot(snapshot, animation),
        ),
      ),
    );
  }

  Widget NoteMsgFromSnapshot(
    DataSnapshot snapshot,
    Animation<double> animation,
  ) {
    final val = snapshot.value;
    if (val == null) {
      return Container();
    }
    final json = val as Map;
    final senderName = json['senderName'] as String? ?? '?? <unknown>';
    final msgText = json['text'] as String? ?? '??';
    final time = json['time'] as String? ?? '!!';
    final senderPhotoUrl = json['senderPhotoUrl'] as String? ?? '';
    final getFiles = json['files'] as List? ?? [];
    final getFileName = json['fileName'] as List? ?? [];
    final getFileType = json['fileType'] as List? ?? [];
    final messageUI = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(senderPhotoUrl),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          senderName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          time,
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(msgText),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: getFiles.length,
                  itemBuilder: (BuildContext context, int index) {
                    return (getFileType[index] == 'docx' ||
                            getFileType[index] == 'doc')
                        ? InkWell(
                            onTap: () async {
                              if (fileDownload[index] == null) {
                                await downloadFile(
                                  getFileName[index],
                                  getFileType[index],
                                  index,
                                );
                                openFile(
                                  getFileName[index],
                                  getFileType[index],
                                );
                              } else {
                                openFile(
                                  getFileName[index],
                                  getFileType[index],
                                );
                              }
                            },
                            child: Image.asset(
                              'assets/images/doc.png',
                              height: 50,
                              width: 30,
                              fit: BoxFit.cover,
                            ),
                          )
                        : (getFileType[index] == 'pdf')
                            ? InkWell(
                                onTap: () async {
                                  if (fileDownload[index] == null) {
                                    await downloadFile(
                                      getFileName[index],
                                      getFileType[index],
                                      index,
                                    );
                                    openFile(
                                      getFileName[index],
                                      getFileType[index],
                                    );
                                  } else {
                                    openFile(
                                      getFileName[index],
                                      getFileType[index],
                                    );
                                  }
                                },
                                child: Image.asset(
                                  'assets/images/pdf.png',
                                  height: 50,
                                  width: 30,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : (getFileType[index] == 'jpg' ||
                                    getFileType[index] == 'jpeg' ||
                                    getFileType[index] == 'png')
                                ? InkWell(
                                    onTap: () async {
                                      if (fileDownload[index] == null) {
                                        await downloadFile(
                                          getFileName[index],
                                          getFileType[index],
                                          index,
                                        );
                                        openFile(
                                          getFileName[index],
                                          getFileType[index],
                                        );
                                      } else {
                                        openFile(
                                          getFileName[index],
                                          getFileType[index],
                                        );
                                      }
                                    },
                                    child: Image.file(
                                      getFiles[index],
                                      height: 50,
                                      width: 30,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : InkWell(
                                    onTap: () async {
                                      if (fileDownload[index] == null) {
                                        await downloadFile(
                                          getFileName[index],
                                          getFileType[index],
                                          index,
                                        );
                                        openFile(
                                          getFileName[index],
                                          getFileType[index],
                                        );
                                      } else {
                                        openFile(
                                          getFileName[index],
                                          getFileType[index],
                                        );
                                      }
                                    },
                                    child: Image.asset(
                                      'assets/images/document.png',
                                      height: 50,
                                      width: 30,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: messageUI,
    );
  }

  Widget buildNoteMsgRow() {
    return Visibility(
      visible: uType == 'Teacher',
      child: Expanded(
        flex: (files.isEmpty) ? 0 : 1,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              (files.isEmpty)
                  ? Container()
                  : Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: files.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Flexible(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        (fileType[index] == 'docx' ||
                                                fileType[index] == 'doc')
                                            ? Image.asset(
                                                'assets/images/doc.png',
                                                height: 150,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              )
                                            : (fileType[index] == 'pdf')
                                                ? Image.asset(
                                                    'assets/images/pdf.png',
                                                    height: 150,
                                                    width: 100,
                                                    fit: BoxFit.cover,
                                                  )
                                                : (fileType[index] == 'jpg' ||
                                                        fileType[index] ==
                                                            'jpeg' ||
                                                        fileType[index] ==
                                                            'png')
                                                    ? Image.file(
                                                        files[index],
                                                        height: 120,
                                                        width: 100,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.asset(
                                                        'assets/images/document.png',
                                                        height: 150,
                                                        width: 100,
                                                        fit: BoxFit.cover,
                                                      ),
                                        Expanded(
                                          child: SizedBox(
                                            width: 150,
                                            child: Center(
                                                child: Text(
                                              '${fileNames[index]}',
                                              textAlign: TextAlign.center,
                                            )),
                                          ),
                                        ),
                                        ((fileSize[index] / (1024 * 1024)) >= 1)
                                            ? Text(
                                                '${(fileSize[index] / (1024 * 1024)).toStringAsFixed(2)} MB')
                                            : ((fileSize[index] / (1024)) >= 1)
                                                ? Text(
                                                    '${(fileSize[index] / (1024)).toStringAsFixed(2)} KB')
                                                : Text(
                                                    '${(fileSize[index] / (1024 * 1024)).toStringAsFixed(2)} B'),
                                      ],
                                    ),
                                    Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                files.remove(files[index]);
                                                fileNames
                                                    .remove(fileNames[index]);

                                                fileSize
                                                    .remove(fileSize[index]);
                                                fileType
                                                    .remove(fileType[index]);
                                              });
                                            },
                                            icon: Icon(Icons.cancel)))
                                  ],
                                )),
                          );
                        },
                      ),
                    ),
              IconButton(
                onPressed: () async {
                  await pickFile();
                },
                icon: (files.isEmpty)
                    ? Icon(Icons.file_upload_outlined)
                    : Icon(Icons.add_outlined),
              ),
              const Divider(height: 2.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      maxLength: null,
                      decoration: const InputDecoration(
                        hintText: "Write Note message",
                        border: InputBorder.none,
                      ),
                      controller: textController,
                      onChanged: (String text) =>
                          setState(() => isComposing = text.isNotEmpty),
                      onSubmitted: onNoteMsgSubmitted,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: (isComposing && (files.isNotEmpty))
                        ? () => onNoteMsgSubmitted(textController.text)
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onNoteMsgSubmitted(String text) async {
    // Clear input text field.
    await uploadFile();
    if (uploadCompleted) {
      await downloadLink();
      setState(() {
        isComposing = false;
        uploadCompleted = false;
      });
      firebaseMsgDbRef.push().set({
        'senderId': this.user!.uid,
        'senderName': fName + ' ' + lName,
        'senderPhotoUrl': photo,
        'text': text,
        'time': postTime.format('D, M j, H:i'),
        'files': fileDownloadLink,
        'fileName': fileNames,
        'fileType': fileType,
      });
    }
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final PlatformFile fileDetails = result.files.first;
      setState(() {
        file = File(result.files.single.path!);
        files.add(file);
        fileNames.add(fileDetails.name);
        fileSize.add(fileDetails.size);
        fileType.add(fileDetails.extension);
      });
    }
  }

  Future<void> uploadFile() async {
    int uploaded = 0;
    if (files.isNotEmpty) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('uploads/Notes/${widget.className}');
      for (var i = 0; i < files.length; i++) {
        try {
          storageRef
              .child('${fileNames[i]}')
              .putFile(files[i])
              .whenComplete(() {
            setState(() {
              uploaded += 1;
              if (uploaded == files.length) {
                uploadCompleted = true;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Upload Completed'),
                  ),
                );
              }
            });
          });
        } on FirebaseException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.message!),
          ));
        }
      }
    }
  }

  Future<void> downloadLink() async {
    if (files.isNotEmpty) {
      String downloadUrl;
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('uploads/Notes/${widget.className}');
      for (var i = 0; i < files.length; i++) {
        try {
          downloadUrl =
              await storageRef.child('${fileNames[i]}').getDownloadURL();
          setState(() {
            fileDownloadLink.add(downloadUrl);
          });
        } on FirebaseException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message!),
            ),
          );
        }
      }
    }
  }

  Future<void> downloadFile(String fileName, String fileExt, int index) async {
    final dir = await getApplicationDocumentsDirectory();
    final ref = FirebaseStorage.instance
        .ref()
        .child('uploads/Notes/${widget.className}/${fileName}.${fileExt}');
    final file = File('${dir.path}/${ref.name}');

    final downloadTask = ref.writeToFile(file);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Downloading ${ref.name}')),
          );
          break;
        case TaskState.paused:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task Paused')),
          );
          break;
        case TaskState.success:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Class Created')),
          );
          setState(() {
            fileDownload[index] = file;
          });
          break;
        case TaskState.canceled:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Downloaded ${ref.name}')),
          );
          break;
        case TaskState.error:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An Error Occured Downloading ${ref.name}')),
          );
          break;
      }
    });
  }

  Future openFile(String fileName, String fileExt) async {
    final dir = await getApplicationDocumentsDirectory();

    OpenFile.open('${dir.path}/${fileName}.${fileExt}');
  }
}

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
        title: const Text('Class Notes'),
        centerTitle: true,
      ),
      body: ClassNotes(
          className:
              '${classNameStream} (${classJoinedYear} - ${classFinalYear})'),
    );
  }
}
