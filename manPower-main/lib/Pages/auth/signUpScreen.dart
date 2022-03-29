import 'dart:io';

import 'package:flutter/material.dart';
import 'package:manpower/Global/theme.dart';
import 'package:manpower/Global/utils/helpers.dart';
import 'package:manpower/Global/widgets/MainInputFiled.dart';
import 'package:manpower/I10n/app_localizations.dart';
import 'package:manpower/Pages/appData/Privacy_police_screen.dart';
import 'package:manpower/Pages/appData/terms_condition_screren.dart';
import 'package:manpower/models/other/authresult.dart';
import 'package:manpower/pages/searchForEmplyee.dart';
import 'package:manpower/services/AuthService.dart';
import 'package:manpower/widgets/loader.dart';

class ClientSignUp extends StatefulWidget {
  @override
  _ClientSignUpState createState() => _ClientSignUpState();
}

class _ClientSignUpState extends State<ClientSignUp> {
  bool isLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

   File? img;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();
  var val ;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(),
        body: isLoading
            ?Loader()
            : ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  SizedBox(height: 50),
                  MainInputFiled(
                    label: "${AppLocalizations.of(context)?.translate('name')}",
                    inputType: TextInputType.text,
                    controller: _nameController,
                  ),
                  SizedBox(height: 10),
                  MainInputFiled(
                    label:
                        "${AppLocalizations.of(context)?.translate('username')}",
                    inputType: TextInputType.text,
                    controller: _usernameController,
                  ),
                  SizedBox(height: 10),
                  MainInputFiled(
                    label:
                        "${AppLocalizations.of(context)?.translate('password')}",
                    inputType: TextInputType.visiblePassword,
                    controller: _passwordController,
                  ),
                  SizedBox(height: 10),
                  MainInputFiled(
                    label:
                        "${AppLocalizations.of(context)?.translate('mobile')}",
                    inputType: TextInputType.phone,
                    controller: _mobileController,
                  ),
                  SizedBox(height: 10),
                  MainInputFiled(
                    label: "${AppLocalizations.of(context)?.translate('email')}",
                    inputType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: val,
                        onChanged: (value) {
                          setState(() {
                            val = value;

                          });
                        },
                        toggleable: true,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              Localizations.localeOf(context).languageCode == "en"
                                  ? "i have read and accept "
                                  : "انا قرأت و اوافق علي "),
                          Row(
                            children: [
                              InkWell(
                                onTap: (){
                                  pushPage(context,
                                      PrivacyPolicyScreen());
                                },
                                child: Text(
                                  Localizations.localeOf(context).languageCode == "en"
                                      ? "privacy policy"
                                      : "سياسة خاصة",
                                  style: TextStyle(
                                      color: Colors.blue
                                  ),
                                ),
                              ),
                              Text(
                                  Localizations.localeOf(context).languageCode == "en"
                                      ? " and "
                                      : " و "),
                              InkWell(
                                onTap: (){
                                  pushPage(context,
                                      TermsAndConditionScreen());
                                },
                                child: Text(
                                  Localizations.localeOf(context).languageCode == "en"
                                      ? "terms and condition"
                                      : "أحكام وشروط",
                                  style: TextStyle(
                                      color: Colors.blue
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 25),
                  InkWell(
                    onTap: () {
                      if(val==1) {
                        signUp();
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color:val==1? mainOrangeColor:Colors.grey),
                      child: Text(
                          "${AppLocalizations.of(context)?.translate('signUp')}",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ));
  }

  signUp() async {
    isLoading = true;
    setState(() {});
    AuthResult? result = await AuthService().createAccount(
      name: _nameController.text,
      username: _usernameController.text,
      password: _passwordController.text,
      mobile: _mobileController.text,
      email: _emailController.text,
    );
    if (result?.status == "success") {
      final snackBar = SnackBar(
          content: Text(
              "${AppLocalizations.of(context)?.translate('signinSuccessMsg')}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      pushPageReplacement(context, SearchForEmployee());
    } else {
      final snackBar = SnackBar(
          content: Text(Localizations.localeOf(context).languageCode == "en"
              ? result?.messageEn??""
              : result?.messageAr??""));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    isLoading = false;
    setState(() {});
  }
}
