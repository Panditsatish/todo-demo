import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../utils.dart';

class FirebaseApi {
  ///This Method for create new Task in TodoList
  static Future createToDo(
      {required String title,
      String? description,
      required String completeTask,
      required DateTime createdTime,
      File? imageUrls}) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(title);
    print("hgjfkl$description");
    Map<String, String> todoList = {
      "todoTitle": title,
      "completeTask": completeTask,
      "createdTime": "$createdTime",
    };
    if (imageUrls != null) {
      String baseName = imageUrls.path.split('/').last;
      final imageUrl = await FirebaseStorage.instance
          .ref()
          .child("images/$baseName")
          .getDownloadURL();
      // ignore: unnecessary_string_interpolations
      todoList.putIfAbsent('taskImage', () => imageUrl);
    } else {
      todoList.putIfAbsent('taskImage', () => " ");
    }
    if (description != null) {
      // ignore: unnecessary_string_interpolations
      todoList.putIfAbsent('todoDesc', () => description);
    }

    documentReference
        .set(todoList)
        .whenComplete(() => Utils.showToast(msg: "Added successfully"));
  }

  ///This Method for delete task for TodoList
  static Future deleteTodo(item) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(item);

    documentReference
        .delete()
        .whenComplete(() => Utils.showToast(msg: "Deleted successfully"));
  }

  ///This Method for Editing the existing task in TodoList
  static Future editTodo(
    item,
    String title1,
    String description1,
  ) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(item);
    Map<String, String> todoList1 = {
      "todoTitle": title1,
      "todoDesc": description1
    };
    documentReference
        .update(todoList1)
        .whenComplete(() => Utils.showToast(msg: "Edited successfully"));
  }

  ///This Method for Changing  the status of existing task in TodoList ==>> isDone or Not
  static Future editCheckBoxValue(
    item,
    bool checkValue,
  ) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(item);

    // ignore: void_checks
    documentReference.update({"completeTask": "$checkValue"}).whenComplete(() {
      if (checkValue) {
        return Utils.showToast(msg: "Completed successfully");
      }
    });
  }
}
