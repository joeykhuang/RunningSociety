import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/animation.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:running_society/theme.dart';
import 'package:running_society/widgets/app_bar.dart';
import 'package:tencent_im_plugin/entity/conversation_entity.dart';
import 'package:tencent_im_plugin/entity/message_entity.dart';
import 'package:tencent_im_plugin/entity/user_entity.dart';
import 'package:tencent_im_plugin/enums/message_elem_type_enum.dart';
import 'package:tencent_im_plugin/enums/message_status_enum.dart';
import 'package:tencent_im_plugin/message_node/custom_message_node.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:tencent_im_plugin/enums/tencent_im_listener_type_enum.dart';
import 'package:tencent_im_plugin/message_node/text_message_node.dart';
import 'package:tencent_im_plugin/message_node/message_node.dart';

class ChatView extends StatefulWidget {
  static const title = 'Chat';
  static const iosIcon = Icon(CupertinoIcons.chat_bubble_2_fill);

  final ConversationEntity conversation;

  const ChatView ({required this.conversation});

  @override
  State<StatefulWidget> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  /// 文本组件控制器
  TextEditingController _textEditingController = TextEditingController();

  /// 消息列表
  List<MessageEntity> _messages = [];

  /// 用户信息
  late UserEntity _selfUser;

  @override
  void initState() {
    super.initState();
    TencentImPlugin.addListener(_imListener);
    _loadUserInfo();
    _onLoadMessages();
    this.setState(() {});
  }

  void _loadConversation() async {

  }

  @override
  void dispose() {
    super.dispose();
    TencentImPlugin.removeListener(_imListener);
    String text = _textEditingController.text.trim();
    TencentImPlugin.setConversationDraft(
        conversationID: widget.conversation.conversationID,
        draftText: text.trim() != '' ? text : null);
  }

  /// IM监听器
  _imListener(type, params) {
    if (type == TencentImListenerTypeEnum.NewMessage) {
      this.setState(() {
        this._messages.insert(0, params);
      });
    }

    if (type == TencentImListenerTypeEnum.MessageSendProgress) {
      print("===================");
      print("消息发送进度更新:${params.msgId}");
      print("===================");
    }

    if (type == TencentImListenerTypeEnum.MessageSendSucc) {
      print("===================");
      print("消息发送成功");
      print("===================");
    }

    if (type == TencentImListenerTypeEnum.MessageSendFail) {
      print("===================");
      print("消息发送失败");
      print("===================");
    }
  }

  /// 加载当前登录用户信息
  _loadUserInfo() async {
    var _userName = await TencentImPlugin.getLoginUser();
    this._selfUser = (await TencentImPlugin.getUsersInfo(
        userIDList: [_userName!]))[0];
    this.setState(() {});
  }

  /// 加载消息
  _onLoadMessages() async {
    if (widget.conversation == null) {
      return;
    }
    List<MessageEntity> messages = await (widget.conversation.groupID != null
        ? TencentImPlugin.getGroupHistoryMessageList(
        groupID: widget.conversation.groupID!, count: 100)
        : TencentImPlugin.getC2CHistoryMessageList(
        userID: widget.conversation.userID!, count: 100));
    this.setState(() {
      this._messages = messages;
    });
  }

  /// 发送消息
  _sendMessage(MessageNode node) async {
    String? msgId = await TencentImPlugin.sendMessage(
      node: node,
      receiver: widget.conversation.userID,
      groupID: widget.conversation.groupID,
    );

    this._messages.insert(
      0,
      MessageEntity(
        msgID: msgId!,
        node: node,
        faceUrl: _selfUser.faceUrl,
        elemType: node.nodeType,
        status: MessageStatusEnum.Sending,
      ),
    );

    this.setState(() {});
  }

  /// 发送按钮点击事件
  _onSend() async {
    String text = _textEditingController.text;
    if (text.trim() == '') {
      return;
    }
    _sendMessage(TextMessageNode(content: text, atUserList: []));
    _textEditingController.text = "";
  }

  _getMessageComponent(MessageEntity message) {
    // 文本消息
    if (message.elemType == MessageElemTypeEnum.Text) {
      return Text((message.node as TextMessageNode).content);
    }

    if (message.elemType == MessageElemTypeEnum.Custom) {
      CustomMessageNode node = message.node as CustomMessageNode;
      return Text("[自定义消息]data:${node.data}，desc:${node.desc}，ext:${node.ext}");
    }

    return Text("暂不支持的数据格式");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(widget.conversation.showName ?? "加载中..."),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Flexible(
                  child: ListView(
                    reverse: true,
                    shrinkWrap: true,
                    children: _messages
                        .map(
                          (item) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: item.self!
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Offstage(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                      item.faceUrl == null ||
                                          item.faceUrl == ''
                                          ? null
                                          : NetworkImage(item.faceUrl!),
                                    ),
                                    Container(width: 10),
                                  ],
                                ),
                                offstage: item.self!,
                              ),
                              _getMessageComponent(item),
                              Offstage(
                                child: Row(
                                  children: [
                                    Container(width: 10),
                                    CircleAvatar(
                                      backgroundImage:
                                      item.faceUrl == null ||
                                          item.faceUrl == ''
                                          ? null
                                          : NetworkImage(item.faceUrl!),
                                    ),
                                  ],
                                ),
                                offstage: !item.self!,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(width: 8),
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: 40,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: Color(0xFFEEEEEE),
                      ),
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                            left: 15,
                            top: -8,
                            bottom: 0,
                            right: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(width: 8),
                  OutlinedButton(
                    onPressed: _onSend,
                    child: Text("发送"),
                    style: ButtonStyle(foregroundColor: MaterialStateProperty.all(CustomTheme.orangeTint)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}