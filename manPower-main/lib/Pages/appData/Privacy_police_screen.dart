import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:manpower/models/other/privacy_policy_model.dart';
import 'package:manpower/services/OtherServices.dart/appDataService.dart';
import 'package:manpower/widgets/loader.dart';
class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool isLoading =true;
  late PrivacyPolicyModel  data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  getData() async {
    data =await AppDataService().getPrivacyPolicy();
    isLoading = false;
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Color(0xFF0671bf)),
        backgroundColor: Colors.grey[50],
        title: Text(
          Localizations.localeOf(context).languageCode == "en"
              ? "privacy policy"
              : "سياسة خاصة",
          style: TextStyle(color: Color(0xFF0671bf)),
        ),
        centerTitle: true,
      ),
      body:  isLoading
          ? Loader()
          :Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                      Localizations.localeOf(context).languageCode == "en"
                          ? "${data.titleEn ?? ""}"
                          : "${data.titleAr ?? ""}"),
                  Padding(
                    padding: EdgeInsets.only(right: 40, left: 20),
                    child: Html(data:Localizations.localeOf(context).languageCode == "en"
                        ? "${data.detailsEn ?? ""}"
                        : "${data.detailsAr ?? ""}") ,
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
