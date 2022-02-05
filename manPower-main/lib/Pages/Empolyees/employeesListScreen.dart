import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:manpower/Global/theme.dart';
import 'package:manpower/Global/utils/helpers.dart';
import 'package:manpower/I10n/app_localizations.dart';
import 'package:manpower/Pages/client/myCVs.dart';
import 'package:manpower/models/AppInfo/Filters.dart' as filter;
import 'package:manpower/models/AppInfo/paymentData.dart';
import 'package:manpower/models/Companies/Employees.dart';
import 'package:manpower/services/OtherServices.dart/appDataService.dart';
import 'package:manpower/services/workersService.dart';
import 'package:manpower/widgets/Employees/employeesListCard.dart';
import 'package:manpower/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeesScreen extends StatefulWidget {
  final String? id;
  EmployeesScreen({this.id});

  @override
  _EmployeesScreenState createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  bool isLoading = true;
  bool loadingMoreData = false;
  bool isExpand = false;
   late filter.FiltersData data;
  List<Employees> workers = [];
  int page = 1;
  bool isEnd = false;
   filter.Occupation? selectedJob;
   filter.Religion? selectedReligon;
   filter.Status? selctedStatus;
   filter.Residence? selectedCity;
   filter.Nationality? selctedNationality;
   late PaymentData payment;

  getData() async {
    payment = await AppDataService().getPaymentData();
    data = await AppDataService().getFilters();
    workers = await WorkerService().getWorker(
        id: widget.id??"",
        page: page,
        occupationId: selectedJob?.occupationId ?? "",
        residenceId: selectedCity?.residenceId ?? "",
        religionId: selectedReligon?.religionId ?? "",
        nationalityId: selctedNationality?.nationalityId ?? "",
        statusId: selctedStatus?.statusId ?? "");
    isLoading = false;
    setState(() {});
  }

  getWorkers() async {
    if (!isEnd) {
      setState(() {
        loadingMoreData = true;
      });
      List<Employees> list = await WorkerService().getWorker(
          id: widget.id??"",
          page: page,
          occupationId: selectedJob?.occupationId ?? "",
          residenceId: selectedCity?.residenceId ?? "",
          religionId: selectedReligon?.religionId ?? "",
          nationalityId: selctedNationality?.nationalityId ?? "",
          statusId: selctedStatus?.statusId ?? "");
      workers.addAll(list);
      isEnd = list.isEmpty;
      loadingMoreData=false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  requestCv(id) async {
    bool result = await WorkerService().viewCv(id: id);
    isLoading = false;
    setState(() {});
    if (result) {
      pushPage(context, MyCvsScreen());
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString("id") ?? "";
      launchURL(
          "http://manpower-kw.com/api/pay?client_id=$userId&worker_id=$id");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/icon/logoAppBar.png",
                scale: 4.5, fit: BoxFit.scaleDown)),
      ),
      body: isLoading
          ? Loader()
          : LazyLoadScrollView(
              scrollOffset: 300,
              onEndOfPage: () {
                if (!isEnd) {
                  page++;
                  print(page);
                  getWorkers();
                }
              },
              child: ListView(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ExpansionTile(
                              collapsedBackgroundColor: mainOrangeColor,
                              initiallyExpanded: isExpand,
                              onExpansionChanged: (value) {
                                setState(() {
                                  isExpand = value;
                                });
                              },
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color:
                                        isExpand ? mainBlueColor : Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)
                                        ?.translate('searchEmployee')??"",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: isExpand
                                            ? mainBlueColor
                                            : Colors.white),
                                  ),
                                ],
                              ),
                              children: [
                                Container(
                                  height: 40,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3.5),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(
                                      color: mainBlueColor,
                                    ),
                                  ),
                                  child: Container(
                                    child: DropdownButton<filter.Occupation>(
                                      isExpanded: true,
                                      isDense: true,
                                      hint: Text(
                                          selectedJob == null
                                              ? AppLocalizations.of(context)
                                                  ?.translate('job')??""
                                              : selectedJob!.occupationName??"",
                                          style: TextStyle(
                                            fontSize: 13,
                                          )),
                                      underline: SizedBox(),
                                      items: data.occupation!
                                          .map<
                                              DropdownMenuItem<
                                                  filter.Occupation>>((value) =>
                                              new DropdownMenuItem<
                                                  filter.Occupation>(
                                                value: value,
                                                child: new Text(
                                                    Localizations.localeOf(
                                                                    context)
                                                                .languageCode ==
                                                            "en"
                                                        ? value.occupationNameEn??""
                                                        : value.occupationName??"",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                    )),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        isLoading = true;
                                        setState(() {});
                                        selectedJob = value;
                                        getData();
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 40,
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
                                  child: DropdownButton<filter.Religion>(
                                    isDense: true,
                                    isExpanded: true,
                                    hint: Text(
                                        selectedReligon == null
                                            ? AppLocalizations.of(context)
                                                ?.translate('religion')??""
                                            : selectedReligon!.religionName??"",
                                        style: TextStyle(
                                          fontSize: 13,
                                        )),
                                    underline: SizedBox(),
                                    items: data.religion!
                                        .map<DropdownMenuItem<filter.Religion>>(
                                            (value) => new DropdownMenuItem<
                                                    filter.Religion>(
                                                  value: value,
                                                  child: new Text(
                                                      Localizations.localeOf(
                                                                      context)
                                                                  .languageCode ==
                                                              "en"
                                                          ? value.religionNameEn??""
                                                          : value.religionName??"",
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                      )),
                                                ))
                                        .toList(),
                                    onChanged: (value) {
                                      isLoading = true;
                                      setState(() {});
                                      selectedReligon = value;
                                      getData();
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                    height: 40,
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
                                    child: DropdownButton<filter.Status>(
                                      isDense: true,
                                      isExpanded: true,
                                      hint: Text(
                                          selctedStatus == null
                                              ? AppLocalizations.of(context)
                                                  ?.translate('socialStatus')??""
                                              : selctedStatus!.statusName??"",
                                          style: TextStyle(
                                            fontSize: 13,
                                          )),
                                      underline: SizedBox(),
                                      items: data.status!
                                          .map<DropdownMenuItem<filter.Status>>(
                                              (value) => new DropdownMenuItem<
                                                      filter.Status>(
                                                    value: value,
                                                    child: new Text(
                                                        Localizations.localeOf(
                                                                        context)
                                                                    .languageCode ==
                                                                "en"
                                                            ? value.statusNameEn??""
                                                            : value.statusName??"",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                        )),
                                                  ))
                                          .toList(),
                                      onChanged: (value) {
                                        isLoading = true;
                                        setState(() {});
                                        selctedStatus = value;
                                        getData();
                                      },
                                    )),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 40,
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
                                  child: DropdownButton<filter.Residence>(
                                    isDense: true,
                                    isExpanded: true,
                                    hint: Text(
                                        selectedCity == null
                                            ? AppLocalizations.of(context)
                                                ?.translate('city')??""
                                            : selectedCity!.residenceName??"",
                                        style: TextStyle(
                                          fontSize: 13,
                                        )),
                                    underline: SizedBox(),
                                    items: data.residence!
                                        .map<
                                            DropdownMenuItem<
                                                filter.Residence>>((value) =>
                                            new DropdownMenuItem<
                                                filter.Residence>(
                                              value: value,
                                              child: new Text(
                                                  Localizations.localeOf(
                                                                  context)
                                                              .languageCode ==
                                                          "en"
                                                      ? value.residenceNameEn??""
                                                      : value.residenceName??"",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                  )),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      selectedCity = value;
                                      isLoading = true;
                                      setState(() {});
                                      getData();
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 40,
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
                                  child: DropdownButton<filter.Nationality>(
                                    isDense: true,
                                    isExpanded: true,
                                    hint: Text(
                                        selctedNationality == null
                                            ? AppLocalizations.of(context)
                                                ?.translate('nationality')??""
                                            : selctedNationality!
                                                .nationalityName??"",
                                        style: TextStyle(
                                          fontSize: 13,
                                        )),
                                    underline: SizedBox(),
                                    items: data.nationality!
                                        .map<
                                            DropdownMenuItem<
                                                filter.Nationality>>((value) =>
                                            new DropdownMenuItem<
                                                filter.Nationality>(
                                              value: value,
                                              child: new Text(
                                                  Localizations.localeOf(
                                                                  context)
                                                              .languageCode ==
                                                          "en"
                                                      ? value.nationalityNameEn??""
                                                      : value.nationalityName??"",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                  )),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      selctedNationality = value;
                                      isLoading = true;
                                      setState(() {});
                                      getData();
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ]),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ListView.builder(
                      itemCount: loadingMoreData?workers.length+1:workers.length,
                      itemBuilder: (BuildContext context, int index) {

                        return  loadingMoreData&&index==workers.length?Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.22,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Center(
                            child: Row(
                              mainAxisAlignment:MainAxisAlignment.center,
                              children: [
                                Text(Localizations.localeOf(context).languageCode == "en" ?"Loading":"جاري التحميل"),
                                SizedBox(width: 10,),
                                CircularProgressIndicator()

                              ],
                            ),
                          ),
                        ):Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: EmployeesCards(
                              amount: "${payment.viewConatcts}",
                              data: workers[index],
                              name: Localizations.localeOf(context)
                                          .languageCode ==
                                      "en"
                                  ? workers[index].nameEn ?? ""
                                  : workers[index].nameAr ?? "",
                              img: "${workers[index].image1 ?? ""}",
                              phone: "${workers[index].mobile}",
                              job: Localizations.localeOf(context)
                                          .languageCode ==
                                      "en"
                                  ? "${workers[index].occupation?.titleEn ?? ""}"
                                  : "${workers[index].occupation?.titleAr ?? ""}",
                              country: Localizations.localeOf(context)
                                          .languageCode ==
                                      "en"
                                  ? "${workers[index].residence?.titleEn ?? ""}"
                                  : "${workers[index].residence?.titleAr ?? ""}",
                              onagree: () {
                                isLoading = true;
                                setState(() {});
                                requestCv("${workers[index].workerId}");
                              }),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
