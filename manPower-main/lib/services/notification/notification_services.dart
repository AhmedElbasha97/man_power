import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:manpower/Global/Settings.dart';
import 'package:manpower/Pages/ChatingScreen/chats_list_screen.dart';
import 'package:manpower/models/other/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';



class NotificationServices{
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
 final notification = "notifications";
 static var context;
  String? getTokenOfUser(){
    FirebaseMessaging.instance.getToken().then((token){
      return token;
    });
  }
  static checkNotificationAppInBackground(context) async{
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data["route"];
        notificationSelectingAction(routeFromMessage, context);
      }
    });
  }
  static checkNotificationAppInForeground(contextOfScreen) async{
    context = contextOfScreen;
    FirebaseMessaging.onMessage.listen((message) {
      NotificationServices.display(message);
    });
  }
  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  static void initialize(){
    final InitializationSettings _initializationSettings = InitializationSettings(android: AndroidInitializationSettings(
        "@mipmap/ic_launcher"
    ),iOS: IOSInitializationSettings());
    _notificationsPlugin.initialize(_initializationSettings,onSelectNotification: (String? route) async{
      if(route != null){
        notificationSelectingAction(route, context);
      }
  });
  }
   Future<NotificationList> listAllNotification() async {
    Response response;
    NotificationList result;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("id") ?? "";
    var body =FormData.fromMap({
      "company_id": "$userId",
    });
    response = await Dio().post('$baseUrl$notification', data: body);
    var data = response.data;
    result = NotificationList.fromJson(data) ;
    return result;
  }
  static void display(RemoteMessage message)async{
    final id = DateTime.now().microsecondsSinceEpoch ~/100000000000000.toInt();
    final NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
          "high_importance_channel",
        "high_importance_channel high high",
        importance: Importance.max,
        priority: Priority.max,

      ),

    );
    await _notificationsPlugin.show(id, message.notification?.title??"", message.notification?.body??"", notificationDetails,payload:  message.data["route"],);
  }
   static void notificationSelectingAction(String route,context){
    print(route);
    switch(route){
      case "chat":
        {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>  ChatsListScreen()),
          );
        }
        break;
      case "update":{
        launchURL(Platform.isAndroid
            ? "https://play.google.com/store/apps/details?id=com.syncapps.manpower"
            : "https://apps.apple.com/us/app/id1573160692",);
      }
      break;

    }

   }
}