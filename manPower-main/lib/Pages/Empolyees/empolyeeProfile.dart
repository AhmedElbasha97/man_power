import 'package:flutter/material.dart';
import 'package:manpower/Global/theme.dart';
import 'package:manpower/Global/utils/helpers.dart';
import 'package:manpower/Global/widgets/MainDrawer.dart';
import 'package:manpower/I10n/app_localizations.dart';
import 'package:manpower/Pages/Chat/chatList.dart';
import 'package:manpower/Pages/Empolyees/EditProfileData.dart';
import 'package:manpower/models/Companies/Employees.dart';
import 'package:manpower/services/workersService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeProfile extends StatefulWidget {
  @override
  _EmployeeProfileState createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {
  bool isLoading = true;
   String? type;
   String? id;
   Employees? worker;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    type = prefs.getString("type");
    id = prefs.getString("id");
    worker = (await WorkerService().getWorkerProfile(id: id));
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: isLoading ? Container() : MainDrawer(id, type),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: EdgeInsets.all(10),
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage("${worker!.image1 ?? ""}"),
                      ),
                    ],
                  ),
                ),
                ListTile(
                    tileColor: mainBlueColor,
                    title: Text(
                      "${AppLocalizations.of(context)?.translate('messages')}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                      textScaleFactor: 1.0,
                    ),
                    leading: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: mainOrangeColor,
                      ),
                      child: Icon(
                        Icons.message,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      pushPage(context, ChatList());
                    }),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${AppLocalizations.of(context)?.translate('name')}:",
                            style:
                                TextStyle(fontSize: 14, color: mainBlueColor),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${Localizations.localeOf(context).languageCode == "en" ? worker!.nameEn : worker!.nameAr ?? ""}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: mainOrangeColor),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.grey[300],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${AppLocalizations.of(context)?.translate('contractTime')}:",
                            style:
                                TextStyle(fontSize: 14, color: mainBlueColor),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            worker?.contractPeriod ?? "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: mainOrangeColor),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${AppLocalizations.of(context)?.translate('exp')}:",
                            style:
                                TextStyle(fontSize: 14, color: mainBlueColor),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            worker?.experience ?? "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: mainOrangeColor),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey[300],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${AppLocalizations.of(context)?.translate('passportNo')}:",
                            style:
                                TextStyle(fontSize: 14, color: mainBlueColor),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            worker?.additional?.passportNo ?? "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: mainOrangeColor),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${AppLocalizations.of(context)?.translate('phoneNumber')}:",
                          style: TextStyle(fontSize: 14, color: mainBlueColor),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          worker?.company?.mobile ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: mainOrangeColor),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  color: Colors.grey[300],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${AppLocalizations.of(context)?.translate('birthday')}:",
                            style:
                                TextStyle(fontSize: 14, color: mainBlueColor),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${worker?.birthDate}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: mainOrangeColor),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${AppLocalizations.of(context)?.translate('monthlySalary')}:",
                            style:
                                TextStyle(fontSize: 14, color: mainBlueColor),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            worker?.salary ?? "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: mainOrangeColor),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey[300],
                  child: worker!.language!.isEmpty
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${AppLocalizations.of(context)?.translate('language')}:",
                                  style: TextStyle(
                                      fontSize: 14, color: mainBlueColor),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: 30,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: worker!.language?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Text(
                                    Localizations.localeOf(context)
                                                .languageCode ==
                                            "en"
                                        ? worker!.language![index].titleEn!
                                        : worker!.language![index].titleAr!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: mainOrangeColor),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${AppLocalizations.of(context)?.translate('nationality')}:",
                            style:
                                TextStyle(fontSize: 14, color: mainBlueColor),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            worker?.nationality?.titleAr ?? "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: mainOrangeColor),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey[300],
                  child: worker!.skills!.isEmpty
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${AppLocalizations.of(context)?.translate('skills')}:",
                                  style: TextStyle(
                                      fontSize: 14, color: mainBlueColor),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: 30,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: worker?.skills?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Text(
                                    Localizations.localeOf(context)
                                                .languageCode ==
                                            "en"
                                        ? "${worker?.skills![index].titleEn}"
                                        : "${worker?.skills![index].titleAr}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: mainOrangeColor),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${AppLocalizations.of(context)?.translate('socialStatus')}:",
                            style:
                                TextStyle(fontSize: 14, color: mainBlueColor),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            worker?.status?.titleAr ?? "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: mainOrangeColor),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey[300],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${AppLocalizations.of(context)?.translate('city')}:",
                            style:
                                TextStyle(fontSize: 14, color: mainBlueColor),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${worker?.residence?.titleAr ?? ""}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: mainOrangeColor),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                    tileColor: Colors.white,
                    title: Text(
                      "${AppLocalizations.of(context)?.translate('editProfile')}",
                      style: TextStyle(
                          color: Color(0xFF0671bf),
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                      textScaleFactor: 1.0,
                    ),
                    leading: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: mainOrangeColor,
                      ),
                      child: Icon(
                        Icons.people,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      pushPage(
                          context,
                          EditCvScreen(
                            data: worker,
                            id: worker!.workerId,
                          ));
                    }),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
    );
  }
}
