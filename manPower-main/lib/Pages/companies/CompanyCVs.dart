import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:manpower/models/Companies/Employees.dart';
import 'package:manpower/services/Companies/CompaniesService.dart';
import 'package:manpower/services/notification/notification_services.dart';
import 'package:manpower/widgets/Employees/employeesListCard.dart';
import 'package:manpower/widgets/loader.dart';

class CompanyCvScreen extends StatefulWidget {
  final String? id;
  CompanyCvScreen({this.id=""});
  @override
  _CompanyCvScreenState createState() => _CompanyCvScreenState();
}

class _CompanyCvScreenState extends State<CompanyCvScreen> {
  bool isLoading = true;
  bool isEnd = false;
  int page = 1;
  List<Employees> workers = [];
  getData() async {
    if (isEnd) {
      List<Employees> list =
          await CompaniesService().getCompanyCvs(id: widget.id, page: page);
      workers.addAll(list);
      isEnd = list.isEmpty;
      setState(() {});
    }
  }

  getCv() async {
    List<Employees> list =
        await CompaniesService().getCompanyCvs(id: widget.id, page: page);
    workers.addAll(list);
    isEnd = list.isEmpty;
    isLoading = false;
    setState(() {});
  }

  deleteCv(String? cvId) async {
    isLoading = true;
    setState(() {});
    await CompaniesService().deleteCv(id: widget.id, workerid: cvId);
    workers.clear();
    page = 1;
    getCv();
  }

  @override
  void initState() {
    super.initState();
    NotificationServices.checkNotificationAppInForeground(context);

    getCv();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LazyLoadScrollView(
        onEndOfPage: () {
          if (isEnd) {
            page++;
            getData();
          }
        },
        child: isLoading
            ? Loader()
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: workers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: EmployeesCards(
                        data: workers[index],
                        name:
                            Localizations.localeOf(context).languageCode == "en"
                                ? workers[index].nameEn ?? ""
                                : workers[index].nameAr ?? "",
                        img: "${workers[index].image1 ?? ""}",
                        phone: "${workers[index].mobile ?? ""}",
                        job:
                            Localizations.localeOf(context).languageCode == "en"
                                ? "${workers[index].occupation?.titleEn}"
                                : "${workers[index].occupation?.titleAr}",
                        country:
                            Localizations.localeOf(context).languageCode == "en"
                                ? "${workers[index].residence?.titleEn ?? ""}"
                                : "${workers[index].residence?.titleAr ?? ""}",
                        isCompany: true,
                        onDelete: () {
                          deleteCv(workers[index].workerId);
                        },
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
