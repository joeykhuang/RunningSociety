import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:running_society/theme.dart';
import 'package:running_society/widgets/widgets.dart';


class HomeTab extends StatelessWidget {
  static const title = 'Home';
  static const androidIcon = Icon(Icons.home);
  static const iosIcon = Icon(CupertinoIcons.settings);

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 80, bottom: 100, left: 30, right: 40),
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
                            contentPadding: EdgeInsets.only(left: 10)
                          ),
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
                  padding: EdgeInsets.only(top: 20, right: 80),
                  child: CupertinoButton(
                    padding: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
                    onPressed: null,
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
                                  Text(
                                    '6pm light run with Daniel',
                                    style: TextStyle(fontSize: 14, fontFamily: 'Arial', color: Colors.black87),
                                  ),
                                  Text(
                                    '北京',
                                    style: TextStyle(fontSize: 10, fontFamily: 'Arial', color: Colors.black87),
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
                          style: TextStyle(fontSize: 10, fontFamily: 'Arial', color: Colors.black45),
                        ),
                      ],
                    ),
                    color: Colors.white24,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    'Best Place to Run According to Others',
                    style: TextStyle(fontSize: 18, fontFamily: 'Arial'),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                Container(
                  width: 300,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage('assets/img/hangzhou.jpg'),
                      fit: BoxFit.cover
                    ),
                  ),
                  child: Column(),
                )
              ],
            )
          ),
          Align(
            alignment: Alignment(-.5, 0.05),
            child: SizedBox(
              width: 280,
              height: 120,
              child: CupertinoButton(
                onPressed: () => null,
                child: Text(''),
                color: Colors.transparent,
              ),
            )
          ),
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

}

class CallButton extends StatelessWidget {
  static const _logoutMessage = Text('');

  // ===========================================================================
  // Non-shared code below because this tab shows different interfaces. On
  // Android, it's showing an alert dialog with 2 buttons and on iOS,
  // it's showing an action sheet with 3 choices.
  //
  // This is a design choice and you may want to do something different in your
  // app.
  // ===========================================================================

  Widget _buildAndroid(BuildContext context) {
    return ElevatedButton(
      child: Text('Call', style: TextStyle(color: Colors.red)),
      onPressed: () {
        // You should do something with the result of the dialog prompt in a
        // real app but this is just a demo.
        showDialog<void>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Call?'),
              content: _logoutMessage,
              actions: [
                TextButton(
                  child: const Text('Got it'),
                  onPressed: () => null,
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
      color: CupertinoColors.destructiveRed,
      child: Text('Call'),
      onPressed: () => Navigator.pop(context),
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