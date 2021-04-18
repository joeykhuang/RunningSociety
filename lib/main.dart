// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:running_society/variables.dart';
import 'package:running_society/widgets/app_bar.dart';
import 'package:running_society/widgets/navigation_bar.dart';

import 'coaches_tab/coaches_tab.dart';
import 'home_tab/home.dart';
import 'profile_tab/profile_tab.dart';

void main() => runApp(MyAdaptingApp());

class MyAdaptingApp extends StatelessWidget {
  @override
  Widget build(context) {
    // Either Material or Cupertino widgets work in either Material or Cupertino
    // Apps.
    return MaterialApp(
      title: 'Adaptive Music App',
      theme: ThemeData(
        // Use the green theme for Material widgets.
        primarySwatch: Colors.green,
      ),
      darkTheme: ThemeData.dark(),
      builder: (context, child) {
        return CupertinoTheme(
          // Instead of letting Cupertino widgets auto-adapt to the Material
          // theme (which is green), this app will use a different theme
          // for Cupertino (which is blue by default).
          data: CupertinoThemeData(),
          child: Material(child: child),
        );
      },
      home: PlatformAdaptingHomePage(),
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
  final tabKey = GlobalKey();

  var _selectedIndex = 0;
  List<Widget> _children = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _children = [HomeTab(), CoachesTab(), ProfileTab()];
  }

  Widget _buildHomePage(BuildContext context, AsyncSnapshot<void> snapshot) {
    return Scaffold(
      appBar: CustomAppBar('Home'),
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
            icon: ProfileTab.iosIcon.icon!,
            hasNotification: false,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(context) {
    return FutureBuilder(
      future: refreshData(),
      builder: _buildHomePage,
    );
  }
}
