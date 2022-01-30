import 'package:flutter/material.dart';
import 'package:manpower/Global/theme.dart';
import 'package:manpower/Pages/Empolyees/employeesListScreen.dart';
import 'package:manpower/Pages/home_screen.dart';

class CompanyCategoryCard extends StatefulWidget {
  final String? name;
  final String? id;
  final bool? isSpecial;
  CompanyCategoryCard({ this.name,  this.id,  this.isSpecial});
  @override
  _CompanyCategoryCardState createState() => _CompanyCategoryCardState();
}

class _CompanyCategoryCardState extends State<CompanyCategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
          onTap: () {
            if (widget.isSpecial!) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeScreen(
                  categoryId: "${widget.id}",
                ),
              ));
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EmployeesScreen(
                  id: "${widget.id}",
                ),
              ));
            }
          },
          tileColor: mainOrangeColor,
          title: Row(
            children: [
              Icon(Icons.work, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "${widget.name}",
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
            ],
          ),
          trailing: Icon(Icons.arrow_forward_ios, color:  Colors.white)),
    );
  }
}
