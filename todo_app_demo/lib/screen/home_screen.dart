import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../api_handler/firebase_api.dart';
import '../utils.dart';
import 'add_todo_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final _formKey = GlobalKey<FormState>();

class _MyHomePageState extends State<MyHomePage> {
  bool completeTask = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("MyTodos")
              .orderBy("createdTime", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else if (snapshot.hasData || snapshot.data != null) {
              return Stack(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        QueryDocumentSnapshot<Object?>? documentSnapshot =
                            snapshot.data?.docs[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2),
                          child: Slidable(
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          var taskTitle = documentSnapshot
                                                  ?.get("todoTitle") ??
                                              "";
                                          var taskDescription = documentSnapshot
                                                  ?.get("todoDesc") ??
                                              "";
                                          return customEditTodo(
                                              context: context,
                                              documentSnapshot:
                                                  documentSnapshot,
                                              onChangeDes: (String value) {
                                                setState(() {
                                                  if (value.isNotEmpty ||
                                                      value != null) {
                                                    taskDescription = value;
                                                  } else {
                                                    taskDescription =
                                                        documentSnapshot
                                                            ?.get("todoDesc");
                                                  }
                                                });
                                              },
                                              onChangeTitle: (String value) {
                                                setState(() {
                                                  if (value.isNotEmpty ||
                                                      value != null) {
                                                    taskTitle = value;
                                                  } else {
                                                    taskTitle = documentSnapshot
                                                            ?.get("todoDesc") ??
                                                        '';
                                                  }
                                                });
                                              },
                                              onTonPressed: () {
                                                final isValid = _formKey
                                                    .currentState
                                                    ?.validate();

                                                if (!isValid!) {
                                                  return;
                                                } else {
                                                  setState(() {});
                                                  FirebaseApi.editTodo(
                                                      (documentSnapshot != null)
                                                          ? (documentSnapshot
                                                              .id)
                                                          : "",
                                                      taskTitle,
                                                      taskDescription);

                                                  Navigator.of(context).pop();
                                                }
                                              });
                                        });
                                  },
                                  backgroundColor: const Color(0xFF0392CF),
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                ),
                              ],
                            ),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) => showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          alignment: Alignment.center,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          title: const Text(
                                            "Alart Message",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          content: SizedBox(
                                            width: 400,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                Text(
                                                    "Do You want To Delete This Item?")
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: () {
                                                  setState(() {});

                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("No")),
                                            TextButton(
                                                onPressed: () {
                                                  FirebaseApi.deleteTodo(
                                                      (documentSnapshot != null)
                                                          ? (documentSnapshot
                                                              .id)
                                                          : "");
                                                  setState(() {});

                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("yes"))
                                          ],
                                        );
                                      }),
                                  backgroundColor: const Color(0xFF0392CF),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      var taskTitle =
                                          documentSnapshot?.get("todoTitle") ??
                                              "";
                                      var taskDescription =
                                          documentSnapshot?.get("todoDesc") ??
                                              " ";
                                      var image =
                                          documentSnapshot?.get("taskImage") ??
                                              "";
                                      var createdTime = documentSnapshot
                                              ?.get("createdTime") ??
                                          "";

                                      return AlertDialog(
                                        alignment: Alignment.center,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        title: const Text("Todo Details"),
                                        content: SizedBox(
                                          width: 400,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              image != " "
                                                  ? const Text(
                                                      "Image",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18),
                                                    )
                                                  : const SizedBox(),
                                              SizedBox(
                                                height: image != "" ? 5 : 0,
                                              ),
                                              image != " "
                                                  ? ClipOval(
                                                      child: Container(
                                                        width: 50,
                                                        height: 50,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              const LinearGradient(
                                                            colors: <Color>[
                                                              Color(0xFF0D47A1),
                                                              Color(0xFF1976D2),
                                                              Color(0xFF42A5F5),
                                                            ],
                                                          ),
                                                          image: DecorationImage(
                                                              image:
                                                                  NetworkImage(
                                                                      image!),
                                                              fit:
                                                                  BoxFit.cover),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              SizedBox(
                                                height: image != " " ? 5 : 0,
                                              ),
                                              const Text(
                                                "Title",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                taskTitle,
                                                style: const TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 15),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              taskDescription != " "
                                                  ? const Text(
                                                      "Description",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18),
                                                    )
                                                  : const SizedBox(),
                                              SizedBox(
                                                height: taskDescription == " "
                                                    ? 5
                                                    : 0,
                                              ),
                                              taskDescription != " "
                                                  ? Text(
                                                      taskDescription,
                                                      style: const TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 15),
                                                    )
                                                  : const SizedBox(),
                                              SizedBox(
                                                height: taskDescription == " "
                                                    ? 5
                                                    : 0,
                                              ),
                                              createdTime != ""
                                                  ? const Text(
                                                      "CreatedTime",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18),
                                                    )
                                                  : const SizedBox(),
                                              SizedBox(
                                                height:
                                                    createdTime != "" ? 5 : 0,
                                              ),
                                              createdTime != ""
                                                  ? Text(
                                                      Utils.convertToAgo(
                                                          createdTime),
                                                      style: const TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 15),
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () {
                                                setState(() {});

                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Close"))
                                        ],
                                      );
                                    });
                              },
                              child: Card(
                                elevation: 4,
                                child: ListTile(
                                  leading: Checkbox(
                                    value:
                                        documentSnapshot?.get("completeTask") ==
                                                    "false" ||
                                                documentSnapshot
                                                        ?.get("completeTask") ==
                                                    null
                                            ? false
                                            : true,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null) {
                                          completeTask = !completeTask;
                                          FirebaseApi.editCheckBoxValue(
                                              (documentSnapshot != null)
                                                  ? (documentSnapshot.id)
                                                  : "",
                                              completeTask);
                                        } else {
                                          log("wrong .....");
                                        }
                                      });
                                    },
                                  ),
                                  title: Text(
                                    (documentSnapshot != null)
                                        ? (documentSnapshot["todoTitle"])
                                        : "",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        decoration:
                                            documentSnapshot?["completeTask"] ==
                                                    "true"
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("version 1.0.1"),
                          ))
                    ],
                  ),
                ],
              );
            } else if (snapshot.data == null) {
              return const Center(
                  child: Text(
                'No Todo Task',
                style: TextStyle(color: Colors.black, fontSize: 24),
              ));
            }
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.red,
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddTodoScreen()));
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

Widget customEditTodo(
    {required BuildContext context,
    required QueryDocumentSnapshot<Object?>? documentSnapshot,
    required void Function(String) onChangeDes,
    required void Function() onTonPressed,
    required void Function(String) onChangeTitle}) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    title: const Text("Edit Todo"),
    content: SizedBox(
      width: 400,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              maxLines: 1,
              initialValue: documentSnapshot?.get("todoTitle"),
              onChanged: onChangeTitle,
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
              height: 15,
            ),
            TextFormField(
              maxLines: 3,
              initialValue: documentSnapshot?.get("todoDesc"),
              onChanged: onChangeDes,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
            ),
          ],
        ),
      ),
    ),
    actions: <Widget>[
      TextButton(onPressed: onTonPressed, child: const Text("Edit"))
    ],
  );
}
