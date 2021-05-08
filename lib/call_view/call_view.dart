
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:running_society/theme.dart';
import 'package:running_society/widgets/app_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:tencent_rtc_plugin/controller/tencent_rtc_video_view_controller.dart';
import 'package:tencent_rtc_plugin/entity/user_available_entity.dart';
import 'package:tencent_rtc_plugin/enums/listener_type_enum.dart';
import 'package:tencent_rtc_plugin/enums/scene_enum.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:tencent_rtc_plugin/tencent_rtc_plugin.dart';
import 'package:tencent_im_plugin/entity/conversation_entity.dart';
import 'GenerateUserSig.dart';
import 'package:running_society/config/config.dart';

import 'chat_view/chat_view.dart';
import 'global.dart';

class CallView extends StatefulWidget {
  @override
  _CallViewState createState() => _CallViewState();
}

class _CallViewState extends State<CallView> {
  int? _room;
  String? _user;
  bool? _enabledMicrophone;
  Map<String?, TencentRtcVideoViewController?> _users = {};
  String _userName = 'joey';

  String _heartRate = '0.0';
  String _time = '0:00';
  String _steps = '0 Steps';
  String _distance = '0 KM';
  static const channel = const MethodChannel('myWatchChannel');
  final eventChannel = const EventChannel('heartRateStreamChannel');

  late ConversationEntity _conversation;

  _rtcListener(type, params) async {
    if (type == ListenerTypeEnum.Log) {
      return;
    }

    if (type == ListenerTypeEnum.UserAudioAvailable) {
      print('audio available');
      var data = params as UserAvailableEntity;
      if (data.available! && !_users.containsKey(data.userId)) {
        _users[data.userId] = null;
      }

      if (!data.available!) {
        _users.remove(data.userId);
      }
      setState(() {});
    }
  }

  _heartRateHandler(dynamic event) {
    final String heartRate = event.toString();
    print(heartRate);
    setState(() {
      _heartRate = heartRate;
    });
  }
  // ignore: always_declare_return_types
  _onEnterRoom() async {
    print('entering room');
    var userSig = await TencentRtcPlugin.genUserSig(
        appid: appId,
        secretKey: secretKey,
        userId: _user!,
    );

    TencentRtcPlugin.enterRoom(
      appid: appId,
      userId: _user!,
      userSig: userSig,
      roomId: _room!,
      scene: SceneEnum.AudioCall,
    );

    print('entering room done');
    await Permission.microphone.request().isGranted;
  }

  _onMicrophoneClick() async {
    if (_enabledMicrophone!) {
      await TencentRtcPlugin.stopLocalAudio();
    } else {
      await TencentRtcPlugin.startLocalAudio();
    }
    setState(() => _enabledMicrophone = !_enabledMicrophone!);
  }
  _onLogin() async {
    String sign = GenerateTestUserSig(
      sdkappid: appId,
      key: secretKey
    ).genSig(identifier: _userName, expire: 1 * 60 * 1000);

    await TencentImPlugin.login(
        userID: _userName,
        userSig: sign
    );
    var _loggedinUserName = await TencentImPlugin.getLoginUser();
    print("logged in with user " + _loggedinUserName!);
  }

  void _getConversation() async {
    var tempConversation = await TencentImPlugin.getConversation(groupID: '@TGS#1CUTQPEHZ');
    setState(() {
      _conversation = tempConversation;
    });
  }

    @override
  void initState() {
    super.initState();
    TencentRtcPlugin.addListener(_rtcListener);
    TencentRtcPlugin.enableAudioVolumeEvaluation(intervalMs: 100);
    _room = 123456;
    _user = 'joey';
    _enabledMicrophone = false;
    _users[_user] = null;
    _onLogin();
    _onEnterRoom();
    _getConversation();
    if (_enabledMicrophone!) {
      TencentRtcPlugin.startLocalAudio();
    }
    eventChannel.receiveBroadcastStream().listen(_heartRateHandler);
    channel.invokeMethod('beginWorkout');
  }

  @override
  void dispose() {
    super.dispose();
    channel.invokeMethod('endWorkout');
    TencentRtcPlugin.removeListener(_rtcListener);
    TencentRtcPlugin.exitRoom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('In Class'),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/coaches_images/daniel.jpg'),
                              fit: BoxFit.cover,
                            )
                        )
                    )
                ),
            ), // Daniel Image,
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                'Right Now',
                style: TextStyle(fontSize: 18),
              ),
            ), // Right now Text
            Padding(padding: EdgeInsets.only(top: 10),
              child: Text(
                'Light Jog',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ), // Light Jog Text
            Padding(
              padding: EdgeInsets.only(left: 50, top: 40),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.heart,
                    color: CustomTheme.orangeTint,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      _heartRate,
                      style: Theme.of(context).textTheme.headline4,
                    )
                  )
                ]
              )
            ),
            Padding(
                padding: EdgeInsets.only(left: 250, top: 5),
                child: Row(
                    children: [
                      Text(
                        _time,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(
                            CupertinoIcons.time,
                            color: CustomTheme.orangeTint,
                          ),
                      )
                    ]
                )
            ),
            Padding(
                padding: EdgeInsets.only(left: 50, top: 5),
                child: Row(
                    children: [
                      Icon(
                        Icons.run_circle_outlined,
                        color: CustomTheme.orangeTint,
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            _steps,
                            style: Theme.of(context).textTheme.headline4,
                          )
                      )
                    ]
                )
            ),
            Padding(
                padding: EdgeInsets.only(left: 250, top: 5),
                child: Row(
                    children: [
                      Text(
                        _distance,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(
                            CupertinoIcons.placemark_fill,
                            color: CustomTheme.orangeTint,
                          ),
                      )
                    ]
                )
            ),
            Padding(
              padding: EdgeInsets.only(top: 180),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton(
                      child: _enabledMicrophone! ? Icon(CupertinoIcons.mic_fill): Icon(CupertinoIcons.mic_slash_fill),
                      onPressed: _onMicrophoneClick,
                  ),
                  CupertinoButton(
                    child: Icon(CupertinoIcons.phone),
                    onPressed: () => Navigator.of(context).pop(),
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  CupertinoButton(
                      child: Icon(CupertinoIcons.chat_bubble, color: Colors.blue,),
                      onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => ChatView(conversation: _conversation)))
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
