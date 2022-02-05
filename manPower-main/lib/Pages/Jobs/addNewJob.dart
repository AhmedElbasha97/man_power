import 'package:flutter/material.dart';
import 'package:manpower/Global/theme.dart';
import 'package:manpower/Global/utils/helpers.dart';
import 'package:manpower/Global/widgets/MainInputFiled.dart';
import 'package:manpower/I10n/app_localizations.dart';
import 'package:manpower/services/OtherServices.dart/jobsService.dart';
import 'package:manpower/widgets/loader.dart';

class AddNewJobScreen extends StatefulWidget {
  @override
  _AddNewJobScreenState createState() => _AddNewJobScreenState();
}

class _AddNewJobScreenState extends State<AddNewJobScreen> {
  bool isLoading = false;
  int _radioSelected = 1;
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _detailsController = new TextEditingController();
  TextEditingController _salaryController = new TextEditingController();
  TextEditingController _locationController = new TextEditingController();
  TextEditingController _notesController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? Loader()
          : ListView(
              padding: EdgeInsets.all(15),
              children: [
                SizedBox(height: 10),
                MainInputFiled(
                  label: "${AppLocalizations.of(context)?.translate('title')}",
                  inputType: TextInputType.text,
                  controller: _titleController,
                ),
                SizedBox(height: 10),
                MainInputFiled(
                  label: "${AppLocalizations.of(context)?.translate('details')}",
                  inputType: TextInputType.text,
                  controller: _detailsController,
                ),
                SizedBox(height: 10),
                MainInputFiled(
                  label:
                      "${AppLocalizations.of(context)?.translate('monthlySalary')}",
                  inputType: TextInputType.text,
                  controller: _salaryController,
                ),
                SizedBox(height: 10),
                MainInputFiled(
                  label:
                      "${AppLocalizations.of(context)?.translate('joblocation')}",
                  inputType: TextInputType.text,
                  controller: _locationController,
                ),
                SizedBox(height: 10),
                MainInputFiled(
                  label: "${AppLocalizations.of(context)?.translate('notes')}",
                  inputType: TextInputType.text,
                  controller: _notesController,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "${AppLocalizations.of(context)?.translate('fulltimejob')}"),
                    Radio(
                      value: 1,
                      groupValue: _radioSelected,
                      activeColor: Colors.orange,
                      onChanged: (dynamic value) {
                        setState(() {
                          _radioSelected = value.hashCode;
                        });
                      },
                    ),
                    Text(
                        "${AppLocalizations.of(context)?.translate('tempJob')}"),
                    Radio(
                      value: 2,
                      groupValue: _radioSelected,
                      activeColor: Colors.orange,
                      onChanged: (dynamic value) {
                        setState(() {
                          _radioSelected = value.hashCode;
                        });
                      },
                    )
                  ],
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    isLoading = true;
                    setState(() {});
                    bool done = await JobsService().addnewJob(
                      title: _titleController.text,
                      details: _detailsController.text,
                      salary: _salaryController.text,
                      location: _locationController.text,
                      jobtype: _radioSelected,
                      note: _notesController.text,
                    );
                    isLoading = true;
                    setState(() {});
                    if (done) {
                      popPage(context);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: mainOrangeColor),
                    child: Text(
                        "${AppLocalizations.of(context)?.translate('addNewJob')}",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
    );
  }
}
