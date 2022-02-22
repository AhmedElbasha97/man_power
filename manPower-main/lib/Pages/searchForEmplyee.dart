import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:manpower/Global/utils/helpers.dart';
import 'package:manpower/Global/widgets/MainDrawer.dart';
import 'package:manpower/models/AppInfo/homeSilder.dart';
import 'package:manpower/models/Companies/Categories.dart';
import 'package:manpower/models/workers/workersCategories.dart';
import 'package:manpower/services/Companies/CompaniesService.dart';
import 'package:manpower/services/OtherServices.dart/appDataService.dart';
import 'package:manpower/services/workersService.dart';
import 'package:manpower/widgets/Companies/companyCategoryCard.dart';
import 'package:manpower/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/notification/notification_services.dart';

class SearchForEmployee extends StatefulWidget {
  @override
  _SearchForEmployeeState createState() => _SearchForEmployeeState();
}

class _SearchForEmployeeState extends State<SearchForEmployee> {
   List<Widget?>? child;
   List? photoSliderList;
   final CarouselController _controller = CarouselController();
  bool isLoading = true;
  List<Categories> categories = [];
  List<WorkersCategory> workercategories = [];

  List<HomeSlider> imgList = [];
   String? type;
   String? id;

  getPhotoSlider() async {
    imgList = await AppDataService().getSliderPhotos();
  }

  getCategories() async {
    categories = await CompaniesService().getCategories();
    workercategories = await WorkerService().getCategories();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    type = prefs.getString("type");
    id = prefs.getString("id");
  }

  photoSlider() async {
    await getPhotoSlider();
    await getCategories();
    child = map<Widget>(
      imgList,
      (index, i) {
        return Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: CachedNetworkImage(
              imageUrl: i.picpath,
              fit: BoxFit.cover,
              width: 1000.0,
              placeholder: (context, url) => SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        );
      },
    ).toList();
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    NotificationServices.checkNotificationAppInForeground(context);

    photoSlider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: isLoading ? Loader() : MainDrawer(id, type),
      appBar: AppBar(
          centerTitle: true,
          title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/icon/logoAppBar.png",
                  scale: 4, fit: BoxFit.scaleDown))),
      body: isLoading
          ? Loader()
          : ListView(
              children: [
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                CarouselSlider.builder(
                  carouselController: _controller,
                  itemCount: child!.length,
                  itemBuilder: (BuildContext context, int index, int realIndex) {
                    return child![index]!;
                  },
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 2.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                      });
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70 * (categories.length).toDouble(),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    primary: false,
                    itemCount: categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CompanyCategoryCard(
                        id: categories[index].categoryId??"",
                        name:
                            Localizations.localeOf(context).languageCode == "en"
                                ? categories[index].categoryNameEn??""
                                : categories[index].categoryName??"",
                        isSpecial: true,
                      );
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70 * (workercategories.length).toDouble(),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    primary: false,
                    itemCount: workercategories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CompanyCategoryCard(
                        id: workercategories[index].categoryWorkerId??"",
                        name:
                            Localizations.localeOf(context).languageCode == "en"
                                ? workercategories[index].categoryWorkerNameEn??""
                                : workercategories[index].categoryWorkerName??"",
                        isSpecial: false,
                      );
                    },
                  ),
                ),
                SizedBox(height: 25)
              ],
            ),
    );
  }
}
