import 'package:flutter/material.dart';
import 'package:manpower/Global/theme.dart';

class MainButton extends StatefulWidget {
  final Function? onTap;
  final String? label;
  MainButton({ this.label,  this.onTap});
  @override
  _MainButtonState createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){widget.onTap!();},
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: mainOrangeColor),
        child: Center(
            child: Text(
          "${widget.label}",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        )),
      ),
    );
  }
}
