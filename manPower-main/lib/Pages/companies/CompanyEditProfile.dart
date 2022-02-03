import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manpower/Global/theme.dart';
import 'package:manpower/Global/widgets/MainInputFiled.dart';
import 'package:manpower/I10n/app_localizations.dart';
import 'package:manpower/Pages/companies/CompanyProfile.dart';
import 'package:manpower/models/Companies/Categories.dart';
import 'package:manpower/models/Companies/companyInfo.dart';
import 'package:manpower/models/other/authresult.dart';
import 'package:manpower/services/Companies/CompaniesService.dart';
import 'package:manpower/widgets/loader.dart';

import 'map_screen.dart';

class CompanyEditProfile extends StatefulWidget {
  CompanyInfo? data;
  CompanyEditProfile(this.data);
  @override
  _CompanyEditProfileState createState() => _CompanyEditProfileState();
}

class _CompanyEditProfileState extends State<CompanyEditProfile> {
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
  TextEditingController addressController = TextEditingController();
  TextEditingController detailsArController = TextEditingController();
  TextEditingController detailsEnController = TextEditingController();

  List<Categories> categories = [];
  List<File> _images = [];
   Categories? selectedCat;
   // PickResult? selectedPlace;

  @override
  void initState() {
    super.initState();
    getCategories();
    fillData();
  }

  fillData() {
    _nameController =
        new TextEditingController(text: widget.data?.data?.nameAr);
    _nameEnController =
        new TextEditingController(text: widget.data?.data?.nameEn);
    _emailController =
        new TextEditingController(text: widget.data?.data?.email);
    _usernameController =
        new TextEditingController(text: widget.data?.data?.username);
    _mobileController =
        new TextEditingController(text: widget.data?.data?.mobile);
    addressController =
        new TextEditingController(text: widget.data?.data?.address);
    detailsArController =
        new TextEditingController(text: widget.data?.data?.detailsAr);
    detailsEnController =
        new TextEditingController(text: widget.data?.data?.detailsEn);
    selectedCat = Categories(
        categoryId: widget.data?.data?.categoryId,
        categoryName: widget.data?.data?.categoryNameAr,
        categoryNameEn: widget.data?.data?.nameEn);
  }

  getPhotos(int index, ImageSource src) async {
    final pickedFile = await picker.getImage(source: src);
    if (pickedFile != null) {
      if (_images.isNotEmpty) {
        if (_images.asMap()[index] == null) {
          print('in add');
          _images.add(File(pickedFile.path));
        } else {
          print('in insert');
          _images[index] = File(pickedFile.path);
        }
      } else
        _images.add(File(pickedFile.path));
      print(index);
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
                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          border: Border.all(color: Colors.white, width: 1),
                          color: Colors.white),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(maxHeight: 150, minHeight: 100.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: 3,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                bool? done = await selectImageSrcs();
                                if (done??false) {
                                  getPhotos(index, imgSrc);
                                }
                                setState(() {});
                              },
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: 95,
                                    height: 95,
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        border: Border.all(
                                            color: Color(0xFFB9B9B9)),
                                        color: Color(0xFFF3F3F3)),
                                    alignment: Alignment.center,
                                    child: _images.asMap()[index] == null
                                        ? Icon(
                                            Icons.camera_alt,
                                            size: 30,
                                          )
                                        : Image.file(_images[index]),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
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
                  RaisedButton(
                    child: Text(
                      AppLocalizations.of(context)?.translate('selectOnMap')??"",
                    ),
                    onPressed: () {
                      void _navigateAndDisplaySelection(BuildContext context) async {
                        // Navigator.push returns a Future that completes after calling
                        // Navigator.pop on the Selection Screen.
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MapScreen()),
                        );

                        // After the Selection Screen returns a result, hide any previous snackbars
                        // and show the new result.
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(SnackBar(content: Text('$result')));
                      }
                    },
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
                          "${AppLocalizations.of(context)?.translate('save')}",
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

  Future<bool?> selectImageSrcs() async {
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
    final pickedFile = await picker.getImage(source: src);
    if (pickedFile != null) {
      img = File(pickedFile.path);
    }
    setState(() {});
  }

  signUp() async {
    isLoading = true;
    setState(() {});
    AuthResult result = await CompaniesService().companyeditProfile(
        username:
            _usernameController.text == "" ? "" : _usernameController.text,
        password:
            _passwordController.text == "" ? "" : _passwordController.text,
        mobile: _mobileController.text == "" ? "" : _mobileController.text,
        name: _nameController.text == "" ? "" : _nameController.text,
        nameEn: _nameEnController.text == "" ? "" : _nameEnController.text,
        email: _emailController.text == "" ? "" : _emailController.text,
        img1: _images.isEmpty ? null : _images.first,
        img2: _images.length < 2 ? null : _images[1],
        img3: _images.length < 3 ? null : _images[2],
        address: addressController.text == "" ? null : addressController.text,
        details:
            detailsArController.text == "" ? null : detailsArController.text,
        detailsEn:
            detailsEnController.text == "" ? null : detailsEnController.text,
        // location: selectedPlace == null
        //     ? "0,0"
        //     : "${selectedPlace!.geometry!.location.lat},${selectedPlace!.geometry!.location.lng}",
        categoryId: selectedCat == null ? null : selectedCat!.categoryId);
    if (result.status == "success") {
      final snackBar = SnackBar(
          content: Text(
              "${AppLocalizations.of(context)?.translate('signinSuccessMsg')}"));
      scaffoldKey.currentState?.showSnackBar(snackBar);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => CompanyProfileScreen(),
      ));
    } else {
      final snackBar = SnackBar(
          content: Text(Localizations.localeOf(context).languageCode == "en"
              ? result.messageEn!
              : result.messageAr!));
      scaffoldKey.currentState?.showSnackBar(snackBar);
    }
    isLoading = false;
    setState(() {});
  }
}
