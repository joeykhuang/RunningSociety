
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:running_society/widgets/app_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tencent_rtc_plugin/controller/tencent_rtc_video_view_controller.dart';
import 'package:tencent_rtc_plugin/entity/user_available_entity.dart';
import 'package:tencent_rtc_plugin/enums/listener_type_enum.dart';
import 'package:tencent_rtc_plugin/enums/quality_enum.dart';
import 'package:tencent_rtc_plugin/enums/role_enum.dart';
import 'package:tencent_rtc_plugin/enums/scene_enum.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:tencent_rtc_plugin/tencent_rtc_plugin.dart';
import 'package:tencent_rtc_plugin/tencent_rtc_video_view.dart';

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

  // ignore: always_declare_return_types
  _onEnterRoom() async {
    print('entering room');
    var userSig = await TencentRtcPlugin.genUserSig(
        appid: Global.appid,
        secretKey: Global.secretKey,
        userId: _user!,
    );

    TencentRtcPlugin.enterRoom(
      appid: Global.appid,
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

  @override
  void initState() {
    super.initState();
    TencentRtcPlugin.addListener(_rtcListener);
    TencentRtcPlugin.enableAudioVolumeEvaluation(intervalMs: 100);
    _room = 123456;
    _user = 'joey';
    _enabledMicrophone = false;
    _users[_user] = null;
    _onEnterRoom();
    if (_enabledMicrophone!) {
      TencentRtcPlugin.startLocalAudio();
    }
  }

  @override
  void dispose() {
    super.dispose();
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
              padding: EdgeInsets.only(top: 20),
              child: SizedBox(
                height: 300,
                width: 350,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black38
                  ),
                ),
              )
            ),
            Padding(
              padding: EdgeInsets.only(top: 30),
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
                      onPressed: null
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
