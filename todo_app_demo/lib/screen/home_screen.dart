import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../api_handler/firebase_api.dart';
import 'add_todo_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final _formKey = GlobalKey<FormState>();

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
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
          stream: FirebaseFirestore.instance.collection("MyTodos").snapshots(),
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
                        );
                      }),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("version 1.0.0"),
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
