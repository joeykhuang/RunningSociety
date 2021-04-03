import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widgets.dart';

final List<List<String>> coachClasses = [['Classes', 'Beginner Running', 'Intermediate Running', 'Advanced Running'], ['Classes', 'Road to 5k', 'Your First Half-Marathon', 'Beginning Marathon', 'Ticket to the Boston Marathon']];
/// Page shown when a card in the coachs tab is tapped.
///
/// On Android, this page sits at the top of your app. On iOS, this page is on
/// top of the coachs tab's content but is below the tab bar itself.
class CoachDetailTab extends StatelessWidget {
  const CoachDetailTab({
    required this.id,
    required this.coach,
    required this.image,
  });

  final int id;
  final String coach;
  final AssetImage image;

  Widget _buildBody() {
    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Hero(
            tag: id,
            child: HeroAnimatingCoachCard(
              coach: coach,
              image: image,
              heroAnimation: AlwaysStoppedAnimation(1),
            ),
            // This app uses a flightShuttleBuilder to specify the exact widget
            // to build while the hero transition is mid-flight.
            //
            // It could either be specified here or in CoachesTab.
            flightShuttleBuilder: (context, animation, flightDirection,
                fromHeroContext, toHeroContext) {
              return HeroAnimatingCoachCard(
                coach: coach,
                image: image,
                heroAnimation: animation,
              );
            },
          ),
          Divider(
            height: 0,
            color: Colors.grey,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: coachClasses[id].length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding:
                    const EdgeInsets.only(left: 15, top: 16, bottom: 8),
                    child: Text(
                      'Classes Available:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                // Just a bunch of boxes that simulates loading coach choices.
                return CoachAvailableClass(className: coachClasses[id][index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Non-shared code below because we're using different scaffolds.
  // ===========================================================================

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(coach)),
      body: _buildBody(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(coach),
        previousPageTitle: 'Coaches',
      ),
      child: _buildBody(),
    );
  }

  @override
  Widget build(context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}