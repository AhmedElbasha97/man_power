import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manpower/Global/theme.dart';
import 'package:manpower/Global/utils/helpers.dart';
import 'package:manpower/I10n/app_localizations.dart';
import 'package:manpower/Pages/Empolyees/EmpolyeeDetails.dart';
import 'package:manpower/models/Companies/Employees.dart';
import 'package:manpower/services/ClientService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeesCards extends StatefulWidget {
  final String? name;
  final String? cvId;
  final String? whatsApp;
  final String? img;
  final String? phone;
  final String? job;
  final String? country;
  final Employees? data;
  final bool isCV;
  final bool isCompany;
  final bool isCompanyProfile;
  final Function? onDelete;
  final Function? onagree;
  final String amount;
  EmployeesCards(
      { this.img,
       this.name,
       this.phone,
       this.country,
       this.job,
       this.data,
       this.whatsApp,
       this.cvId,
      this.isCompany = false,
       this.onDelete,
       this.onagree,
      this.isCompanyProfile = false,
      this.isCV = true,
       this.amount=""});
  @override
  _EmployeesCardsState createState() => _EmployeesCardsState();
}

class _EmployeesCardsState extends State<EmployeesCards> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EmployeesScreen(
              amount: widget.amount,
              isCompany: widget.isCompanyProfile,
              data: widget.data,
              onagree: widget.onagree),
        ));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Material(
            elevation: 2,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.22,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: mainOrangeColor),
                                image: DecorationImage(
                                  image: NetworkImage("${widget.img}"),
                                  fit: BoxFit.cover,
                                )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 80,
                            height: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.name ?? ""}",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF0671bf),
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "${widget.job ?? ""}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF0671bf),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "${widget.country ?? ""}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF0671bf),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              widget.isCompany
                                  ? Container()
                                  : InkWell(
                                      onTap: () async {
                                        bool result = await ClientService()
                                            .addToFavorite(
                                                widget.data?.workerId??"");
                                        String msg = result
                                            ? "${AppLocalizations.of(context)?.translate('addedDone')}"
                                            : "${AppLocalizations.of(context)?.translate('alreadyAdded')}";
                                        showTheDialog(context, "", msg, );
                                      },
                                      child: FaIcon(
                                        FontAwesomeIcons.heart,
                                        color: Colors.red,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  widget.isCompany
                      ? Center(
                          child: InkWell(
                            onTap: (){widget.onDelete!();},
                            child: FaIcon(
                              FontAwesomeIcons.trash,
                              color: Colors.red,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                if (widget.isCompanyProfile ||
                                    widget.data!.isPaid!) {
                                  launchURL("https://wa.me/${widget.whatsApp}" +
                                      "?text=" +
                                      """ 
???????? ????????????/?? ???? ?????????? ?????? ?????? ?????????????? - ${widget.data?.nationality?.titleAr} 
(${widget.data?.occupation?.titleAr})
?????????? ???????? / ?????????? 

???Nationality - ${widget.data?.nationality?.titleEn},(${widget.data?.occupation?.titleEn}) in Manpower APP ???and I want book him / her Link him / her
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
                              child: Container(
                                width: 100,
                                height: 35,
                                padding: EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 3),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: mainOrangeColor),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.whatsapp,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text("WhatsApp",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (widget.isCompanyProfile ||
                                    widget.data!.isPaid!) {
                                  launchURL("tel:${widget.phone}");
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
                                height: 35,
                                padding: EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 3),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: mainOrangeColor),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.phone,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                        "${AppLocalizations.of(context)?.translate('call')}",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String userId = prefs.getString("id") ?? "";
                                if (widget.isCompanyProfile ||
                                    widget.data!.isPaid!) {
                                  showMsgDialog(
                                      context, widget.data!.workerId, userId);
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
                                height: 35,
                                padding: EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 3),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: mainOrangeColor),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FaIcon(FontAwesomeIcons.commentAlt,
                                        size: 18, color: Colors.white),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                        "${AppLocalizations.of(context)?.translate('chat')}",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                ],
              ),
            )),
      ),
    );
  }
}
