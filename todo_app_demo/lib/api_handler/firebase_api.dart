import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils.dart';

class FirebaseApi {
  ///This Method for create new Task in TodoList
  static Future createToDo({
    required String title,
    required String completeTask,
  }) async {
    var data = {
      "title": title,
      "completetask": completeTask,
    };
    log(data.toString());
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(title);

    Map<String, String> todoList = {
      "todoTitle": title,
      "completeTask": completeTask,
    };

    documentReference
        .set(todoList)
        .whenComplete(() => log("Added successfully"));
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
        return Utils.showToast("Completed successfully");
      }
    });
  }
}
