import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:running_society/widgets/widgets.dart';

import 'voice_call/pages/call.dart';
import 'voice_call/pages/index.dart';


class HomeTab extends StatelessWidget {
  static const title = 'Home';
  static const androidIcon = Icon(Icons.home);
  static const iosIcon = Icon(CupertinoIcons.home);

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Container(
            child: Image(
              image: AssetImage('assets/img/Home.png'),
            )
          ),
          Align(
            alignment: Alignment(-.5, 0.05),
            child: SizedBox(
              width: 280,
              height: 120,
              child: CupertinoButton(
                onPressed: () => Navigator.of(context).push<void>(
                  MaterialPageRoute(
                    builder: (context) => CallPage(
                      channelName: 'runningChat',
                      role: ClientRole.Audience,
                    ),
                  ),
                ),
                child: Text(''),
                color: Colors.transparent,
              ),
            )
          )
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
                  onPressed: () => Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (context) => IndexPage(),
                    ),
                  ),
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