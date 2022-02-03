import 'package:manpower/I10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:manpower/models/AppInfo/termsData.dart';
import 'package:manpower/services/OtherServices.dart/appDataService.dart';
import 'package:manpower/widgets/loader.dart';

class TermsScreen extends StatefulWidget {
  @override
  _TermsScreenState createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
   TermsData? term;
  bool isloading = true;

  getTerms() async {
    term = await AppDataService().getTerms();
    isloading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getTerms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Color(0xFF0671bf)),
        backgroundColor: Colors.grey[50],
        title: Text(
          "${AppLocalizations.of(context)?.translate('terms')}",
          style: TextStyle(color: Color(0xFF0671bf)),
        ),
        centerTitle: true,
      ),
      body: isloading
          ? Loader()
          : Scaffold(
              body: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                        Localizations.localeOf(context).languageCode == "en"
                            ? "${term?.detailsEn ?? ""}"
                            : "${term?.detailsAr ?? ""}"),
                  ),
                ),
              ),
            ),
    );
  }
}
