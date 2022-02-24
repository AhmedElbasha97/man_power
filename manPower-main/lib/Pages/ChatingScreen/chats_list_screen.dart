import 'package:flutter/material.dart';
import 'package:manpower/Pages/ChatingScreen/chating_screen.dart';
import 'package:manpower/Pages/ChatingScreen/widget/user_chat_cell.dart';
import 'package:manpower/models/chat/chat-user_list.dart';
import 'package:manpower/services/chat_services.dart';
import 'package:manpower/widgets/loader.dart';
import '../../Global/theme.dart';
class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({Key? key}) : super(key: key);

  @override
  _ChatsListScreenState createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  bool isLoading = true;
  late List<Datum>? userChatList;
  getAllListOfChat()async{
    final userList= await ChatServiceList().listAllUserChat();
    userChatList = userList.data;
    isLoading=false;
    setState(() {

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllListOfChat();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(
          Localizations.localeOf(context).languageCode == "en"
              ?"chat list":"قيمة الدردشات",
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
      body:isLoading?Loader(): userChatList?.length==0?
      Container(
          height: MediaQuery.of(context).size.height ,
          width: MediaQuery.of(context).size.width,
          child: Column(
        children: [
          Image.asset("assets/icon/chat_holde.png"),
          SizedBox(height: 20,),
          Text(Localizations.localeOf(context).languageCode == "en"
              ?"no chat available":"لا يوجد دردشة متوفره لان",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20

          ),),
        ],
    ),
      ) :ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: userChatList?.length,
          itemBuilder: (context, int index) {
           return ChatUserCard(press: () async {
             print(userChatList?[index].picpath);
             if(userChatList?[index].isRead=="1"){
               print("hi from checker");
              var response = await ChatServiceList().markAsRead(userChatList?[index].companyId??"", userChatList?[index].chatId??"");
              print(response);
              if(response.data['status'] == "success"){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>  ChattingScreen(reciverId: userChatList?[index].companyId??"",)),
                ).then((value){
                  print("data has been called again");
                getAllListOfChat();
                  setState(() {

                  });
                });
              }
             }else{
             Navigator.push(
             context,
             MaterialPageRoute(builder: (context) =>  ChattingScreen(reciverId: userChatList?[index].companyId??"",)),
           );} },chat: userChatList![index],);
    }),
    );
  }
}
