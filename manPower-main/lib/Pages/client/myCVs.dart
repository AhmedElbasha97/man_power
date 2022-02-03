import 'package:flutter/material.dart';
import 'package:manpower/models/Companies/Employees.dart';
import 'package:manpower/services/workersService.dart';
import 'package:manpower/widgets/Employees/employeesListCard.dart';
import 'package:manpower/widgets/loader.dart';

class MyCvsScreen extends StatefulWidget {
  @override
  _MyCvsScreenState createState() => _MyCvsScreenState();
}

class _MyCvsScreenState extends State<MyCvsScreen> {
  bool isLoading = true;
  List<Employees> workers = [];
  getMyCv() async {
    workers = await WorkerService().getPaidWorker();
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getMyCv();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: isLoading
            ? Loader()
            : ListView.builder(
                padding: EdgeInsets.all(5),
                itemCount: workers.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: EmployeesCards(
                      name: Localizations.localeOf(context).languageCode == "en"
                          ? workers[index].nameEn ?? ""
                          : workers[index].nameAr ?? "",
                      img: "${workers[index].image1 ?? ""}",
                      phone: "${workers[index].mobile}",
                      job: Localizations.localeOf(context).languageCode == "en"
                          ? "${workers[index].occupation?.titleEn ?? ""}"
                          : "${workers[index].occupation?.titleAr ?? ""}",
                      country:
                          Localizations.localeOf(context).languageCode == "en"
                              ? "${workers[index].residence?.titleEn ?? ""}"
                              : "${workers[index].residence?.titleAr ?? ""}",
                    ),
                  );
                },
              ));
  }
}
