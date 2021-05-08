import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:running_society/variables.dart';
import 'package:running_society/widgets/widgets.dart';

import 'coach_detail_tab.dart';

class CoachesTab extends StatefulWidget {
  static const title = 'Coaches';
  static const androidIcon = Icon(Icons.music_note);
  static const iosIcon = Icon(CupertinoIcons.person_3_fill);

  @override
  _CoachesTabState createState() => _CoachesTabState();
}

class _CoachesTabState extends State<CoachesTab> {

  @override
  void initState() {
    super.initState();
  }

  Widget _listBuilder(BuildContext context, int index) {
    if (numCoaches == 0) return Container();
    return SafeArea(
      top: false,
      bottom: false,
      child: Hero(
        tag: index,
        child: HeroAnimatingCoachCard(
          coach: coaches[index],
          image: coachImages[index],
          heroAnimation: AlwaysStoppedAnimation(0),
          onPressed: () => Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (context) => CoachDetailTab(
                id: index,
                coach: coaches[index],
                image: coachImages[index],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    return FutureBuilder(
      future: refreshData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(child: Text('Waiting'));
        } else {
          return CustomScrollView(
            slivers: [
              SliverSafeArea(
                top: false,
                sliver: SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      _listBuilder,
                      childCount: numCoaches,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      }
    );
  }
}
