import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../api_handler/firebase_api.dart';
import '../utils.dart';

// ignore: must_be_immutable
class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  String title = "";
  String description = "";
  String imageUrl = "";
  bool completeTask = false;
  DateTime createdTime = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  // ignore: prefer_final_fields
  quill.QuillController _controller = quill.QuillController.basic();
  File? imageFile;

  uploadFile() async {
    // ignore: prefer_const_declarations
    final path = 'Task/Image';
    final file = File(imageFile!.path);
    final ref =
        await FirebaseStorage.instance.ref().child(path).getDownloadURL();
    // ref.putFile(file);
    print("=====>>>>>>>>>>>>>>>>>>>>>>>>>>>>$ref");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Add Todo List"),
              centerTitle: true,
            ),
            body: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 35,
                      ),
                      if (imageFile != null)
                        InkWell(
                          onTap: () {
                            customBottomSheet(context);
                          },
                          child: ClipOval(
                            child: Container(
                              width: 150,
                              height: 150,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: <Color>[
                                    Color(0xFF0D47A1),
                                    Color(0xFF1976D2),
                                    Color(0xFF42A5F5),
                                  ],
                                ),
                                image: DecorationImage(
                                    image: FileImage(imageFile!),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                        )
                      else
                        InkWell(
                          onTap: () {
                            customBottomSheet(context);
                          },
                          child: ClipOval(
                            child: Container(
                              width: 150,
                              height: 150,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: <Color>[
                                    Color(0xFF0D47A1),
                                    Color(0xFF1976D2),
                                    Color(0xFF42A5F5),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(55.0),
                              ),
                              child: const Text(
                                'Image Appear Here',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        maxLines: 1,
                        initialValue: title,
                        onChanged: (String value) {
                          title = value;
                        },
                        validator: (title) {
                          if (title?.isEmpty == true) {
                            return 'The title cannot be empty';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Title',
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      quill.QuillToolbar.basic(
                          showAlignmentButtons: true,
                          toolbarIconSize: 18,
                          multiRowsDisplay: false,
                          controller: _controller),
                      Container(
                        height: 100,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            //  color: Colors.green,
                            border: Border.all(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(context).size.width,
                        child: quill.QuillEditor.basic(
                          keyboardAppearance: Brightness.dark,
                          controller: _controller,
                          readOnly: false, // true for view only mode
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 25),
                        width: MediaQuery.of(context).size.width,
                        height: 42,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5)),
                        child: TextButton(
                            onPressed: () async {
                              final isValid = _formKey.currentState?.validate();

                              if (!isValid!) {
                                return;
                              } else {
                                if (imageFile != null) {
                                  await uploadeImages(imageFile!.path);
                                }
                                setState(() {});
                                await FirebaseApi.createToDo(
                                    imageUrls: imageFile,
                                    description:
                                        _controller.document.toPlainText(),
                                    completeTask: '$completeTask',
                                    createdTime: createdTime,
                                    title: title);

                                print(
                                    " =====>>>>>>>>>>>>>>>>>>>>>>>>>>>>11$imageUrl");
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text(
                              "Add",
                              style: TextStyle(color: Colors.white),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }

  void getImage({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(
      source: source,
    );

    if (file?.path != null) {
      print("====>>>>>>   gfdfgfg");
      setState(() {
        imageFile = File(file!.path);

        //  uploadeImages(file.path);
      });
      Navigator.pop(context);
    }
  }

  customBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder:
            (BuildContext context, void Function(void Function()) setState) {
          return Container(
              margin: const EdgeInsets.only(
                top: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      gradient: const LinearGradient(
                        colors: <Color>[
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF42A5F5),
                        ],
                      ),
                    ),
                    child: TextButton(
                        onPressed: () => getImage(source: ImageSource.camera),
                        child: const Text('From Camera ',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      gradient: const LinearGradient(
                        colors: <Color>[
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF42A5F5),
                        ],
                      ),
                    ),
                    child: TextButton(
                        onPressed: () => getImage(source: ImageSource.gallery),
                        child: const Text('From Gallery',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white))),
                  ),
                  const SizedBox(
                    height: 25,
                  )
                ],
              ));
        });
      },
    );
  }

  uploadeImages(String? file) async {
    //showAlertDialog(context);
    final file1 = File(file!);

    String fileName = file.split('/').last;

    final metadata = SettableMetadata(contentType: "image/jpeg");

    final storageRef = FirebaseStorage.instance.ref();

    final uploadTask =
        storageRef.child("images/$fileName").putFile(file1, metadata);

    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);

          print("Upload is $progress% complete.");

          Utils.showToast(msg: "Please wait due image is uploading...");
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
          Navigator.of(context).pop();
          //  showToast(context, "error");

          // Handle unsuccessful uploads
          break;
        case TaskState.success:
          print("TaskState success");
          Utils.showToast(msg: " Image is uploaded..");

          break;
      }
    });
  }
}
