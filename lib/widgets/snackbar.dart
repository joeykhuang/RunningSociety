import 'package:flutter/material.dart';

class CustomSnackBar {
  CustomSnackBar(BuildContext context, Widget content,
      {SnackBarAction? snackBarAction, Color backgroundColor = Colors.deepOrangeAccent}) {
    final snackBar = SnackBar(
      action: snackBarAction,
      backgroundColor: backgroundColor,
      content: content,
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.only(left: 30, bottom: 40),
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}