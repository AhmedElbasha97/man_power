import 'dart:async';
import 'package:flutter/material.dart';
import 'package:manpower/Global/theme.dart';
import 'package:manpower/Pages/ChatingScreen/widget/messages_list.dart';
import 'package:manpower/Pages/ChatingScreen/widget/text_field_chat_bar.dart';

import 'package:manpower/models/chat/chat_list.dart';
import 'package:manpower/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/chat_services.dart';

class ChattingScreen extends StatefulWidget {
 final String reciverId;

  const ChattingScreen({Key? key, required this.reciverId}) : super(key: key);

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  Timer? timer;
  late final String userId;
bool isLoading = true;

  final ChatServiceList services =ChatServiceList();
   late List<Message> listOfMessages ;
   sendMessage(String massage) async {
     MassageList? massageList = await services.sendMassage(widget.reciverId, massage);
     listOfMessages= massageList.date![0].messages!;
     setState(() {});
   }
   getId() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     userId =  prefs.getString("id") ?? "";
   }
  checkForNewMasssageLists() async {

       MassageList massageList = await services.listAllChats(
           widget.reciverId);
       listOfMessages= massageList.date![0].messages!;
       isLoading =false;
       setState(() {
       });

     }

  @override
  void initState() {
    super.initState();
    getId();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => checkForNewMasssageLists());
  }
   @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(
          "دردشة فورية",
          style: TextStyle(color: mainOrangeColor),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: mainOrangeColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
//massage list used to display massages
            isLoading?Loader(height: MediaQuery.of(context).size.height*0.79,):messagesList( listOfMessages: listOfMessages, userID: userId, ),
            //Main widget at the end of screen
           TextFieldChatBar(sendMassage: (value){
             sendMessage(value.toString());

            },)


          ],
        ),
      ),
    );
  }


   }


