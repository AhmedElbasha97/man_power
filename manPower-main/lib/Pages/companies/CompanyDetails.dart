import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:manpower/Global/theme.dart';
import 'package:manpower/Global/utils/helpers.dart';
import 'package:manpower/models/Companies/Employees.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:manpower/models/Companies/company.dart';
import 'package:manpower/services/Companies/CompaniesService.dart';
import 'package:manpower/services/OtherServices.dart/appDataService.dart';
import 'package:manpower/widgets/Employees/employeesListCard.dart';
import 'package:manpower/I10n/app_localizations.dart';
import 'package:manpower/models/AppInfo/Filters.dart' as filter;

import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;
  final List subCategory;
  String lang;
  String? map;
  String? rating;
  String? ratingNo;
  String address;
  String? details;
  List<String?> slider = [];
  Clicks clicks;
  CompanyDetailsScreen(
      this.categoryId,
      this.categoryName,
      this.subCategory,
      this.slider,
      this.lang,
      this.clicks,
      this.rating,
      this.ratingNo,
      this.map,
      this.address,
      this.details);

  @override
  _CompanyDetailsScreenState createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen>
    with SingleTickerProviderStateMixin {
   List? imgList;
   List<Widget?>? child;
  int _current = 0;
   bool? isAllCheck;
  bool isLoading = true;
  bool isLoadingMoreData = false;
  bool isLoadingAllData = false;
   ScrollController? _loadMoreDataController;
  int apiPage = 1;
  int myRating = 0;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  bool searchFound = false;

   TabController? tabController;
   GoogleMapController? _controller;

  bool isExpand = false;
   filter.Occupation? selectedJob;
   filter.Religion? selectedReligon;
   filter.Status? selctedStatus;
   filter.Residence? selectedCity;
   filter.Nationality? selctedNationality;

   late filter.FiltersData data;

  List<Employees> employees = [];

    List<Widget> tabsList=[];
   String? golabalSubCategory;

  @override
  void initState() {
    super.initState();
    tabController =
        TabController(length: (widget.subCategory.length + 1), vsync: this);
    _loadMoreDataController = new ScrollController();
    getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          title: Text(
            "${widget.categoryName}",
            style: TextStyle(color: Color(0xFF0671bf)),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF0671bf),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : GestureDetector(
                onTap: () => searchFocusNode.unfocus(),
                child: SingleChildScrollView(
                  controller: _loadMoreDataController,
                  child: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                      child != null && child!.isNotEmpty
                          ? CarouselSlider.builder(
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
                                    _current = index;
                                  });
                                },
                              ),
                            )
                          : Container(),
                      DefaultTabController(
                        length: tabsList.length,
                        child: PreferredSize(
                          preferredSize: Size(MediaQuery.of(context).size.width,
                              MediaQuery.of(context).size.height * 0.15),
                          child: TabBar(
                            isScrollable: true,
                            labelColor: Colors.blue,
                            unselectedLabelColor: Color(0xFF0671bf),
                            controller: tabController,
                            tabs: tabsList,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey[300],
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: Image.asset(
                                "assets/icon/callUs.png",
                                scale: 10,
                              ),
                              onPressed: () => filterDialog(),
                            ),
                            IconButton(
                              icon: Image.asset(
                                "assets/icon/map.png",
                                scale: 13,
                              ),
                              onPressed: () => gMap(),
                            ),
                            IconButton(
                              icon: Icon(Icons.info),
                              onPressed: () => detailsDialog(),
                            ),
                            IconButton(
                              icon: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: mainOrangeColor,
                                  ),
                                  Text(
                                      "${widget.rating == 'null' ? 0 : widget.rating} (${widget.ratingNo ?? 0})")
                                ],
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => RatingDialog(
                                    initialRating: myRating.toDouble(),
                                    title: Text(''),
                                    message: Text(''),
                                    image: Container(),
                                    submitButtonText: 'send',
                                    onCancelled: () => print('cancelled'),
                                    onSubmitted: (response) async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      String? id = prefs.getString("id");
                                      String? type = prefs.getString("type");
                                      if (type == "client") {
                                        widget.rating = "${response.rating}";
                                        setState(() {});
                                        AppDataService().sendRating(
                                            widget.categoryId,
                                            id,
                                            "${response.rating}");
                                      } else {
                                        showTheDialog(
                                            context,
                                            "",
                                            AppLocalizations.of(context)
                                                ?.translate('cantRate')??"");
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      employees.isEmpty
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    ExpansionTile(
                                        collapsedBackgroundColor:
                                            mainOrangeColor,
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
                                              color: isExpand
                                                  ? mainBlueColor
                                                  : Colors.white,
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
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3.5),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              border: Border.all(
                                                color: mainBlueColor,
                                              ),
                                            ),
                                            child: Container(
                                              child: DropdownButton<
                                                  filter.Occupation>(
                                                isExpanded: true,
                                                isDense: true,
                                                hint: Text(
                                                    selectedJob == null ? AppLocalizations.of(context)?.translate('job')??"" : selectedJob!.occupationName??"",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                    )),
                                                underline: SizedBox(),
                                                items: data.occupation!
                                                    .map<
                                                            DropdownMenuItem<
                                                                filter
                                                                    .Occupation>>(
                                                        (value) =>
                                                            new DropdownMenuItem<
                                                                filter
                                                                    .Occupation>(
                                                              value: value,
                                                              child: new Text(
                                                                  Localizations.localeOf(context)
                                                                              .languageCode ==
                                                                          "en"
                                                                      ? value
                                                                          .occupationNameEn??""
                                                                      : value
                                                                          .occupationName??"",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                  )),
                                                            ))
                                                    .toList(),
                                                onChanged: (value) async {
                                                  isLoading = true;
                                                  setState(() {});
                                                  selectedJob = value;
                                                  await getData();
                                                  isLoading = false;
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3.5),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              border: Border.all(
                                                color: mainBlueColor,
                                              ),
                                            ),
                                            child:
                                                DropdownButton<filter.Religion>(
                                              isDense: true,
                                              isExpanded: true,
                                              hint: Text(
                                                  selectedReligon == null
                                                      ? AppLocalizations.of(
                                                              context)
                                                          ?.translate('religion')??""
                                                      : selectedReligon!
                                                          .religionName??"",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                  )),
                                              underline: SizedBox(),
                                              items: data.religion!
                                                  .map<
                                                          DropdownMenuItem<
                                                              filter.Religion>>(
                                                      (value) =>
                                                          new DropdownMenuItem<
                                                              filter.Religion>(
                                                            value: value,
                                                            child: new Text(
                                                                Localizations.localeOf(context)
                                                                            .languageCode ==
                                                                        "en"
                                                                    ? value
                                                                        .religionNameEn??""
                                                                    : value
                                                                        .religionName??"",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                )),
                                                          ))
                                                  .toList(),
                                              onChanged: (value) async {
                                                isLoading = true;
                                                setState(() {});
                                                selectedReligon = value;
                                                await getData();
                                                isLoading = false;
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 3.5),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                border: Border.all(
                                                  color: mainBlueColor,
                                                ),
                                              ),
                                              child:
                                                  DropdownButton<filter.Status>(
                                                isDense: true,
                                                isExpanded: true,
                                                hint: Text(
                                                    selctedStatus == null
                                                        ? AppLocalizations.of(
                                                                context)
                                                            ?.translate(
                                                                'socialStatus')??""
                                                        : selctedStatus!
                                                            .statusName??"",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                    )),
                                                underline: SizedBox(),
                                                items: data.status!
                                                    .map<
                                                            DropdownMenuItem<
                                                                filter.Status>>(
                                                        (value) =>
                                                            new DropdownMenuItem<
                                                                filter.Status>(
                                                              value: value,
                                                              child: new Text(
                                                                  Localizations.localeOf(context)
                                                                              .languageCode ==
                                                                          "en"
                                                                      ? value
                                                                          .statusNameEn??""
                                                                      : value
                                                                          .statusName??"",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                  )),
                                                            ))
                                                    .toList(),
                                                onChanged: (value) async {
                                                  isLoading = true;
                                                  setState(() {});
                                                  selctedStatus = value;
                                                  await getData();
                                                  isLoading = false;
                                                  setState(() {});
                                                },
                                              )),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3.5),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              border: Border.all(
                                                color: mainBlueColor,
                                              ),
                                            ),
                                            child: DropdownButton<
                                                filter.Residence>(
                                              isDense: true,
                                              isExpanded: true,
                                              hint: Text(
                                                  selectedCity == null
                                                      ? AppLocalizations.of(
                                                              context)
                                                          ?.translate('city')??""
                                                      : selectedCity!
                                                          .residenceName??"",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                  )),
                                              underline: SizedBox(),
                                              items: data.residence!
                                                  .map<
                                                          DropdownMenuItem<
                                                              filter
                                                                  .Residence>>(
                                                      (value) =>
                                                          new DropdownMenuItem<
                                                              filter.Residence>(
                                                            value: value,
                                                            child: new Text(
                                                                Localizations.localeOf(context)
                                                                            .languageCode ==
                                                                        "en"
                                                                    ? value
                                                                        .residenceNameEn??""
                                                                    : value
                                                                        .residenceName??"",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                )),
                                                          ))
                                                  .toList(),
                                              onChanged: (value) async {
                                                selectedCity = value;
                                                isLoading = true;
                                                setState(() {});
                                                await getData();
                                                isLoading = false;
                                                setState(() {});
                                                getData();
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3.5),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              border: Border.all(
                                                color: mainBlueColor,
                                              ),
                                            ),
                                            child: DropdownButton<
                                                filter.Nationality>(
                                              isDense: true,
                                              isExpanded: true,
                                              hint: Text(
                                                  selctedNationality == null
                                                      ? AppLocalizations.of(
                                                              context)
                                                          ?.translate(
                                                              'nationality')??""
                                                      : selctedNationality!
                                                          .nationalityName??"",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                  )),
                                              underline: SizedBox(),
                                              items: data.nationality!
                                                  .map<
                                                          DropdownMenuItem<
                                                              filter
                                                                  .Nationality>>(
                                                      (value) =>
                                                          new DropdownMenuItem<
                                                              filter
                                                                  .Nationality>(
                                                            value: value,
                                                            child: new Text(
                                                                Localizations.localeOf(context)
                                                                            .languageCode ==
                                                                        "en"
                                                                    ? value
                                                                        .nationalityNameEn??""
                                                                    : value
                                                                        .nationalityName??"",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                )),
                                                          ))
                                                  .toList(),
                                              onChanged: (value) async {
                                                selctedNationality = value;
                                                isLoading = true;
                                                setState(() {});
                                                await getData();
                                                isLoading = false;
                                                setState(() {});
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
                      isLoadingAllData
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .padding
                                                  .top +
                                              50)),
                                  Text(
                                    "???????? ??????????????",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 30)),
                                  CircularProgressIndicator(),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .padding
                                                  .top +
                                              50)),
                                ],
                              ),
                            )
                          : employees.isEmpty
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${widget.details ?? ""}",
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${widget.address}",
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        child: widget.map == "null" ||
                                                widget.map == ""
                                            ? Center(
                                                child: Text(
                                                    "???? ???????? ???????? ???????? ????????"),
                                              )
                                            : GoogleMap(
                                                initialCameraPosition:
                                                    CameraPosition(
                                                  target: widget.map ==
                                                              "null" ||
                                                          widget.map == ""
                                                      ? LatLng(0, 0)
                                                      : LatLng(
                                                          double.parse(widget
                                                              .map!
                                                              .split(",")[0]),
                                                          double.parse(widget
                                                              .map!
                                                              .split(",")[1])),
                                                  zoom: 19.151926040649414,
                                                ),
                                                onMapCreated:
                                                    (GoogleMapController
                                                        controller) {
                                                  _controller = controller;
                                                  setState(() {});
                                                },
                                                markers: {
                                                  Marker(
                                                    // This marker id can be anything that uniquely identifies each marker.
                                                    markerId: MarkerId(
                                                        "currentState"),
                                                    position: widget.map ==
                                                                "null" ||
                                                            widget.map == ""
                                                        ? LatLng(0, 0)
                                                        : LatLng(
                                                            double.parse(widget
                                                                .map!
                                                                .split(",")[0]),
                                                            double.parse(widget
                                                                .map!
                                                                .split(
                                                                    ",")[1])),
                                                    infoWindow: InfoWindow(
                                                      // title is the address
                                                      title:
                                                          "${widget.categoryName}",
                                                      // snippet are the coordinates of the position
                                                      snippet:
                                                          '${widget.categoryName}',
                                                    ),
                                                    icon: BitmapDescriptor
                                                        .defaultMarker,
                                                  )
                                                },
                                                liteModeEnabled: true,
                                              )),
                                  ],
                                )
                              : ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: employees.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: EmployeesCards(
                                        isCompanyProfile: true,
                                        isCV: false,
                                        data: employees[index],
                                        name: employees[index].nameAr,
                                        whatsApp: employees[index].whatsapp,
                                        img: employees[index].image1,
                                        phone: employees[index].mobile,
                                        country: employees[index]
                                            .nationality!
                                            .titleAr,
                                        job:
                                            employees[index].occupation!.titleAr,
                                      ),
                                    );
                                  },
                                )
                    ],
                  ),
                ),
              ));
  }

  getAllData() async {
    await initListOfTabs();
    await getData();
    await getFilters();
    photoSlider();
    isLoading = false;
    setState(() {});
  }

  getData() async {
    employees = await CompaniesService().getEmployees(widget.categoryId,
        job: selectedJob?.occupationId ?? "",
        city: selectedCity?.residenceId ?? "",
        religion: selectedReligon?.religionId ?? "",
        nationality: selctedNationality?.nationalityId ?? "",
        status: selctedStatus?.statusId ?? "");
  }

  getFilters() async {
    data = await AppDataService().getFilters();
  }

  photoSlider() async {
    child = map<Widget>(
      widget.slider,
      (index, i) {
        return Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: CachedNetworkImage(
              imageUrl: i,
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
  }

  Future<void> gMap() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return StatefulBuilder(builder: (context, StateSetter setState) {
              return Dialog(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: widget.map == "null" || widget.map == ""
                        ? Center(
                            child: Text("???? ???????? ???????? ???????? ????????"),
                          )
                        : GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: widget.map == "null" || widget.map == ""
                                  ? LatLng(0, 0)
                                  : LatLng(
                                      double.parse(widget.map!.split(",")[0]),
                                      double.parse(widget.map!.split(",")[1])),
                              zoom: 19.151926040649414,
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              _controller = controller;
                              setState(() {});
                            },
                            markers: {
                              Marker(
                                // This marker id can be anything that uniquely identifies each marker.
                                markerId: MarkerId("currentState"),
                                position: widget.map == "null" ||
                                        widget.map == ""
                                    ? LatLng(0, 0)
                                    : LatLng(
                                        double.parse(widget.map!.split(",")[0]),
                                        double.parse(widget.map!.split(",")[1])),
                                infoWindow: InfoWindow(
                                  // title is the address
                                  title: "${widget.categoryName}",
                                  // snippet are the coordinates of the position
                                  snippet: '${widget.categoryName}',
                                ),
                                icon: BitmapDescriptor.defaultMarker,
                              )
                            },
                            liteModeEnabled: true,
                          )),
              );
            });
          },
        );
      },
    );
  }

  Future<void> filterDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 15)),
                      Text(
                        "${widget.categoryName}",
                        style: TextStyle(
                          color: Color(0xFF0671bf),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/icon/whatsappBar.jpg",
                                scale: 2),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "whatsapp",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF34bc48)),
                                    ),
                                    Text("${widget.clicks.whatsapp}",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey))
                                  ],
                                ),
                                Image.asset(
                                  "assets/icon/whatsappIcon.gif",
                                  scale: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/icon/messageBar.gif", scale: 2),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "chat with us",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF79002d)),
                                    ),
                                    Text("${widget.clicks.chat}",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey))
                                  ],
                                ),
                                Image.asset(
                                  "assets/icon/messageIcon.gif",
                                  scale: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/icon/dialerBar.gif", scale: 2),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "call us",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF008000)),
                                    ),
                                    Text("${widget.clicks.mobile}",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey))
                                  ],
                                ),
                                Image.asset(
                                  "assets/icon/dialerIcon.gif",
                                  scale: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/icon/facebookBar.gif",
                                scale: 2),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "facebook",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF3f5ca4)),
                                    ),
                                    Text("${widget.clicks.facebook ?? 0}",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey))
                                  ],
                                ),
                                Image.asset(
                                  "assets/icon/facebookIcon.gif",
                                  scale: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/icon/youtubeBar.gif", scale: 2),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "youtube",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFFcb0f0f)),
                                    ),
                                    Text("${widget.clicks.youtube ?? 0}",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey))
                                  ],
                                ),
                                Image.asset(
                                  "assets/icon/youtubeIcon.gif",
                                  scale: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/icon/twitterBar.jpg", scale: 2),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "twitter",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF82c9f9)),
                                    ),
                                    Text("${widget.clicks.twitter ?? 0}",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey))
                                  ],
                                ),
                                Image.asset(
                                  "assets/icon/twitterIcon.gif",
                                  scale: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/icon/instagramBar.gif",
                                scale: 2),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "instagram",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFFf2785e)),
                                    ),
                                    Text("${widget.clicks.instagram ?? 0}",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey))
                                  ],
                                ),
                                Image.asset(
                                  "assets/icon/instagramIcon.gif",
                                  scale: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 100,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: Color(0xFF0671bf)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "????????",
                            style: TextStyle(color: Color(0xFF0671bf)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> detailsDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 15)),
                      Text(
                        "${widget.categoryName}",
                        style: TextStyle(
                          color: Color(0xFF0671bf),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${widget.details ?? ""}"),
                      ),
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 100,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: Color(0xFF0671bf)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "????????",
                            style: TextStyle(color: Color(0xFF0671bf)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  initListOfTabs() {
    tabsList.add(InkWell(
      onTap: () async {
        tabController!.animateTo(0);
        apiPage = 1;
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFF0671bf),
            child: Icon(
              Icons.category,
              color: Colors.white,
            ),
          ),
          Text(
            "${widget.lang == "en" ? "all categories" : "???? ??????????????"}",
            style: TextStyle(fontSize: 14),
          )
        ],
      ),
    ));

    for (int i = 0; i < widget.subCategory.length; i++) {
      tabsList.add(InkWell(
        onTap: () async {
          tabController!.animateTo(i + 1);
          apiPage = 1;
          golabalSubCategory = widget.subCategory[i].id;
        },
        child: Column(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage("${widget.subCategory[i].image}"),
            ),
            Text(
              "${widget.lang == "en" ? widget.subCategory[i].titleEn : widget.subCategory[i].titleAr}",
              style: TextStyle(fontSize: 14),
            )
          ],
        ),
      ));
    }
  }
}
