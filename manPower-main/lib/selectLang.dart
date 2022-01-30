import 'package:flutter/material.dart';
import 'package:manpower/Global/theme.dart';
import 'package:manpower/I10n/AppLanguage.dart';
import 'package:manpower/selectSection.dart';
import 'package:provider/provider.dart';

class SelectLang extends StatefulWidget {
  @override
  _SelectLangState createState() => _SelectLangState();
}

class _SelectLangState extends State<SelectLang> {
  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        children: [
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 100)),
          Image.asset(
            "assets/icon/logo.png",
            scale: 2,
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 40)),
          InkWell(
            onTap: () {
              appLanguage.changeLanguage(Locale("ar"));
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SelectSections(),
              ));
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: mainOrangeColor),
              child: Text("عربي",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20)),
          InkWell(
              onTap: () {
                appLanguage.changeLanguage(Locale("en"));
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelectSections(),
                ));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: mainOrangeColor),
                child: Text("English",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ))
        ],
      ),
    );
  }
}
