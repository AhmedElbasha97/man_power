import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manpower/Global/theme.dart';
import 'package:manpower/I10n/AppLanguage.dart';
import 'package:manpower/I10n/app_localizations.dart';
import 'package:manpower/Pages/appData/terms_screen.dart';
import 'package:manpower/Pages/auth/logIn_screen.dart';
import 'package:manpower/Pages/welcome_screen.dart';
import 'package:manpower/services/chatService.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

changeLangPopUp(BuildContext context) {
  var appLanguage = Provider.of<AppLanguage>(context);
  return CupertinoActionSheet(
    title: new Text('${AppLocalizations.of(context)?.translate('language')}'),
    message:
        new Text('${AppLocalizations.of(context)?.translate('changeLanguage')}'),
    actions: <Widget>[
      CupertinoActionSheetAction(
        child: new Text('English'),
        onPressed: () {
          appLanguage.changeLanguage(Locale("en"));
          Navigator.pop(context);
        },
      ),
      CupertinoActionSheetAction(
        child: new Text('عربى'),
        onPressed: () {
          appLanguage.changeLanguage(Locale("ar"));
          Navigator.pop(context);
        },
      )
    ],
    cancelButton: CupertinoActionSheetAction(
      child: new Text('رجوع'),
      isDefaultAction: true,
      onPressed: () {
        Navigator.pop(context, 'Cancel');
      },
    ),
  );
}

List<T?> map<T>(List list, Function handler) {
  List<T?> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }
  return result;
}



showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('تسجيل الدخول'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('قم بتسجيل الدخول لتتمكن من إتمام عملية التسجيل.'),
            ],
          ),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: Text(
                'تسجيل الدخول',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LogInScreen(),
                ));
              },
            ),
          ),
          Center(
            child: TextButton(
              child: Text('مستخدم جديد',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => WelcomeScreen(),
                ));
              },
            ),
          ),
          Center(
            child: TextButton(
              child:
                  Text('رجوع', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      );
    },
  );
}

///////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////
/// Page Navigation pages
////////////////////////////////////////////////
void popPage(BuildContext context) {
  Navigator.of(context).pop();
}

void pushPage(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void pushPageReplacement(BuildContext context, Widget widget) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => widget));
}

////////////////////////////////////////////////
/// utilities
////////////////////////////////////////////////
bool emailvalidator(String email) {
  bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
  return emailValid;
}

////////////////////////////////////////////////
////////////////////////////////////////////////

void showTheDialog(BuildContext context, String title, String body,
    { Widget extraAction = const SizedBox()}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      List<Widget> actions = [];
      actions.add(
        new TextButton(
          child: new Text(AppLocalizations.of(context)?.translate('back')??""),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      );
      actions.add(extraAction);
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        title: new Text(title == "" ? "" : title),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          child: Column(
            children: <Widget>[
              new Text(body == "" ? "" : body),
            ],
          ),
        ),
        actions: actions,
      );
    },
  );
}

void showMsgDialog(BuildContext context, String? clientId, String workerId) {
  bool chatloading = false;
  final TextEditingController textEditingController =
      new TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      // Text input
                      Flexible(
                        child: Container(
                          child: TextField(
                            textInputAction: TextInputAction.send,
                            onEditingComplete: () async {
                              if (textEditingController.text.isNotEmpty) {
                                chatloading = true;
                                setState(() {});
                                await ChatService().sendMessage(workerId,
                                    clientId, textEditingController.text);
                                textEditingController.clear();
                                chatloading = false;
                                setState(() {});
                                popPage(context);
                              }
                            },
                            style: TextStyle(fontSize: 15.0),
                            controller: textEditingController,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)
                                  ?.translate('typeMsg'),
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      // Send Message Button
                      Material(
                        child: new Container(
                          child: chatloading
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : new IconButton(
                                  icon: new Icon(Icons.send),
                                  onPressed: () async {
                                    if (textEditingController.text.isNotEmpty) {
                                      chatloading = true;
                                      setState(() {});
                                      await ChatService().sendMessage(workerId,
                                          clientId, textEditingController.text);
                                      textEditingController.clear();
                                      chatloading = false;
                                      setState(() {});
                                      popPage(context);
                                    }
                                  },
                                  color: Color(0xFF184e7a),
                                ),
                        ),
                        color: Colors.white,
                      ),
                    ],
                  ),
                  width: double.infinity,
                  height: 50.0,
                  decoration: new BoxDecoration(
                      border: new Border(
                          top: new BorderSide(color: Colors.grey, width: 0.5)),
                      color: Colors.white),
                )
              ],
            ),
          ),
        );
      });
    },
  );
}

void showpaymentDialog(BuildContext context, Function onpay, String amount) {
  bool isAgree = false;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  "${AppLocalizations.of(context)?.translate('paymentMsg')} $amount KWD",
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        pushPage(context, TermsScreen());
                      },
                      child: new Text(
                        AppLocalizations.of(context)?.translate('termsAgree')??"",
                        style: TextStyle(color: Colors.blue, fontSize: 13),
                      ),
                    ),
                    Checkbox(
                      value: isAgree,
                      onChanged: ( value) {
                        setState(() {
                          isAgree = value??false;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        if (isAgree) {
                          onpay();
                        }
                      },
                      color: mainOrangeColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      child: Text(
                        AppLocalizations.of(context)?.translate('agree')??"",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      child: Text(
                        AppLocalizations.of(context)?.translate('cancel')??"",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      });
    },
  );
}
