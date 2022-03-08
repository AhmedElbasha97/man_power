import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manpower/Global/theme.dart';
import 'package:manpower/Global/utils/helpers.dart';
import 'package:manpower/Global/widgets/MainDrawer.dart';
import 'package:manpower/I10n/app_localizations.dart';
import 'package:manpower/Pages/ChatingScreen/chating_screen.dart';
import 'package:manpower/Pages/ChatingScreen/chats_list_screen.dart';
import 'package:manpower/Pages/appData/packagesScreen.dart';
import 'package:manpower/Pages/auth/edit_profile_screen.dart';
import 'package:manpower/Pages/client/ClientWallet.dart';
import 'package:manpower/Pages/client/myFavCvs.dart';
import 'package:manpower/models/client/userClient.dart';
import 'package:manpower/services/AuthService.dart';
import 'package:manpower/services/notification/notification_services.dart';
import 'package:manpower/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientProfileScreen extends StatefulWidget {
  @override
  _ClientProfileScreenState createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
   UserClientMOdel? data;
  bool isLoading = true;
   String? id;
   String? type;
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString("id");
    type = prefs.getString("type");
    data = (await AuthService().getClientAccount(id: id));
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    NotificationServices.checkNotificationAppInForeground(context);

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainOrangeColor,
        centerTitle: true,
        title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/icon/logoAppBar.png",
                scale: 4.5, fit: BoxFit.scaleDown)),
      ),
      drawer: isLoading ? Container() : MainDrawer(id, type),
      body: isLoading
          ? Loader()
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: ListView(
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: mainOrangeColor,
                          backgroundImage: AssetImage("assets/icon/employerPlaceHolder.png",),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.grey[300],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${AppLocalizations.of(context)?.translate('username')}:",
                              style:
                                  TextStyle(fontSize: 14, color: mainBlueColor),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${data!.username}",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: mainOrangeColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${AppLocalizations.of(context)?.translate('name')}:",
                              style:
                                  TextStyle(fontSize: 14, color: mainBlueColor),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Localizations.localeOf(context).languageCode ==
                                      "en"
                                  ? "${data!.nameEn}"
                                  : "${data!.nameEn}",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: mainOrangeColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey[300],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${AppLocalizations.of(context)?.translate('balance')}:",
                              style:
                                  TextStyle(fontSize: 14, color: mainBlueColor),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${data!.balance ?? ""}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: mainOrangeColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${AppLocalizations.of(context)?.translate('mobile')}:",
                              style:
                                  TextStyle(fontSize: 14, color: mainBlueColor),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${data!.mobile ?? ""}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: mainOrangeColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey[300],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${AppLocalizations.of(context)?.translate('email')}:",
                              style:
                                  TextStyle(fontSize: 14, color: mainBlueColor),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${data!.email ?? ""}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: mainOrangeColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                      tileColor: mainBlueColor,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('packages')}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.green,
                        ),
                        child: Icon(
                          Icons.payment,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        pushPage(context, PackagesScreen());
                      }),
                  ListTile(
                      tileColor: mainBlueColor,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('cvs')}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: mainOrangeColor,
                        ),
                        child: Icon(
                          Icons.people,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        // pushPage(context, PackagesScreen());
                      }),
                  ListTile(
                      tileColor: mainBlueColor,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('editProfile')}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: mainOrangeColor,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        pushPage(context, ClientEditProfile(data: data));
                      }),
                  ListTile(
                      tileColor: mainBlueColor,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('messages')}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: mainOrangeColor,
                        ),
                        child: Icon(
                          Icons.message,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        pushPage(context, ChatsListScreen());
                      }),
                  ListTile(
                      tileColor: mainBlueColor,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('paymentHistory')}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: mainOrangeColor,
                        ),
                        child: Icon(
                          Icons.money_outlined,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        pushPage(context, TransactionScreen());
                      }),
                  ListTile(
                      tileColor: mainBlueColor,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('favCv')}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: mainOrangeColor,
                        ),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.heart,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onTap: () {
                        pushPage(context, MyFavCvsScreen());
                      })
                ],
              ),
            ),
    );
  }
}
