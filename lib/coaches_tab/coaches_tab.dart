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
  final _androidRefreshKey = GlobalKey<RefreshIndicatorState>();

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

  void _togglePlatform() {
    TargetPlatform _getOppositePlatform() {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        return TargetPlatform.android;
      } else {
        return TargetPlatform.iOS;
      }
    }

    debugDefaultTargetPlatformOverride = _getOppositePlatform();
    // This rebuilds the application. This should obviously never be
    // done in a real app but it's done here since this app
    // unrealistically toggles the current platform for demonstration
    // purposes.
    WidgetsBinding.instance!.reassembleApplication();
  }

  Widget _buildIos(BuildContext context, AsyncSnapshot<void> snapshot) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverNavigationBar(
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.shuffle),
            onPressed: _togglePlatform,
          ),
        ),
        CupertinoSliverRefreshControl(
          onRefresh: () async{
            await refreshData();
          },
        ),
        SliverSafeArea(
          top: false,
          sliver: SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 12),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                _listBuilder,
                childCount: coaches.length,
              ),
            ),
          ),
        ),
      ],
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
