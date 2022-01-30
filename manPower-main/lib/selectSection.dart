import 'package:flutter/material.dart';
import 'package:manpower/Global/theme.dart';
import 'package:manpower/I10n/app_localizations.dart';
import 'package:manpower/Pages/CVs/AddCVScreen.dart';
import 'package:manpower/Pages/Jobs/addNewJob.dart';
import 'package:manpower/pages/searchForEmplyee.dart';

class SelectSections extends StatefulWidget {
  @override
  _SelectSectionsState createState() => _SelectSectionsState();
}

class _SelectSectionsState extends State<SelectSections> {
  @override
  Widget build(BuildContext context) {
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
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddCvScreen(),
              ));
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: mainOrangeColor),
              child: Text(
                  "${AppLocalizations.of(context)?.translate('uploadCv')}",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10)),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddNewJobScreen(),
              ));
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: mainOrangeColor),
              child: Text("${AppLocalizations.of(context)?.translate('addJob')}",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10)),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SearchForEmployee(),
              ));
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: mainOrangeColor),
              child: Text(
                  "${AppLocalizations.of(context)?.translate('searchEmployee')}",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
