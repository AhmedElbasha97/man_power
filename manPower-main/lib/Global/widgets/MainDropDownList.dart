// import 'package:flutter/material.dart';

// class MainDropDown extends StatefulWidget {
//   @override
//   _MainDropDownState createState() => _MainDropDownState();
// }

// class _MainDropDownState extends State<MainDropDown> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
//                   width: MediaQuery.of(context).size.width * 0.5,
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), border: Border.all(color: Color(0xFF0671bf))),
//                   child: DropdownButton(
//                       isDense: true,
//                       isExpanded: true,
//                       value: schoolIndex,
//                       hint: Text("المراحل الدراسه", style: TextStyle(fontSize: 16)),
//                       underline: SizedBox(),
//                       items: dropdownMenuItemStagesList,
//                       onChanged: (value) {
//                         setState(() {
//                           schoolIndex = value;
//                         });
//                       }),
//                 );
//   }
// }