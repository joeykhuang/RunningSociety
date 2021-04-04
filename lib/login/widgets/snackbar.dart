import 'package:flutter/material.dart';

class CustomSnackBar {
  CustomSnackBar(BuildContext context, Widget content,
      {SnackBarAction? snackBarAction, Color backgroundColor = Colors.green}) {
    final snackBar = SnackBar(
      action: snackBarAction,
      backgroundColor: backgroundColor,
      content: content,
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.only(bottom: 40),
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}