import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:running_society/coaches_tab/schedule_tab.dart';
import 'package:running_society/config/db_utils.dart';
import 'package:running_society/theme.dart';
import 'package:running_society/widgets/app_bar.dart';

import '../variables.dart';
import '../widgets/widgets.dart';

class ScheduleButton extends StatelessWidget {
  ScheduleButton({
    required this.className,
    required this.classId,
  });

  final String className;
  final int classId;

  @override
  Widget build(context) {
    return CupertinoButton(
      color: CustomTheme.lemonTint,
      child: Text(
        className,
        style: TextStyle(color: Colors.black87),
      ),
      onPressed: () => Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (context) => ScheduleTab(classId: classId),
        ),
      ),
    );
  }
}

class CoachDetailTab extends StatefulWidget {
  const CoachDetailTab({
    required this.id,
    required this.coach,
    //required this.image,
  });

  final int id;
  final String coach;
  //final AssetImage image;

  @override
  _CoachDetailTabState createState() => _CoachDetailTabState();
}

class _CoachDetailTabState extends State<CoachDetailTab> {

  late Results coachClasses;

  Future<void> _getCoachClasses() async {
    coachClasses = await dbGetClasses(widget.id);
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildBody() {
    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /*Hero(
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
           */
          Divider(
            height: 0,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 16, bottom: 8),
            child: Text(
              'Classes Available:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: coachClasses.length,
              itemBuilder: (context, index) {
                return ScheduleButton(
                  className: coachClasses.elementAt(index).values![1] as String,
                  classId: coachClasses.elementAt(index).values![0] as int,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(context) {
    return FutureBuilder(
      future: _getCoachClasses(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(child: Text('Waiting'));
        } else {
          return Scaffold(
            appBar: CustomAppBar(widget.coach, true),
            body: _buildBody(),
          );
        }
    });
  }
}
