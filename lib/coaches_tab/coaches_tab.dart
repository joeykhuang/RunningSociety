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
    if (index >= coaches.length) return Container();
    if (coaches.isEmpty) return Container();
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

  Widget _buildIos(BuildContext context, AsyncSnapshot<void> snapshot) {
    return SafeArea(
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          itemCount: coaches.length,
          itemBuilder: _listBuilder),
    );
  }

  @override
  Widget build(context) {
    return FutureBuilder(
      future: refreshData(),
      builder: _buildIos,
    );
  }
}
