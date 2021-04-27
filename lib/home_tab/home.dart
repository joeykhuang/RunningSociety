import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:running_society/call_view/call_view.dart';
import 'package:running_society/theme.dart';

class HomeTab extends StatelessWidget {
  static const title = 'Home';
  static const androidIcon = Icon(Icons.home);
  static const iosIcon = Icon(CupertinoIcons.settings);

  Widget _buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 80, bottom: 60, left: 30, right: 30),
      child: Column(
        children: [
          Container(
            child: Text(
              'Get ready for the next great run',
              style: TextStyle(fontSize: 28, fontFamily: 'Arial'),
            ),
            padding: EdgeInsets.only(right: 60),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Container(
                  width: 300,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Colors.black12,
                    ),
                  ),
                  child: TextField(
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                        hintText: 'Find your location...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10)),
                  ),
                ),
                CupertinoButton(
                    child: Icon(
                      CupertinoIcons.search,
                      color: CustomTheme.orangeTint,
                    ),
                    onPressed: null)
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'Your next run',
              style: TextStyle(fontSize: 18, fontFamily: 'Arial'),
            ),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: EdgeInsets.only(top: 20, right: 60),
            child: CupertinoButton(
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
                        color: CustomTheme.orangeTint,
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
          ),
          Container(
            padding: EdgeInsets.only(top: 40),
            child: Text(
              'Best Place to Run According to Others',
              style: TextStyle(fontSize: 18, fontFamily: 'Arial'),
            ),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            alignment: Alignment.centerLeft,
            child: Container(
              width: 300,
              height: 190,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: AssetImage('assets/img/hangzhou.png'),
                    fit: BoxFit.cover),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 110, left: 20),
                      child: Text(
                        '杭州',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 10, left: 20),
                      child: Text(
                        'Westlake, Hangzhou',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }
}
