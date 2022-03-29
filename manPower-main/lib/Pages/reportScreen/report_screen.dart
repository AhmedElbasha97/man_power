
import 'package:flutter/material.dart';
import 'package:manpower/Global/theme.dart';
import 'package:manpower/models/other/report_type_model.dart';
import 'package:manpower/services/report_services.dart';
import 'package:manpower/widgets/loader.dart';

class ReportScreen extends StatefulWidget {
  final String employerId;
  const ReportScreen({Key? key, required this.employerId}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
late List<ReportType> type;
var selectedReason;
var isLoading = true;
late ReportType selectedType ;
var commentController =TextEditingController();
  @override
  void initState() {
    getData();
    super.initState();
  }
  getData()async{
 type= (await ReportServices().getListOfReportType())??[];
 isLoading=false;
 setState(() {

 });
  }
  void _showDialog(String content,String title) {

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(
          Localizations.localeOf(context).languageCode == "en"
              ?"send report":"إرسال تقرير",
          style: TextStyle(color: mainOrangeColor),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: mainOrangeColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading?Loader():SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Container(
                child: Column(
                  children: [
                    Container(
                      height: 70,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3.5),
                      width:
                      MediaQuery.of(context).size.width * 0.8,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(5)),
                        border: Border.all(
                          color: mainBlueColor,
                        ),
                      ),
                      child: DropdownButton<ReportType>(
                        isDense: true,
                        isExpanded: true,
                        hint: Text(
                            selectedReason != null
                                ? selectedReason: Localizations.localeOf(context).languageCode == "en"
                                ?"reason for reporting":"سبب الابلاغ",
                            style: TextStyle(
                              fontSize: 13,
                            )),
                        underline: SizedBox(),
                        items: type
                            .map<DropdownMenuItem<ReportType>>(
                                (value) => new DropdownMenuItem<
                                    ReportType>(
                              value: value,
                              child: new Text(
                                  Localizations.localeOf(context).languageCode == "en"
                                      ?value.titleen??"":value.titlear??"",
                                  style: TextStyle(
                                    fontSize: 13,
                                  )),
                            ))
                            .toList(),

                        onChanged: (value) {
                          selectedType = value!;
                          selectedReason =Localizations.localeOf(context).languageCode == "en"
                              ? value.titleen:value.titlear;
                          print(value);
                          print(selectedReason);
                          setState(() {
                          });
                        },
                      ),
                    ), Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color:mainBlueColor,width: 1),
                          ),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              decoration:  InputDecoration(
                                hintText:  Localizations.localeOf(context).languageCode == "en"
                                    ?"write what do you want to report it.......":"اكتب ما تريد الابلاغ عنه.........",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              controller: commentController,

                            ),
                          ),
                        )),
                  ],
                ),
              ),

              InkWell(
                  onTap: () {
                    _showDialog( Localizations.localeOf(context).languageCode == "en"
                        ?"we will check your report and if there any violation the system will make all necessary actions ":"سوف يتم النظر إليها والتحقق منها واتخاذ كافة الإجراءات اللازمة", Localizations.localeOf(context).languageCode == "en"
                        ?"your report has been send":"تم ارسال شكوك",);
                    ReportServices().sendReport(widget.employerId, commentController.text, selectedType.id??"");
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: mainOrangeColor),
                    child: Text( Localizations.localeOf(context).languageCode == "en"
                        ?"send report":"إرسال تقرير",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ))
            ],

          ),
        ),
      ),
    );
  }
}
