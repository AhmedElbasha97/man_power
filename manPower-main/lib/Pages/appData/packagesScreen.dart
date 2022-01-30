import 'package:flutter/material.dart';
import 'package:manpower/Global/theme.dart';
import 'package:manpower/Global/utils/helpers.dart';
import 'package:manpower/models/AppInfo/packages.dart';
import 'package:manpower/services/OtherServices.dart/appDataService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PackagesScreen extends StatefulWidget {
  @override
  _PackagesScreenState createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  bool isLoading = true;
  List<PackagesModel> list = [];
   String? id;

  getPackages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString("id");
    list = await AppDataService().getPackages();
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPackages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: list.length,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () {
                      launchURL(
                          "http://manpower-kw.com/api/pay?client_id=$id&package_id=${list[index].packageId}");
                    },
                    tileColor: mainOrangeColor,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.money, color: Colors.white),
                        Text(
                          Localizations.localeOf(context).languageCode == "en"
                              ? "${list[index].titleEn}"
                              : "${list[index].titleAr}",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Text(
                          "${list[index].value}",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
