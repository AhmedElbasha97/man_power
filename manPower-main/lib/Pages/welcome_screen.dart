import 'package:manpower/Global/widgets/MainButton.dart';
import 'package:manpower/I10n/app_localizations.dart';
import 'package:manpower/Pages/CVs/AddCVScreen.dart';
import 'package:manpower/Pages/auth/signUpScreen.dart';
import 'package:manpower/Pages/companies/SignUpCompany.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Image.asset(
                "assets/icon/logo.png",
                scale: 2,
              ),
              Padding(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
              Container(
                width: MediaQuery.of(context).size.width,
              ),
              MainButton(
                label:
                    "${AppLocalizations.of(context)?.translate('addUserAccount')}",
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ClientSignUp()));
                },
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              MainButton(
                label:
                    "${AppLocalizations.of(context)?.translate('addCompanyAccount')}",
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CompanySignUp()));
                },
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              MainButton(
                label:
                    "${AppLocalizations.of(context)?.translate('addEmpolyeeAccount')}",
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddCvScreen()));
                },
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
            ],
          )
        ],
      ),
    );
  }
}
