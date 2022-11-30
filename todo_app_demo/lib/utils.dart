import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static String convertToAgo(String input) {
    DateTime time = DateTime.parse(input);
    Duration diff = DateTime.now().difference(time);
    if (diff.inDays > 3) {
      return "${time.day}/${time.month}/${time.year} date";
    } else if (diff.inDays >= 1) {
      return '${diff.inDays}d';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours}hr';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes}min';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds}sec';
    } else {
      return 'Just now';
    }
  }

  static Future<bool?> showToast({required String msg}) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
