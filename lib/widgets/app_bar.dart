import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:running_society/theme.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;

  CustomAppBar(this.title) : preferredSize = Size.fromHeight(50.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      automaticallyImplyLeading: true,
      shadowColor: Colors.transparent,
      leading: GestureDetector(
        onTap: () {},
        child: Icon(
          CupertinoIcons.line_horizontal_3_decrease,
          color: CustomTheme.orangeTint,
        ),
      ),
    );
  }
}