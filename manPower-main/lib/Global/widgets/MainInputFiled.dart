import 'package:flutter/material.dart';
import 'package:manpower/Global/theme.dart';

class MainInputFiled extends StatefulWidget {
  final String? label;
  final TextInputType inputType;
  final TextEditingController? controller;
  final bool enabled;
  final Function(String?)? validator;
  final FocusNode? focusNode;
  MainInputFiled(
      { this.label,
      this.inputType = TextInputType.text,
       this.controller,
      this.enabled = true,
       this.validator,
       this.focusNode});
  @override
  _MainInputFiledState createState() => _MainInputFiledState();
}

class _MainInputFiledState extends State<MainInputFiled> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        validator: (value){widget.validator!(value);},
        keyboardType: widget.inputType,
        controller: widget.controller,
        focusNode: widget.focusNode,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            enabled: widget.enabled,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 4,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: mainOrangeColor)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: mainOrangeColor)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: mainOrangeColor)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.blueAccent)),
            hintStyle: TextStyle(fontSize: 12),
            hintText: "${widget.label}"),
      ),
    );
  }
}
