import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:manpower/Global/utils/helpers.dart';

import 'package:manpower/Pages/searchForEmplyee.dart';
import 'package:manpower/selectLang.dart';
import 'package:flutter/material.dart';
import 'package:manpower/services/notification/notification_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_version/new_version.dart';
import 'Pages/ChatingScreen/chating_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

   String? token;
  checkToken() async {


    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];
      if (routeFromMessage == "update") {
        launchURL(Platform.isAndroid
            ? "https://play.google.com/store/apps/details?id=com.syncapps.manpower"
            : "https://apps.apple.com/us/app/id1573160692",);
      } else if (routeFromMessage == "chat") {
        final companyIdFromMessage = message.data["companyID"];
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) =>
                ChattingScreen(reciverId: companyIdFromMessage,)));
      }}
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("id");
    Future.delayed(
        Duration(seconds: 2),
        () => {
          NotificationServices.checkNotificationAppInForeground(context),
              if (id == null)
                {pushPageReplacement(context, SelectLang())}
              else
                {pushPageReplacement(context, SearchForEmployee())}
            });

  }

  @override
  void initState() {
    super.initState();
    checkToken();
    NewVersion(

      androidId: "com.syncapps.manpower",
      iOSId: "com.syncapps.manpower",
    ).showAlertIfNecessary(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/icon/logo.png'),
      ),
    );
  }
}
