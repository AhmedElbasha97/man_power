import 'package:dio/dio.dart';
import 'package:manpower/Global/Settings.dart';
import 'package:manpower/models/chat/chat_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ChatServiceList{
  String chat = "chat";
  String send = "chat/send";
  Future<MassageList> listAllChats(String reciverId) async {

      Response response;
      MassageList result;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString("id") ?? "";
      var body =FormData.fromMap({
        "sender_id": "$userId",
        "reciver_id": reciverId,
      });
      response = await Dio().post('$baseUrl$chat', data: body);
      var data = response.data;
      result = MassageList.fromJson(data) ;
      if (response.data['status'] == "success" && response.data != null) {
        prefs.setString("chat_id", "${MassageList.fromJson(data).date![0].chatId!}");
      }
      return result;


  }
  Future<MassageList> sendMassage(String reciverId,String massage) async {
      Response response;
      MassageList result;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString("id") ?? "";
      String chatId = prefs.getString("chat_id") ?? "";
      var body =FormData.fromMap({
        "company_id": "$userId",
        "message": massage,
        "chat_id":"$chatId",
      });
      response = await Dio().post('$baseUrl$send', data: body);
      var data = response.data;
      result = MassageList.fromJson(data);
      return result;



  }


}