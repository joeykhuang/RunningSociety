import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:running_society/config/config.dart';
import 'package:running_society/config/db_utils.dart';
import 'package:running_society/theme.dart';
import 'package:running_society/widgets/app_bar.dart';
import 'package:running_society/widgets/widgets.dart';

import 'add_class_tab.dart';

class CoachesTab extends StatefulWidget {
  static const title = '教练';
  static const androidIcon = Icon(Icons.music_note);
  static const iosIcon = Icon(CupertinoIcons.person_3_fill);

  final bool isCoach;
  late final int? coachId;
  CoachesTab(this.isCoach, [this.coachId]);

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
    if (widget.isCoach) {
      widget.coachId = prefs?.getInt('userId');
    }
  }

  Widget _buildCard(int index) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Hero(
        tag: index,
        child: CoachCard(
          coachId: coaches.elementAt(index).values![0] as int,
          coachName: coaches.elementAt(index).values![1] as String,
          coachDesc: coaches.elementAt(index).values![3] as String,
          imageLink: coaches.elementAt(index).values![2] as String,
        ),
      ),
    );
  }

  Widget _listBuilderEven(BuildContext context, int index) {
    if (numCoaches == 0) return Container();
    if (index % 2 == 0) {
      return _buildCard(index);
    } else {
      return Container();
    }
  }
  Widget _listBuilderOdd(BuildContext context, int index) {
    if (numCoaches == 0) return Container();
    if (index % 2 != 0) {
      return _buildCard(index);
    } else {
      return Container();
    }
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: _listBuilderEven,
                itemCount: coaches.length,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              width: 2,
              height: MediaQuery.of(context).size.height * 0.75,
              color: CustomTheme.lightGray,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: _listBuilderOdd,
                itemCount: coaches.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: widget.isCoach
          ? CustomAppBar(
              'Coaches',
              false,
              GestureDetector(
                onTap: () => Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) =>
                        AddClassTab(coachId: widget.coachId!))),
                child: Icon(
                  CupertinoIcons.add,
                  color: CustomTheme.lemonTint,
                ),
              ))
          : CustomAppBar('教练', false),
      body: FutureBuilder(
          future: _getCoaches(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot == AsyncSnapshot.waiting()) {
              return Container();
            } else {
              return _buildBody();
            }
          }),
    );
  }
}
