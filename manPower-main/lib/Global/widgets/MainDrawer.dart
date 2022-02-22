import 'dart:io';

import 'package:manpower/Pages/Notification/notification_list.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manpower/I10n/app_localizations.dart';
import 'package:manpower/Pages/CVs/AddCVScreen.dart';
import 'package:manpower/Pages/Empolyees/empolyeeProfile.dart';
import 'package:manpower/Pages/Jobs/JobsScreen.dart';
import 'package:manpower/Pages/Jobs/addNewJob.dart';
import 'package:manpower/Pages/appData/about_app_screen.dart';
import 'package:manpower/Pages/appData/supportChat.dart';
import 'package:manpower/Pages/auth/logIn_screen.dart';
import 'package:manpower/Pages/client/ClientProfile.dart';
import 'package:manpower/Pages/companies/CompanyProfile.dart';
import 'package:manpower/Pages/searchForCompany.dart';
import 'package:manpower/Pages/searchForEmplyee.dart';
import 'package:manpower/Pages/welcome_screen.dart';
import 'package:manpower/selectSection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Pages/ChatingScreen/chats_list_screen.dart';
import '../utils/helpers.dart';

// ignore: must_be_immutable
class MainDrawer extends StatefulWidget {
  String? id;
  String? type;
  MainDrawer(this.id, this.type);
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
   String? name;
   String? token;
   String? facebookUrl;
   String? whatsappUrl;
   String? instagramUrl;
   String? youtubeUrl;
   String? twitterUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      color: Colors.grey[300],
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
          SizedBox(
            height: 100,
            child: Container(
              color: Colors.white,
              child: Image.asset(
                "assets/icon/logo.png",
                scale: 3,
              ),
            ),
          ),
          Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
          Container(
            color: Colors.white,
            child: ListTile(
                tileColor: Colors.white,
                title: Text(
                  "${AppLocalizations.of(context)?.translate('searchEmployee')}",
                  style: TextStyle(
                      color: Color(0xFF0671bf),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textScaleFactor: 1.0,
                ),
                leading: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.purple,
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  pushPage(context, SearchForEmployee());
                }),
          ),
          Container(
            color: Colors.white,
            child: ListTile(
                tileColor: Colors.white,
                title: Text(
                  "${AppLocalizations.of(context)?.translate('companies')}",
                  style: TextStyle(
                      color: Color(0xFF0671bf),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textScaleFactor: 1.0,
                ),
                leading: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.orange,
                  ),
                  child: Icon(
                    Icons.business,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  pushPage(context, CompanySearchScreen());
                }),
          ),
          widget.id != null
              ? Container()
              : Container(
                  color: Colors.white,
                  child: ListTile(
                      tileColor: Colors.white,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('uploadCv')}",
                        style: TextStyle(
                            color: Color(0xFF0671bf),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.redAccent,
                        ),
                        child: Icon(
                          Icons.file_upload,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddCvScreen(),
                        ));
                      }),
                ),
          Container(
            color: Colors.white,
            child: ListTile(
                tileColor: Colors.white,
                title: Text(
                  "${AppLocalizations.of(context)?.translate('addJob')}",
                  style: TextStyle(
                      color: Color(0xFF0671bf),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textScaleFactor: 1.0,
                ),
                leading: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.greenAccent,
                  ),
                  child: Icon(
                    Icons.add_business,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddNewJobScreen(),
                  ));
                }),
          ),
          Container(
            color: Colors.white,
            child: ListTile(
                tileColor: Colors.white,
                title: Text(
                  "${AppLocalizations.of(context)?.translate('newJobs')}",
                  style: TextStyle(
                      color: Color(0xFF0671bf),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textScaleFactor: 1.0,
                ),
                leading: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.brown,
                  ),
                  child: Icon(
                    Icons.business_center_outlined,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => JobsScreen(),
                  ));
                }),
          ),
          SizedBox(
            height: 10,
          ),
          widget.id != null
              ? Container(
                  color: Colors.white,
                  child: ListTile(
                      tileColor: Colors.white,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('myAccount')}",
                        style: TextStyle(
                            color: Color(0xFF0671bf),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.blueGrey,
                        ),
                        child: Icon(
                          Icons.account_box,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => widget.type == "company"
                              ? CompanyProfileScreen()
                              : widget.type == "worker"
                                  ? EmployeeProfile()
                                  : ClientProfileScreen(),
                        ));
                      }),
                )
              : Container(),
          widget.id != null
              ? Container(
                  color: Colors.white,
                  child: ListTile(
                      tileColor: Colors.white,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('signOut')}",
                        style: TextStyle(
                            color: Color(0xFF0671bf),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.blueGrey,
                        ),
                        child: Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.clear();
                        pushPageReplacement(context, SelectSections());
                      }),
                )
              : Container(),
          widget.id == null
              ? Container(
                  color: Colors.white,
                  child: ListTile(
                      tileColor: Colors.white,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('login')}",
                        style: TextStyle(
                            color: Color(0xFF0671bf),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.greenAccent,
                        ),
                        child: Icon(
                          Icons.login,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        pushPage(context, LogInScreen());
                      }),
                )
              : Container(),
          widget.id == null
              ? Container(
                  color: Colors.white,
                  child: ListTile(
                      tileColor: Colors.white,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('signUp')}",
                        style: TextStyle(
                            color: Color(0xFF0671bf),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.purpleAccent,
                        ),
                        child: Icon(
                          Icons.people_sharp,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        pushPage(context, WelcomeScreen());
                      }),
                )
              : Container(),
          widget.id != null?Container(
            color: Colors.white,
            child: ListTile(
                tileColor: Colors.white,
                title: Text(
                  "${  Localizations.localeOf(context).languageCode == "en"
                      ?"chat list":"قيمة الدردشات"}",
                  style: TextStyle(
                      color: Color(0xFF0671bf),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textScaleFactor: 1.0,
                ),
                leading: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.orange,
                  ),
                  child: Icon(
                    Icons.chat,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChatsListScreen(),
                  ));
                }),
          ):SizedBox(),
          widget.id != null?Container(
            color: Colors.white,
            child: ListTile(
                tileColor: Colors.white,
                title: Text(
                  "${  Localizations.localeOf(context).languageCode == "en"
                      ?"Notification list":"قيمة الاشعرات"}",
                  style: TextStyle(
                      color: Color(0xFF0671bf),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textScaleFactor: 1.0,
                ),
                leading: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.orange,
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NotificationsListScreen(),
                  ));
                }),
          ):SizedBox(),
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            child: ListTile(
                tileColor: Colors.white,
                title: Text(
                  "${AppLocalizations.of(context)?.translate('support')}",
                  style: TextStyle(
                      color: Color(0xFF0671bf),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textScaleFactor: 1.0,
                ),
                leading: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.orange,
                  ),
                  child: Icon(
                    Icons.chat,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SupportChatPage(),
                  ));
                }),
          ),
          Container(
            color: Colors.white,
            child: ListTile(
                tileColor: Colors.white,
                title: Text(
                  "${AppLocalizations.of(context)?.translate('whoAreWe')}",
                  style: TextStyle(
                      color: Color(0xFF0671bf),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textScaleFactor: 1.0,
                ),
                leading: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.indigo,
                  ),
                  child: Icon(
                    Icons.info,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AboutAppScreen(),
                  ));
                }),
          ),
          Container(
            color: Colors.white,
            child: ListTile(
                tileColor: Colors.white,
                title: Text(
                  "${AppLocalizations.of(context)?.translate('share')}",
                  style: TextStyle(
                      color: Color(0xFF0671bf),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textScaleFactor: 1.0,
                ),
                leading: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.greenAccent,
                  ),
                  child: Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Share.share(Platform.isAndroid
                               ? "https://play.google.com/store/apps/details?id=com.syncapps.manpower"
                               : "https://apps.apple.com/us/app/id1573160692",);

                }),
          ),
          Container(
            color: Colors.white,
            child: ListTile(
                tileColor: Colors.white,
                title: Text(
                  "${AppLocalizations.of(context)?.translate('changeLang')}",
                  style: TextStyle(
                      color: Color(0xFF0671bf),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textScaleFactor: 1.0,
                ),
                leading: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.red,
                  ),
                  child: Icon(
                    Icons.language_sharp,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) =>
                          changeLangPopUp(context));
                }),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(padding: EdgeInsets.symmetric(horizontal: 1)),
              InkWell(
                onTap: () => launchURL("$facebookUrl"),
                child: Image.asset(
                  "assets/icon/facebook.png",
                  scale: 1.5,
                ),
              ),
              InkWell(
                onTap: () => launchURL("$instagramUrl"),
                child: Image.asset(
                  "assets/icon/instagram.png",
                  scale: 1.5,
                ),
              ),
              InkWell(
                onTap: () => launchURL("$twitterUrl"),
                child: Image.asset(
                  "assets/icon/twitter.png",
                  scale: 1.5,
                ),
              ),
              InkWell(
                onTap: () => launchURL("https://wa.me/$whatsappUrl"),
                child: Image.asset(
                  "assets/icon/whatsapp.png",
                  scale: 1.5,
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 1)),
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 15)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "${AppLocalizations.of(context)?.translate('policy1')}",
              style: TextStyle(fontSize: 15),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text("${AppLocalizations.of(context)?.translate('policy2')}",
                    style: TextStyle(fontSize: 16)),
                InkWell(
                  onTap: () => launchURL("https://syncqatar.com"),
                  child: Text(
                    "سينك",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        ],
      ),
    );
  }
}
