import 'package:flutter/material.dart';
import 'package:manpower/Global/utils/helpers.dart';
import 'package:manpower/Pages/Chat/chatpage.dart';
import 'package:manpower/models/chat/chat.dart';
import 'package:manpower/services/chatService.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  bool isLoading = true;
   Chats? chat;

  @override
  void initState() {
    super.initState();
    getChats();
  }

  getChats() async {
    chat = (await ChatService().listAllChats());
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.separated(
        itemCount: chat?.date?.length?? 0,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {
              pushPage(
                  context,
                  ChatScreen(
                    chatId: chat?.date![index].chatId??" ",
                    workerId: chat?.date![index].workerId??" ",
                    clientId: chat?.date![index].clientId??" ",
                  ));
            },
            title: Text("${chat?.date![index].chatId??" "}"),
            trailing: Text("${chat?.date![index].created??" "}"),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
    );
  }
}
