import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../login_tab/login_page.dart';

class ProfileTab extends StatelessWidget {
  static const title = 'Profile';
  static const androidIcon = Icon(Icons.person);
  static const iosIcon = Icon(CupertinoIcons.person_fill);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      home: LoginPage(),
    );
  }
}
