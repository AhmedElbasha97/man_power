import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manpower/Global/theme.dart';
import 'package:manpower/Global/utils/helpers.dart';
import 'package:manpower/I10n/app_localizations.dart';
import 'package:manpower/models/Companies/Employees.dart';
import 'package:manpower/widgets/Employees/bigPicture.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeesScreen extends StatefulWidget {
  final String amount;
  final Employees? data;
  final bool isCompany;
  final Function? onagree;

  EmployeesScreen(
      {this.data, this.isCompany = false, this.onagree, this.amount = ""});
  @override
  _EmployeesScreenState createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  List<String?> imgList = [];
  final CarouselController _controller = CarouselController();
  silderdata() {
    if (widget.data != null) {
      if (widget.data!.image1 != null) {
        print(widget.data!.image1);
        imgList.add(
          widget.data!.image1,
        );
      }
      if (widget.data!.image2 != null) {
        print(widget.data!.image2);
        imgList.add(
          widget.data!.image2,
        );
      }
      if (widget.data!.image3 != null) {
        print(widget.data!.image3);
        imgList.add(
          widget.data!.image3,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    silderdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/icon/logoAppBar.png",
                scale: 4.5, fit: BoxFit.scaleDown)),
      ),
      body: ListView(
        children: [
          Container(
              child: CarouselSlider.builder(
                carouselController: _controller,
                itemCount: imgList.length,
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BigPicture(
                            link: imgList[index],
                          ),
                        ));
                      },
                      child: Center(
                          child: CachedNetworkImage(
                            imageUrl: imgList[index]!,
                            fit: BoxFit.cover,
                            width: 1000.0,
                            placeholder: (context, url) => SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) =>SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: Image.asset("assets/icon/employerPlaceHolder.png"),
                            ),
                          ),),
                    ),
                  );
                },
            options: CarouselOptions(
              autoPlay: true,
              viewportFraction: 1.0,
              height: MediaQuery.of(context).size.height * 0.3,
            ),

          )),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 110,
                height: 40,
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: mainOrangeColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        if (widget.isCompany || widget.data!.isPaid!) {
                          launchURL("https://wa.me/${widget.data?.whatsapp}" +
                              "?text=" +
                              """ 
رأيت العامل/ة في تطبيق مان بور الجنسية - ${widget.data!.nationality!.titleAr} 
(${widget.data!.occupation!.titleAr})
وأريد حجزه / حجزها 

‏Nationality - ${widget.data!.nationality!.titleEn},(${widget.data!.occupation!.titleEn}) in Manpower APP ‏and I want book him / her Link him / her
                          """);
                        } else {
                          showpaymentDialog(context, () {
                            Navigator.of(context).pop();
                            if (widget.onagree != null) {
                              widget.onagree!();
                            }
                          }, widget.amount);
                        }
                      },
                      child: Text("WhatsApp",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          )),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  if (widget.isCompany || widget.data!.isPaid!) {
                    launchURL("tel:${widget.data?.company?.mobile}");
                  } else {
                    showpaymentDialog(context, () {
                      Navigator.of(context).pop();
                      if (widget.onagree != null) {
                        widget.onagree!();
                      }
                    }, widget.amount);
                  }
                },
                child: Container(
                  width: 110,
                  height: 40,
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: mainOrangeColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.phone,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("${AppLocalizations.of(context)?.translate('call')}",
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String userId = prefs.getString("id") ?? "";
                  if (widget.isCompany || widget.data!.isPaid!) {
                    showMsgDialog(context, widget.data!.workerId, userId);
                  } else {
                    showpaymentDialog(context, () {
                      Navigator.of(context).pop();
                      if (widget.onagree != null) {
                        widget.onagree!();
                      }
                    }, widget.amount);
                  }
                },
                child: Container(
                  width: 100,
                  height: 40,
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: mainOrangeColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.commentAlt,
                          size: 20, color: Colors.white),
                      SizedBox(
                        width: 5,
                      ),
                      Text("${AppLocalizations.of(context)?.translate('chat')}",
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              )
            ],
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
                      "${AppLocalizations.of(context)?.translate('name')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Localizations.localeOf(context).languageCode == "en"
                          ? "${widget.data?.nameEn ?? ""}"
                          : "${widget.data?.nameAr ?? ""}",
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
                      "${AppLocalizations.of(context)?.translate('job')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Localizations.localeOf(context).languageCode == "en"
                          ? "${widget.data?.occupation?.titleEn ?? ""}"
                          : "${widget.data?.occupation?.titleAr ?? ""}",
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
                      "${AppLocalizations.of(context)?.translate('contractTime')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.data?.contractPeriod ?? "",
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
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.data?.experience ?? "",
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
                      "${AppLocalizations.of(context)?.translate('birthday')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${widget.data?.birthDate}",
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
                      "${AppLocalizations.of(context)?.translate('monthlySalary')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.data?.salary ?? "",
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
            child: widget.data!.language!.isEmpty
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
                            style:
                                TextStyle(fontSize: 14, color: mainBlueColor),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.data?.language?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Text(
                              Localizations.localeOf(context).languageCode ==
                                      "en"
                                  ? widget.data?.language![index].titleEn??""
                                  : widget.data?.language![index].titleAr??"",
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
            color: Colors.grey[300],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${AppLocalizations.of(context)?.translate('nationality')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Localizations.localeOf(context).languageCode == "en"
                          ? "${widget.data?.nationality?.titleEn ?? ""}"
                          : "${widget.data?.nationality?.titleAr ?? ""}",
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
            child: widget.data!.skills!.isEmpty
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
                            style:
                                TextStyle(fontSize: 14, color: mainBlueColor),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.data?.skills?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Text(
                              Localizations.localeOf(context).languageCode ==
                                      "en"
                                  ? "${widget.data?.skills![index].titleEn}"
                                  : "${widget.data?.skills![index].titleAr}",
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
            color: Colors.grey[300],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${AppLocalizations.of(context)?.translate('socialStatus')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Localizations.localeOf(context).languageCode == "en"
                          ? widget.data?.status?.titleEn ?? ""
                          : widget.data?.status?.titleAr ?? "",
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
                      "${AppLocalizations.of(context)?.translate('city')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Localizations.localeOf(context).languageCode == "en"
                          ? "${widget.data?.residence?.titleEn ?? ""}"
                          : "${widget.data?.residence?.titleAr ?? ""}",
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
            child: widget.data!.education!.isEmpty
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${AppLocalizations.of(context)?.translate('certificates')}:",
                            style:
                                TextStyle(fontSize: 14, color: mainBlueColor),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 30,
                        child: ListView.builder(
                          itemCount: widget.data?.education?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Text(
                              Localizations.localeOf(context).languageCode ==
                                      "en"
                                  ? "${widget.data?.education![index].titleEn ?? ""}"
                                  : "${widget.data?.education![index].titleAr ?? ""}",
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
                      "${AppLocalizations.of(context)?.translate('age')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${widget.data?.age ?? ''}",
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
                      "${AppLocalizations.of(context)?.translate('birthday')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${widget.data?.birthDate}",
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
                      "${AppLocalizations.of(context)?.translate('religion')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Localizations.localeOf(context).languageCode == "en"
                          ? "${widget.data?.religion?.titleEn ?? ""}"
                          : "${widget.data?.religion?.titleEn ?? ""}",
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
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.data?.additional?.passportNo ?? "",
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
          widget.data?.additional == null
              ? Container()
              : Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${AppLocalizations.of(context)?.translate('kidsNo')}:",
                                style: TextStyle(
                                    fontSize: 14, color: mainBlueColor),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.data?.additional?.children ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: mainOrangeColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${AppLocalizations.of(context)?.translate('passportissueDate')}:",
                                style: TextStyle(
                                    fontSize: 14, color: mainBlueColor),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.data?.additional?.passportDate ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: mainOrangeColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey[300],
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${AppLocalizations.of(context)?.translate('passportEndDate')}:",
                                style: TextStyle(
                                    fontSize: 14, color: mainBlueColor),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.data?.additional?.passportExpDate ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: mainOrangeColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${AppLocalizations.of(context)?.translate('weight')}:",
                                style: TextStyle(
                                    fontSize: 14, color: mainBlueColor),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.data?.additional?.weight ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: mainOrangeColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey[300],
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${AppLocalizations.of(context)?.translate('height')}:",
                                style: TextStyle(
                                    fontSize: 14, color: mainBlueColor),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.data?.additional?.length ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: mainOrangeColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
