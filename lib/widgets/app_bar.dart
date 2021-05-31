import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:running_society/theme.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final bool poppable;
  final Widget? actions;

  CustomAppBar(this.title, this.poppable, [this.actions]) : preferredSize = Size.fromHeight(50.0);

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
      leading: !poppable ? GestureDetector(
        onTap: () {},
        child: Icon(
          CupertinoIcons.line_horizontal_3_decrease,
          color: CustomTheme.lemonTint,
        ),
        ) : GestureDetector(
        onTap: () {Navigator.of(context).pop();},
        child: Icon(
          CupertinoIcons.back,
          color: CustomTheme.lemonTint,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: this.actions,
        )
      ],
    );
  }
}