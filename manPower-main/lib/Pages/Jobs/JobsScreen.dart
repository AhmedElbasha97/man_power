import 'package:flutter/material.dart';
import 'package:manpower/Global/utils/helpers.dart';
import 'package:manpower/Pages/Jobs/jobdetails.dart';
import 'package:manpower/models/other/vacancy.dart';
import 'package:manpower/services/OtherServices.dart/jobsService.dart';

class JobsScreen extends StatefulWidget {
  @override
  _JobsScreenState createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  List<Vacancy> jobs = [];
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    getJobs();
  }

  getJobs() async {
    jobs = await JobsService().getJobs();
    isloading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/icon/logoAppBar.png",
                  scale: 4, fit: BoxFit.scaleDown))),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              itemCount: jobs.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    pushPage(
                        context,
                        JobsDetailsScreen(
                          job: jobs[index],
                        ));
                  },
                  child: Card(
                    child: Container(
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(jobs[index].title??"",style: TextStyle(fontSize: 19),),
                      )),
                  ),
                );
              },
            ),
    );
  }
}
