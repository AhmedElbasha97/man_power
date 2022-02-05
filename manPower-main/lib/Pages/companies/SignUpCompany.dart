import 'dart:async';
import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manpower/Global/theme.dart';
import 'package:manpower/Global/widgets/MainInputFiled.dart';
import 'package:manpower/I10n/app_localizations.dart';
import 'package:manpower/Pages/companies/CompanyProfile.dart';
import 'package:manpower/models/Companies/Categories.dart';
import 'package:manpower/models/other/authresult.dart';
import 'package:manpower/services/Companies/CompaniesService.dart';
import 'package:manpower/widgets/loader.dart';

class CompanySignUp extends StatefulWidget {
  @override
  _CompanySignUpState createState() => _CompanySignUpState();
}

class _CompanySignUpState extends State<CompanySignUp> {
  bool isLoading = true;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ImageSource imgSrc = ImageSource.gallery;
  final picker = ImagePicker();

   File? img;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _nameEnController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();
  List<Categories> categories = [];

   Categories? selectedCat;

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(),
        body: isLoading
            ? Loader()
            : ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  SizedBox(height: 10),
                  Center(
                    child: InkWell(
                      onTap: () async {
                        bool? done = await selectImageSrc();
                        if (done??false) {
                          getPhoto(imgSrc);
                        }
                        setState(() {});
                      },
                      child: Container(
                        width: 95,
                        height: 95,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: Color(0xFFB9B9B9)),
                            color: Color(0xFFF3F3F3)),
                        alignment: Alignment.center,
                        child: img == null
                            ? Icon(
                                Icons.camera_alt,
                                size: 30,
                              )
                            : Image.file(img!),
                      ),
                    ),
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
                        "${AppLocalizations.of(context)?.translate('companyName')}",
                    inputType: TextInputType.name,
                    controller: _nameController,
                  ),
                  SizedBox(height: 10),
                  MainInputFiled(
                    label:
                        "${AppLocalizations.of(context)?.translate('companyNameEn')}",
                    inputType: TextInputType.name,
                    controller: _nameEnController,
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
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      showAdaptiveActionSheet(
                        context: context,
                        title: Text(
                          "${AppLocalizations.of(context)?.translate('department')}",
                          textAlign: TextAlign.start,
                        ),
                        actions: categories
                            .map<BottomSheetAction>((Categories value) {
                          return BottomSheetAction(
                              title: Text(
                                '${value.categoryName}',
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 12),
                              ),
                              onPressed: () {
                                selectedCat = value;
                                Navigator.of(context).pop();
                                setState(() {});
                              });
                        }).toList(),
                      );
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 45,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: mainOrangeColor),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            selectedCat == null
                                ? "${AppLocalizations.of(context)?.translate('department')}"
                                : "${selectedCat!.categoryName}",
                            style: TextStyle(color: Colors.grey[600]),
                            textAlign: TextAlign.start,
                          ),
                        )),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      signUp();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: mainOrangeColor),
                      child: Text(
                          "${AppLocalizations.of(context)?.translate('done')}",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ));
  }

  getCategories() async {
    categories = await CompaniesService().getCategories();
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<bool?> selectImageSrc() async {
    bool? done = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              title: Center(
                  child:
                      Text(AppLocalizations.of(context)?.translate('select')??"")),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.camera_alt),
                          Text(
                              AppLocalizations.of(context)?.translate('camera')??""),
                        ],
                      ),
                      onPressed: () {
                        imgSrc = ImageSource.camera;
                        Navigator.pop(context, true);
                      },
                    ),
                    MaterialButton(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.photo),
                          Text(
                              AppLocalizations.of(context)?.translate('galary')??""),
                        ],
                      ),
                      onPressed: () {
                        imgSrc = ImageSource.gallery;
                        Navigator.pop(context, true);
                      },
                    )
                  ],
                ),
              ],
            ));
    return done;
  }

  getPhoto(ImageSource src) async {
    final pickedFile = await (picker.pickImage(source: src) as FutureOr<PickedFile>);
    img = File(pickedFile.path);
    setState(() {});
  }

  signUp() async {
    isLoading = true;
    setState(() {});
    AuthResult result = await CompaniesService().companySignUp(
        username: _usernameController.text,
        password: _passwordController.text,
        mobile: _mobileController.text,
        name: _nameController.text,
        nameEn: _nameEnController.text,
        email: _emailController.text,
        img: img,
        categoryId: selectedCat == null ? "" : selectedCat!.categoryId??"");
    if (result.status == "success") {
      final snackBar = SnackBar(
          content: Text(
              "${AppLocalizations.of(context)?.translate('signinSuccessMsg')}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => CompanyProfileScreen(),
      ));
    } else {
      final snackBar = SnackBar(
          content: Text(Localizations.localeOf(context).languageCode == "en"
              ? result.messageEn!
              : result.messageAr!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    isLoading = false;
    setState(() {});
  }
}
