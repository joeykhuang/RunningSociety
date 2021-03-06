// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:running_society/config/config.dart';
import 'package:running_society/reservations_tab/reservations_tab.dart';
import 'package:running_society/widgets/navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';

import 'home_tab/home.dart';
import 'coaches_tab/coaches_tab.dart';
import 'login_tab/login_page.dart';
import 'profile_tab/profile_tab.dart';
import 'config/config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDBConnection();
  prefs = await SharedPreferences.getInstance();
  print("prefs instantiated");
  var userId = prefs?.getInt('userId');
  runApp(MyAdaptingApp(home: userId != null ? PlatformAdaptingHomePage(): LoginPage()));
}

class MyAdaptingApp extends StatelessWidget {
  final StatefulWidget home;
  const MyAdaptingApp({required this.home});

  @override
  Widget build(context) {
    // Either Material or Cupertino widgets work in either Material or Cupertino
    // Apps.
    return MaterialApp(
      title: 'Running Society',
      theme: ThemeData(
        // Use the green theme for Material widgets.
        primarySwatch: Colors.green,
      ),
      darkTheme: ThemeData.dark(),
      builder: (context, child) {
        return CupertinoTheme(
          data: CupertinoThemeData(),
          child: Material(child: child),
        );
      },
      home: home
    );
  }
}

// Shows a different type of scaffold depending on the platform.
//
// This file has the most amount of non-sharable code since it behaves the most
// differently between the platforms.
//
// These differences are also subjective and have more than one 'right' answer
// depending on the app and content.
class PlatformAdaptingHomePage extends StatefulWidget {
  @override
  _PlatformAdaptingHomePageState createState() =>
      _PlatformAdaptingHomePageState();
}

class _PlatformAdaptingHomePageState extends State<PlatformAdaptingHomePage> {
  var _selectedIndex = 0;
  List<Widget> _children = [];

  @override
  void initState() {
    super.initState();
    TencentImPlugin.initSDK(appid: appId.toString());
    _children = [
      HomeTab(),
      CoachesTab(prefs?.getString('role') == 'coach'),
      ReservationsTab(),
      ProfileTab()];
  }

  Widget _buildHomePage(BuildContext context) {
    return Scaffold(
      body: _children[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        onTabSelected: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        children: [
          CustomNavigationBarItem(
            icon: HomeTab.iosIcon.icon!,
            hasNotification: false,
          ),
          CustomNavigationBarItem(
            icon: CoachesTab.iosIcon.icon!,
            hasNotification: false,
          ),
          CustomNavigationBarItem(
              icon: ReservationsTab.iosIcon.icon!,
              hasNotification: false,
          ),
          CustomNavigationBarItem(
            icon: ProfileTab.iosIcon.icon!,
            hasNotification: false,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(context) {
    return Builder (
      builder: _buildHomePage,
    );
  }
}
