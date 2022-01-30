import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'bigImgScreen.dart';

class ChatBubble extends StatefulWidget {
  final bool isMyMsg;
  final String msg;
  final bool isImg;
  final String imgLink;
  final String date;
  ChatBubble(
      {this.isMyMsg = false,
      this.msg = "",
      this.isImg = false,
      this.imgLink = "",
      this.date = ""});
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    ///////////////////////////////////////////////////////////
    /// Chat Styles
    ///////////////////////////////////////////////////////////
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;
    BubbleStyle styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topLeft,
    );
    BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Color.fromARGB(255, 225, 255, 199),
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.topRight,
    );
    return Bubble(
      style: widget.isMyMsg ? styleMe : styleSomebody,
      child: widget.isImg
          ? InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BigImgView(
                    url:
                        "${widget.imgLink.substring(0, widget.imgLink.indexOf('.jpg')).trim}.jpg",
                  ),
                ));
              },
              child: Container(
                width: 100,
                height: 100,
                child: CachedNetworkImage(
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress),
                      ),
                  imageUrl:
                      "${widget.imgLink.substring(0, widget.imgLink.indexOf('.jpg'))}.jpg",
                ),
              ),
            )
          : Column(
              children: [
                Text(
                  '${widget.date}',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                  textAlign: TextAlign.right,
                ),
                Text('${widget.msg}'),
              ],
            ),
    );
  }
}
