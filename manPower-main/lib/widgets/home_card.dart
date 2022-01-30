import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:manpower/services/Companies/CompaniesService.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeCard extends StatefulWidget {
  String? title;
  String? image;
  String? address;
  String? facebookUrl;
  String? whatsappUrl;
  String? instagramUrl;
  String? twitterUrl;
  String? phone;
  String? categoryId;

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
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  sendClick(id, socialMedia) {
    CompaniesService().socialMediaClicked(id, socialMedia);
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
                              _launchURL("${widget.facebookUrl}");
                            },
                            child: Image.asset(
                              "assets/icon/facebook.png",
                              scale: 1.8,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              sendClick(widget.categoryId, "instagram");
                              _launchURL("${widget.instagramUrl}");
                            },
                            child: Image.asset(
                              "assets/icon/instagram.png",
                              scale: 1.8,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              sendClick(widget.categoryId, "twitter");
                              _launchURL("${widget.twitterUrl}");
                            },
                            child: Image.asset(
                              "assets/icon/twitter.png",
                              scale: 1.8,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _launchURL("https://wa.me/${widget.whatsappUrl}");
                            },
                            child: Image.asset(
                              "assets/icon/whatsapp.png",
                              scale: 1.8,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _launchURL("tel:${widget.phone}");
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
