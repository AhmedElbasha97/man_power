import 'package:manpower/Global/theme.dart';
import 'package:manpower/I10n/app_localizations.dart';
import 'package:manpower/Pages/client/ClientProfile.dart';
import 'package:manpower/Pages/companies/CompanyProfile.dart';
import 'package:manpower/models/other/authresult.dart';
import 'package:manpower/services/AuthService.dart';
import 'package:flutter/material.dart';

import '../home_screen.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool phoneError = false;
  bool passwordError = false;
  bool isServerLoading = false;
  String selectedType = "company";

  validation(BuildContext context) async {
    if (usernameController.text.isEmpty)
      phoneError = true;
    else
      phoneError = false;
    if (passwordController.text.isEmpty)
      passwordError = true;
    else
      passwordError = false;

    setState(() {});

    if (!phoneError && !passwordError) {
      isServerLoading = true;
      setState(() {});
      AuthResult? result = await AuthService().login(
          username: usernameController.text,
          password: passwordController.text,
          type: selectedType);
      if (result?.status == "success") {
        if (selectedType == "company") {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => CompanyProfileScreen(),
          ));
        }
        if (selectedType == "client") {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ClientProfileScreen(),
          ));
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
        }
      } else {
        final snackBar = SnackBar(
            content: Text(Localizations.localeOf(context).languageCode == "en"
                ? result?.messageEn??""
                : result?.messageAr??""));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      isServerLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.grey[50],
          title: Text(
            "${AppLocalizations.of(context)?.translate('login')}",
            style: TextStyle(color: Color(0xFF0671bf)),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF0671bf),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Builder(
          builder: (context) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 30)),
                  Image.asset(
                    "assets/icon/logo.png",
                    scale: 3.5,
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top + 30)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          controller: usernameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 15,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: Color(0xFF0671bf))),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: Color(0xFF0671bf))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: mainOrangeColor)),
                              hintText:
                                  "${AppLocalizations.of(context)?.translate('username')}"),
                        ),
                      ),
                      phoneError
                          ? Text(
                              "please enter your phone",
                              style: TextStyle(color: Colors.red),
                            )
                          : Container(),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 15,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: Color(0xFF0671bf))),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: Color(0xFF0671bf))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: mainOrangeColor)),
                              hintText:
                                  "${AppLocalizations.of(context)?.translate('password')}"),
                        ),
                      ),
                      passwordError
                          ? Text(
                              "please enter your password",
                              style: TextStyle(color: Colors.red),
                            )
                          : Container(),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        width: MediaQuery.of(context).size.width * 0.8,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(
                            color: mainBlueColor,
                          ),
                        ),
                        child: Container(
                          child: DropdownButton(
                              isDense: true,
                              isExpanded: true,
                              value: selectedType,
                              hint: Text(
                                  AppLocalizations.of(context)
                                      ?.translate('signinAs')??"",
                                  style: TextStyle(
                                    fontSize: 14,
                                  )),
                              underline: SizedBox(),
                              items: [
                                DropdownMenuItem(
                                  child: Text(
                                      AppLocalizations.of(context)
                                          ?.translate('company')??"",
                                      style: TextStyle(
                                        fontSize: 14,
                                      )),
                                  value: "company",
                                ),
                                DropdownMenuItem(
                                  child: Text(
                                      AppLocalizations.of(context)
                                          ?.translate('client')??"",
                                      style: TextStyle(
                                        fontSize: 14,
                                      )),
                                  value: "client",
                                ),
                                DropdownMenuItem(
                                  child: Text(
                                      AppLocalizations.of(context)
                                          ?.translate('worker')??"",
                                      style: TextStyle(
                                        fontSize: 14,
                                      )),
                                  value: "worker",
                                )
                              ],
                              onChanged: (dynamic value) {
                                selectedType = value.toString();
                                setState(() {});
                              }),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 25)),
                      isServerLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : InkWell(
                              onTap: () => validation(context),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: mainOrangeColor),
                                child: Text(
                                    "${AppLocalizations.of(context)?.translate('login')}",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            )
                    ],
                  )
                ],
              ),
            );
          },
        ));
  }
}
