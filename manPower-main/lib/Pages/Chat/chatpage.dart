import 'package:flutter/material.dart';
import 'package:manpower/I10n/app_localizations.dart';
import 'package:manpower/models/chat/chat.dart';
import 'package:manpower/services/chatService.dart';
import 'package:manpower/widgets/Chat/widgets/chatbubble.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  String? chatId;
  String? workerId;
  String? clientId;

  @override
  _ChatScreenState createState() => _ChatScreenState();
  ChatScreen({ this.chatId,  this.workerId,  this.clientId});
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController textEditingController =
      new TextEditingController();
  FocusNode _msgNode = new FocusNode();

   late Chats messages;
   String? type;
  bool isLoading = false;
  bool chatloading = false;

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  getMessages() async {
    messages = (await ChatService().getChatbyId(widget.chatId))!;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    type = prefs.getString("type") ?? "";
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  sendMessage() async {
    if (textEditingController.text.isNotEmpty) {
      chatloading = true;
      if (mounted) {
        setState(() {});
      }
      await ChatService().sendMessage(
          widget.workerId, widget.clientId, textEditingController.text);
      textEditingController.clear();
      chatloading = false;
      if (mounted) {
        setState(() {});
      }
    }
    getMessages();
  }

  Widget inputFiled() {
    return Container(
      child: Row(
        children: <Widget>[
          // Text input
          Flexible(
            child: Container(
              child: TextField(
                focusNode: _msgNode,
                textInputAction: TextInputAction.send,
                onEditingComplete: () {
                  sendMessage();
                },
                style: TextStyle(fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)?.translate('typeMsg'),
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          // Send Message Button
          Material(
            child: new Container(
              child: chatloading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : new IconButton(
                      icon: new Icon(Icons.send),
                      onPressed: () {
                        sendMessage();
                      },
                      color: Color(0xFF184e7a),
                    ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border:
              new Border(top: new BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }

  void unFocus() {
    _msgNode.unfocus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${AppLocalizations.of(context)?.translate('chat')}",
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.builder(
                        reverse: true,
                        itemCount: messages.date?.first.messages?.length??0,
                        itemBuilder: (context, int index) {
                          return ChatBubble(
                              isMyMsg: (type == "client" &&
                                      messages.date?.first.messages![index]
                                              .clientId !=
                                          "0") ||
                                  (type == "worker" &&
                                      messages.date?.first.messages![index]
                                              .workerId !=
                                          "0"),
                              msg: messages.date?.first.messages![index].message??"",
                              date: messages
                                  .date?.first.messages![index].created??" ");
                        }),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: inputFiled(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
