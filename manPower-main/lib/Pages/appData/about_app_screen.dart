import 'package:flutter_html/flutter_html.dart';
import 'package:manpower/Global/utils/helpers.dart';
import 'package:manpower/I10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manpower/models/AppInfo/about.dart';
import 'package:manpower/services/OtherServices.dart/appDataService.dart';

class AboutAppScreen extends StatefulWidget {
  @override
  _AboutAppScreenState createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
   late About data;
  bool loading = true;

  getData() async {
    data = await AppDataService().getabout();
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Color(0xFF0671bf)),
        backgroundColor: Colors.grey[50],
        title: Text("${AppLocalizations.of(context)?.translate('aboutApp')}",
            style: TextStyle(
              color: Color(0xFF0671bf),
            )),
        centerTitle: true,
      ),
      body: Scaffold(
        body: loading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  SizedBox(height: 10,),
                  Center(child: Text("${data.title}",style: TextStyle(fontWeight: FontWeight.bold))),
                  Padding(
                    padding: EdgeInsets.only(right: 40, left: 20),
                    child: Html(data: "${data.text}"),
                  ),
                  InkWell(
                    onTap: () {
                      launchURL("${data.video}");
                    },
                    child: Center(
                        child: Text("${data.video}",
                            style: TextStyle(color: Colors.blueAccent))),
                  )
                ],
              ),
      ),
    );
  }
}
