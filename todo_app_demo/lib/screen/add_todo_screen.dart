import 'package:flutter/material.dart';
import 'dart:io';
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
  bool completeTask = false;
  final _formKey = GlobalKey<FormState>();

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
                                await FirebaseApi.createToDo(
                                    completeTask: '$completeTask',
                                    title: title);

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
}
