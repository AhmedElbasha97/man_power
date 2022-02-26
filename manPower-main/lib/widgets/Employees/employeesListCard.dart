import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manpower/Global/theme.dart';
import 'package:manpower/Global/utils/helpers.dart';
import 'package:manpower/I10n/app_localizations.dart';
import 'package:manpower/Pages/Empolyees/EmpolyeeDetails.dart';
import 'package:manpower/models/Companies/Employees.dart';
import 'package:manpower/services/ClientService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Pages/ChatingScreen/chating_screen.dart';

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
  final String companyID;
  final String amount;
  final bool isFavorite;
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
       this.amount="",  this.isFavorite = false, this.companyID = "0"});
  @override
  _EmployeesCardsState createState() => _EmployeesCardsState();
}

class _EmployeesCardsState extends State<EmployeesCards> {
  bool result = false;

  void initState() {
    result = widget.isFavorite;
    super.initState();
  }
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
                              color: Colors.transparent,
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: mainOrangeColor),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: "${widget.img}",
                              fit: BoxFit.cover,

                                placeholder: (context, url) =>Image.asset("assets/icon/employerPlaceHolder.png",fit: BoxFit.cover,),
                                errorWidget: (context, url,e) =>Image.asset("assets/icon/employerPlaceHolder.png",fit: BoxFit.cover,),
                              ),
                            ),
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
                                        if(result){

                                          final i= await ClientService().deleteFromFavorite( widget.data?.workerId??"");
                                         setState(()  {

                                           result =i;
                                         });
                                        }else{

                                          final i = await ClientService().addToFavorite(widget.data?.workerId??"");
                                          setState(() {

                                            result = !i;

                                          });
                                        }
                                      },
                                      child: result?FaIcon(
                                        FontAwesomeIcons.solidHeart,
                                        color: Colors.red,
                                      ):FaIcon(
                                        FontAwesomeIcons.heart,
                                        color: Colors.grey,
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
رأيت العامل/ة في تطبيق مان بور الجنسية - ${widget.data?.nationality?.titleAr} 
(${widget.data?.occupation?.titleAr})
وأريد حجزه / حجزها 

‏Nationality - ${widget.data?.nationality?.titleEn},(${widget.data?.occupation?.titleEn}) in Manpower APP ‏and I want book him / her Link him / her
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
        if(widget.isCompanyProfile||widget.isCompany){
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  ChattingScreen(reciverId: widget.companyID,)),
    );
    }else{ if(widget.data!.isPaid!) {
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
