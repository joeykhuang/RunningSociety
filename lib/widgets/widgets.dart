import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:running_society/coaches_tab/coach_detail_tab.dart';
import 'package:running_society/theme.dart';

class CoachCard extends StatelessWidget {
  final int coachId;
  final String? imageLink;
  final String coachName;
  final String coachDesc;

  CoachCard({
    required this.coachId,
    required this.coachName,
    required this.coachDesc,
    this.imageLink,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (context) => CoachDetailTab(
              id: this.coachId,
              coach: this.coachName
            ),
          ),
        ),
        child: SizedBox(
          width: 175,
          child: Column(
            children: [
              Container(
                width: 175,
                height: 90,
                decoration: BoxDecoration(
                  color: CustomTheme.lemonTint,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(this.coachName, style: TextStyle(fontSize: 18),),
                      Text(this.coachDesc, style: TextStyle(fontSize: 12),),
                    ]
                  ),
                ),
              ),
              Stack(
                children: [
                  imageLink != null?Image.network(this.imageLink!, width: 175,):Container(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
