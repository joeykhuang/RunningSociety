import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:running_society/config/db_utils.dart';
import 'package:running_society/theme.dart';
import 'package:running_society/variables.dart';
import 'package:running_society/widgets/app_bar.dart';
import 'package:running_society/widgets/widgets.dart';

import 'add_class_tab.dart';
import 'coach_detail_tab.dart';

class CoachesTab extends StatefulWidget {
  static const title = 'Coaches';
  static const androidIcon = Icon(Icons.music_note);
  static const iosIcon = Icon(CupertinoIcons.person_3_fill);

  final bool isCoach;
  const CoachesTab(this.isCoach);

  @override
  _CoachesTabState createState() => _CoachesTabState();
}

class _CoachesTabState extends State<CoachesTab> {

  int numCoaches = 0;
  late Results coaches;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getCoaches() async {
    numCoaches = await dbGetNumCoaches();
    coaches = await dbGetCoaches();
  }

  Widget _listBuilder(BuildContext context, int index) {
    if (numCoaches == 0) return Container();
    return SafeArea(
      top: false,
      bottom: false,
      child: Hero(
        tag: index,
        child: HeroAnimatingCoachCard(
          coach: coaches.elementAt(index).values![1] as String,
          image: coachImages[index],
          heroAnimation: AlwaysStoppedAnimation(0),
          onPressed: () => Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (context) => CoachDetailTab(
                id: coaches.elementAt(index).values![0] as int,
                coach: coaches.elementAt(index).values![1] as String,
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
      future: _getCoaches(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(child: Text('Waiting'));
        } else {
          return Scaffold(
            appBar: widget.isCoach ? CustomAppBar('Coaches', false, GestureDetector(
              onTap: () => Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context) => AddClassTab())),
              child: Icon(
                CupertinoIcons.add,
                color: CustomTheme.orangeTint,
              ),
            )) : CustomAppBar('Coaches', false),
            body: CustomScrollView(
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
            ),
          );
        }
      }
    );
  }
}
