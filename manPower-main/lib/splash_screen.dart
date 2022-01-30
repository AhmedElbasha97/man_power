import 'package:manpower/Global/utils/helpers.dart';

import 'package:manpower/Pages/searchForEmplyee.dart';
import 'package:manpower/selectLang.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_version/new_version.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
   String? token;
  checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? type = prefs.getString("type");
    String? id = prefs.getString("id");
    Future.delayed(
        Duration(seconds: 2),
        () => {
              if (id == null)
                {pushPageReplacement(context, SelectLang())}
              else
                {pushPageReplacement(context, SearchForEmployee())}
              // else
              //   {
              //     if (type == "worker")
              //       {pushPageReplacement(context, EmployeeProfile())}
              //     else if (type == "client")
              //       {pushPageReplacement(context, ClientProfileScreen())}
              //     else if (type == "company")
              //       {pushPageReplacement(context, CompanyProfileScreen())}
              //   }
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
