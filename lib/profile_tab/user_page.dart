import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class UserTab extends StatelessWidget {
  Widget _buildBody(BuildContext context) {
    return SafeArea(
        child: Container(
          child: Image(
            image: AssetImage('assets/img/Profile.png'),
          )
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }
}