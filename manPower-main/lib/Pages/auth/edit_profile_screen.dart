import 'dart:io';

import 'package:flutter/material.dart';
import 'package:manpower/Global/theme.dart';
import 'package:manpower/Global/widgets/MainInputFiled.dart';
import 'package:manpower/I10n/app_localizations.dart';
import 'package:manpower/Pages/client/ClientProfile.dart';
import 'package:manpower/models/client/userClient.dart';
import 'package:manpower/models/other/authresult.dart';
import 'package:manpower/services/AuthService.dart';

class ClientEditProfile extends StatefulWidget {
  UserClientMOdel? data;
  ClientEditProfile({ this.data});
  @override
  _ClientEditProfileState createState() => _ClientEditProfileState();
}

class _ClientEditProfileState extends State<ClientEditProfile> {
  bool isLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

   File? img;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();

  fillData() {
    _nameController = new TextEditingController(text: widget.data!.nameAr);
    _emailController = new TextEditingController(text: widget.data!.email);
    _passwordController = new TextEditingController();
    _usernameController = new TextEditingController(text: widget.data!.username);
    _mobileController = new TextEditingController(text: widget.data!.mobile);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fillData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: mainOrangeColor,
                ),
              )
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
                  SizedBox(height: 50),
                  InkWell(
                    onTap: () {
                      editProfile();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: mainOrangeColor),
                      child: Text(
                          "${AppLocalizations.of(context)?.translate('save')}",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ));
  }

  editProfile() async {
    isLoading = true;
    setState(() {});
    AuthResult? result = await AuthService().editAccount(
      name: _nameController.text == "" ? " " : _nameController.text,
      username:
          _usernameController.text == "" ? " " : _usernameController.text,
      password:
          _passwordController.text == "" ? " " : _passwordController.text,
      mobile: _mobileController.text == "" ? " " : _mobileController.text,
      email: _emailController.text == "" ? " " : _emailController.text,
    );
    if (result?.status == "success") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ClientProfileScreen(),
      ));
    } else {
      final snackBar = SnackBar(
          content: Text(Localizations.localeOf(context).languageCode == "en"
              ? result?.messageEn??""
              : result?.messageAr??""));
      scaffoldKey.currentState?.showSnackBar(snackBar);
    }
    isLoading = false;
    setState(() {});
  }
}
