import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:running_society/call_view/call_view.dart';
import 'package:running_society/config/config.dart';
import 'package:running_society/config/db_utils.dart';
import 'package:running_society/theme.dart';
import 'package:running_society/variables.dart';
import 'package:running_society/widgets/app_bar.dart';
import 'package:running_society/widgets/widgets.dart';

class ReservationsTab extends StatefulWidget {
  static const title = '我的预约';
  static const androidIcon = Icon(Icons.calendar_today_outlined);
  static const iosIcon = Icon(CupertinoIcons.calendar_today);

  @override
  _ReservationsTabState createState() => _ReservationsTabState();
}

class _ReservationsTabState extends State<ReservationsTab> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildBody() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30, left: 50, right: 50),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black12
              ),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("0"),
                        Text("累计天数")
                      ],
                    ),
                    Icon(CupertinoIcons.person),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:[
                        Text("0"),
                        Text("累计次数")
                      ]
                    )
                  ],
                ),
              ),
            ), // 累计次数
          ),
          Padding(
            padding: EdgeInsets.only(top: 50, left: 40),
            child: Text(
              "你的每月计划",
              style: TextStyle(fontSize: 22),
            )
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 50, right: 50),
            child: Container(
              height: 50,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "7 次"
                    ),
                    Stack(
                      children: [
                        Container(
                          height: 3,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black45,
                          ),
                        ),
                        Container(
                          height: 3,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: CustomTheme.lemonTint,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "15 次"
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black12
              ),
            )
          ),
          Padding(
            padding: EdgeInsets.only(top: 50, left: 40),
            child: Text(
              "接下来的课程",
              style: TextStyle(fontSize: 22),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.only(top: 20, left: 50, right: 50),
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(20),
                    padding:
                    EdgeInsets.only(left: 30, top: 20, bottom: 20, right: 20),
                    onPressed: () => Navigator.of(context)
                        .push(CupertinoPageRoute(builder: (context) => CallView())),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.placemark_fill,
                              color: CustomTheme.lemonTint,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      '6pm light run with Daniel',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Arial',
                                          color: Colors.black87),
                                    ),
                                  ),
                                  Text(
                                    '北京',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Arial',
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Text(
                          'There’s so much to explore in your route while discovering new places',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Arial',
                              color: Colors.black45),
                        ),
                      ],
                    ),
                    color: Colors.black12,
                  ),
                );
              })
          ),
        ],
      ));
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: CustomAppBar("我的预约", false),
      body: _buildBody(),
    );
  }
}
