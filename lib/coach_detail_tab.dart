import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:running_society/schedule_tab.dart';

import 'variables.dart';
import 'widgets.dart';

/// Coach available times
class CoachAvailableClass extends StatelessWidget {
  CoachAvailableClass({
    required this.coachName,
    required this.className,
  });

  final String coachName;
  final String className;

  @override
  Widget build(BuildContext context) {
    return PressableColorCard(
      color: Colors.transparent,
      flattenAnimation: AlwaysStoppedAnimation(1),
      child: SizedBox(
        height: 70,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // The coach title banner slides off in the hero animation.
            Positioned(
              bottom: 5,
              left: 20,
              right: 20,
              child: Container(
                height: 60,
                color: Colors.black12,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: ScheduleButton(
                  coachName: coachName,
                  buttonText: className,
                ),
              ),
            ),
            // The play button grows in the hero animation.
          ],
        ),
      ),
    );
  }
}

class ScheduleButton extends StatelessWidget {
  ScheduleButton({
    required this.coachName,
    required this.buttonText,
  });

  final String coachName;
  final String buttonText;

  Widget _buildAndroid(BuildContext context) {
    return ElevatedButton(
      child: Text(buttonText, style: TextStyle(color: Colors.black45)),
      onPressed: () {
        // You should do something with the result of the dialog prompt in a
        // real app but this is just a demo.
        showDialog<void>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(buttonText),
              actions: [
                TextButton(
                  child: const Text('Schedule'),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoButton(
      color: Colors.transparent,
      child: Text(
        buttonText,
        style: TextStyle(color: Colors.black45),
      ),
      onPressed: () {
        // You should do something with the result of the action sheet prompt
        // in a real app but this is just a demo.
        showCupertinoModalPopup<void>(
          context: context,
          builder: (context) {
            return CupertinoActionSheet(
              title: Text(buttonText),
              actions: [
                CupertinoActionSheetAction(
                  child: const Text('Schedule'),
                  onPressed: () => Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (context) => ScheduleTab(),
                    ),
                  ),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: const Text('Cancel'),
                isDefaultAction: true,
                onPressed: () => Navigator.pop(context),
              ),
            );
          },
        );
      },
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


class CoachDetailTab extends StatefulWidget {
  const CoachDetailTab({
    required this.id,
    required this.coach,
    required this.image,
  });

  final int id;
  final String coach;
  final AssetImage image;

  @override
  _CoachDetailTabState createState() => _CoachDetailTabState();
}

class _CoachDetailTabState extends State<CoachDetailTab> {
  List<String> classes = <String>[''];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _refreshData() async {
    classes = <String>[''];
    var coachClassesRaw = await getCoachClasses(widget.coach);
    for (dynamic coachClassesElem in coachClassesRaw) {
      classes.add(coachClassesElem['class_name']! as String);
    }
  }

  Widget _buildBody() {
    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Hero(
            tag: widget.id,
            child: HeroAnimatingCoachCard(
              coach: widget.coach,
              image: widget.image,
              heroAnimation: AlwaysStoppedAnimation(1),
            ),
            // This app uses a flightShuttleBuilder to specify the exact widget
            // to build while the hero transition is mid-flight.
            //
            // It could either be specified here or in CoachesTab.
            flightShuttleBuilder: (context, animation, flightDirection,
                fromHeroContext, toHeroContext) {
              return HeroAnimatingCoachCard(
                coach: widget.coach,
                image: widget.image,
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
              itemCount: classes.length,
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
                return CoachAvailableClass(
                  coachName: widget.coach,
                  className: classes[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _listBuilder(BuildContext context, int index) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Container(),
    );
  }

  // ===========================================================================
  // Non-shared code below because we're using different scaffolds.
  // ===========================================================================

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.coach)),
      body: _buildBody(),
    );
  }

  Widget _buildIos(BuildContext context, AsyncSnapshot<void> snapshot) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.coach),
        previousPageTitle: 'Coaches',
      ),
      child: _buildBody()
    );
  }

  @override
  Widget build(context) {
    return FutureBuilder<void>(
      future: _refreshData(),
      builder: _buildIos);
  }
}
