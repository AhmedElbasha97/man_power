import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manpower/services/Companies/CompaniesService.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeCard extends StatefulWidget {
  final String? title;
  final String? image;
  final String? address;
  final String? facebookUrl;
  final String? whatsappUrl;
  final String? instagramUrl;
  final String? twitterUrl;
  final String? phone;
  final String? categoryId;

  HomeCard(
      { this.categoryId,
       this.image,
       this.phone,
       this.address,
       this.title,
       this.facebookUrl,
       this.whatsappUrl,
       this.twitterUrl,
       this.instagramUrl});

  @override
  _HomeCardState createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  _launchURL(String url,String nameOfSocialProgram) async {
    if(url == "" || url == "https://wa.me/" || url == "tel:"){
      _showDialog( Localizations.localeOf(context).languageCode == "en"
          ?"the $nameOfSocialProgram is not available at the moment": "منصة"+" "+nameOfSocialProgram+" "+" غير متاحه الان",  Localizations.localeOf(context).languageCode == "en"
          ?"sorry":"عذرا");
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  sendClick(id, socialMedia) {
    CompaniesService().socialMediaClicked(id, socialMedia);
  }

  void _showDialog(String content,String title) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new TextButton(
              child: new Text( Localizations.localeOf(context).languageCode == "en"
                  ?"Close":"اغلق"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: SizedBox(
                  child: Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 30,
                                child: Text(
                                  "${widget.title}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF0671bf),
                                      fontWeight: FontWeight.bold),
                                  textScaleFactor: 1.0,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                height: 30,
                                child: Text(
                                  "${widget.address}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                  textScaleFactor: 1.0,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(padding: EdgeInsets.symmetric(horizontal: 1)),
                          InkWell(
                            onTap: () {
                              sendClick(widget.categoryId, "facebook");
                              _launchURL("${widget.facebookUrl}","facebook");
                            },
                            child: Image.asset(
                              "assets/icon/facebook.png",
                              scale: 1.8,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              sendClick(widget.categoryId, "instagram");
                              _launchURL("${widget.instagramUrl}","instagram");
                            },
                            child: Image.asset(
                              "assets/icon/instagram.png",
                              scale: 1.8,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              sendClick(widget.categoryId, "twitter");
                              _launchURL("${widget.twitterUrl}","twitter");
                            },
                            child: Image.asset(
                              "assets/icon/twitter.png",
                              scale: 1.8,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              sendClick(widget.categoryId, "whatsapp");
                              _launchURL("https://wa.me/${widget.whatsappUrl}","whatsapp");
                            },
                            child: Image.asset(
                              "assets/icon/whatsapp.png",
                              scale: 1.8,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _launchURL("tel:${widget.phone}","mobile");
                              sendClick(widget.categoryId, "mobile");
                            },
                            child: Image.asset(
                              "assets/icon/call.jpeg",
                              scale: 1.9,
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 1)),
                        ],
                      ),
                    ],
                  ),
                )),
                Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.225,
                    height: MediaQuery.of(context).size.height * 0.145,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: Color(0xFF0671bf))),
                    padding: EdgeInsets.all(2),
                    child: CachedNetworkImage(
                      imageUrl: "${widget.image}",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
          ],
        ),
      ),
    );
  }
}
