import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BigPicture extends StatefulWidget {
  String? link;
  BigPicture({ this.link});
  @override
  _BigPictureState createState() => _BigPictureState();
}

class _BigPictureState extends State<BigPicture> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Image.network(widget.link!, fit: BoxFit.cover, width: 1000)),
    );
  }
}
