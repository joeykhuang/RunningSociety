import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:running_society/config/config.dart';
import 'package:running_society/login_tab/login_page.dart';

class ProfileTab extends StatelessWidget {
  static const title = 'Profile';
  static const androidIcon = Icon(Icons.person);
  static const iosIcon = Icon(CupertinoIcons.person_fill);

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
              child: Image(
                image: AssetImage('assets/img/Profile.png'),
              )
          ),
          CupertinoButton(
            child: Text("Logout"),
            onPressed: () async {
              await prefs?.clear();
              Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(builder: (context) => LoginPage()));
            })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }
}
