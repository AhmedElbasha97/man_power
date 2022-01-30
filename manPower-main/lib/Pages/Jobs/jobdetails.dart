import 'package:flutter/material.dart';
import 'package:manpower/I10n/app_localizations.dart';
import 'package:manpower/models/other/vacancy.dart';

class JobsDetailsScreen extends StatefulWidget {
  final Vacancy? job;
  JobsDetailsScreen({this.job});
  @override
  _JobsDetailsScreenState createState() => _JobsDetailsScreenState();
}

class _JobsDetailsScreenState extends State<JobsDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/icon/logoAppBar.png",
                  scale: 4, fit: BoxFit.scaleDown))),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        children: [
          Text(
            widget.job?.title ?? "",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Divider(),
          Text(
            widget.job?.details ?? "",
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${AppLocalizations.of(context)?.translate('joblocation')} :" + "${widget.job?.jobLocation ?? " "}",
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${AppLocalizations.of(context)?.translate('jobtype')} :" + "${widget.job?.jobType ?? ""}",
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${AppLocalizations.of(context)?.translate('monthlySalary')} :" +
                    "${widget.job?.salary ?? ""}",
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${AppLocalizations.of(context)?.translate('notes')} :" + "${widget.job?.notes ??""}",
            style: TextStyle(
              fontSize: 17,
            ),
          )
        ],
      ),
    );
  }
}
