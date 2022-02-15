import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:manpower/Global/theme.dart';
import 'package:manpower/Global/utils/helpers.dart';
import 'package:manpower/Global/widgets/MainDrawer.dart';
import 'package:manpower/I10n/AppLanguage.dart';
import 'package:manpower/I10n/app_localizations.dart';
import 'package:manpower/Pages/companies/CompanyDetails.dart';
import 'package:manpower/models/AppInfo/homeSilder.dart';
import 'package:manpower/models/Companies/Employees.dart';
import 'package:manpower/models/Companies/company.dart';
import 'package:manpower/services/Companies/CompaniesService.dart';
import 'package:manpower/services/OtherServices.dart/appDataService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manpower/services/workersService.dart';
import 'package:manpower/widgets/Employees/employeesListCard.dart';
import 'package:manpower/widgets/home_card.dart';
import 'package:manpower/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final String categoryId;
  HomeScreen({this.categoryId = "1"});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  bool isSearching = false;
 bool loadingMoreData = false;
  bool isLoadingMoreData = false;
  bool isSearchActive = false;
  bool errorSearch = false;
  bool more = false;
  List<String> filtersValue =["low_rate","high_rate"];
  List<String> filtersTitlesEn =["from High Rating To Low Rating","From Low Rating To High Rating"];
  List<String> filtersTitlesAR =["الترتيب من الاكثر تقيما إلى الاقل تقيما","الترتيب من الأقل تقيما إلى الاكثر تقيما"];

  bool isCategoryOn = true;
  bool isLoadingProducts = false;
  final CarouselController _controller = CarouselController();

  int _current = 0;
  int apiPage = 1;
  int totalProductsInCart = 0;
 String selectedFilter="";
  List<HomeSlider> imgList = [];
   List<Widget?>? child;
   List? photoSliderList;
  List<Company> companies = [];
  List<Employees> cvs = [];

   String? name;
   String? token;
   String? id;
   String? type;

  TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();

  Widget changeLangPopUp(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return CupertinoActionSheet(
      title: new Text('${AppLocalizations.of(context)?.translate('language')}'),
      message: new Text(
          '${AppLocalizations.of(context)?.translate('changeLanguage')}'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: new Text('English'),
          onPressed: () {
            appLanguage.changeLanguage(Locale("en"));
            Navigator.pop(context);
          },
        ),
        CupertinoActionSheetAction(
          child: new Text('عربى'),
          onPressed: () {
            appLanguage.changeLanguage(Locale("ar"));
            Navigator.pop(context);
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: new Text('رجوع'),
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context, 'Cancel');
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  getCv() async {
    cvs.addAll(await WorkerService()
        .getWorkerByCompanyCat(id: widget.categoryId, page: apiPage));
    isLoadingProducts = false;
    apiPage++;
    setState(() {});
  }

  getPhotoSlider() async {
    imgList = await AppDataService().getSliderPhotos();

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

              errorWidget: (context, url, error) =>SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.1,
                 child: Image.asset("assets/icon/companyplaceholder.png"),
              ),
            ),
          ),
        );
      },
    ).toList();
    setState(() {});
  }

  getCompnaies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    type = prefs.getString("type");
    id = prefs.getString("id");


    if (more) {
      setState(() {
        loadingMoreData = true;
      });
      apiPage++;
      List<Company> newComs = await CompaniesService().getCompanies(
          widget.categoryId,
          page: apiPage,
          searchKey: searchController.text);
      companies.addAll(newComs);
      if (newComs.isEmpty) {
        more = false;
      }
      setState(() {
        loadingMoreData = false;
      });
    }else{
      companies = await CompaniesService().getCompanies(
          widget.categoryId,
          page: apiPage,
          searchKey: searchController.text);
    }
    isLoading = false;
    setState(() {});
  }

  getData() {
    getCompnaies();
    getPhotoSlider();
  }
  searchingForCompany() async {
    setState(() {
      isSearching=true;
    });
    print(searchController.text);
    companies = await CompaniesService().getCompanies(
        widget.categoryId,
        page: apiPage,
        searchKey: searchController.text);
    isSearching=false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(id, type),
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF0671bf),
        title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/icon/logoAppBar.png",
                scale: 4.5, fit: BoxFit.scaleDown)),
        actions: [
          isCategoryOn
              ? IconButton(
                  icon: Icon(
                    Icons.search,
                    color: isSearchActive ? Colors.blue : Colors.white,
                  ),
                  onPressed: () {
                    isSearchActive = !isSearchActive;
                    setState(() {});
                  },
                )
              : Container(),
        ],
        centerTitle: true,
      ),
      body: isLoading
          ? Loader()
          : LazyLoadScrollView(
              scrollOffset: 1000,
              onEndOfPage: () {
                if (isCategoryOn) {
                  print(apiPage);
                  more=true;
                  getCompnaies();
                } else {

                  print(apiPage);
                  getCv();
                }
              },
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[

                    isSearchActive
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextField(
                                controller: searchController,
                                focusNode: searchNode,
                                textInputAction: TextInputAction.search,
                                onSubmitted: (value) {
                                  searchNode.unfocus();
                                },
                                onChanged: (value) {
                                  if (value == "") {
                                    apiPage = 1;
                                    getCompnaies();
                                    setState(() {});
                                  }

                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide: BorderSide(
                                            color: Color(0xFF0671bf))),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide: BorderSide(
                                            color: Color(0xFF0671bf))),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide: BorderSide(
                                            color: Color(0xFF0671bf))),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide:
                                            BorderSide(color: Colors.blue)),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        searchNode.unfocus();
                                        apiPage = 1;
                                        companies.clear();
                                        searchingForCompany();
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.search,
                                        color: searchNode.hasFocus
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                    ),
                                    hintText: "search...",
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 1)),
                              ),
                            ))
                        : Container(),

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
                            _current = index;
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:<Widget>[
                        for(
                        var i=0;i<imgList.length;i++
                        )
                          Container (
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 5.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _current == i
                                    ? Color(0xFF0D986A)
                                    : Color(0xFFD8D8D8)),
                          )

                    ]),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                isCategoryOn = false;
                                isLoadingProducts = true;
                                apiPage = 1;
                                getCv();
                                setState(() {});
                              },
                              child: Container(
                                  color: isCategoryOn
                                      ? Colors.white
                                      : mainOrangeColor,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${AppLocalizations.of(context)?.translate('allCv')}",
                                    style: TextStyle(
                                        color: isCategoryOn
                                            ? Colors.grey[700]
                                            : Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                cvs.clear();
                                setState(() {
                                  isCategoryOn = true;
                                });
                              },
                              child: Container(
                                  color: isCategoryOn
                                      ? mainOrangeColor
                                      : Colors.white,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${AppLocalizations.of(context)?.translate('companies')}",
                                    style: TextStyle(
                                        color: isCategoryOn
                                            ? Colors.white
                                            : Colors.grey[700],
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    isCategoryOn
                        ?isSearching? Loader(width: MediaQuery.of(context).size.width ,
                      height: MediaQuery.of(context).size.height * 0.5,):ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: loadingMoreData?companies.length+1:companies.length,
                            itemBuilder: (context, index) {
                              return loadingMoreData&&index==companies.length?Container(
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
                              ):InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                        builder: (context) =>
                                        CompanyDetailsScreen(
                                              companies[index].social?.facebook,
                                          companies[index].social?.instagram,
                                          companies[index].companymobile,
                                          companies[index].social?.twitter,
                                          companies[index].whatsapp,
                                          companies[index].social?.youtube,
                                          companies[index].companyId,

                                          Localizations.localeOf(context)
                                                      .languageCode ==
                                                  "en"
                                              ? companies[index].companyName
                                              : companies[index].companyName,
                                          [],
                                          [
                                            companies[index].slider!.picpath,
                                            companies[index].slider!.picpath2,
                                            companies[index].slider!.picpath3
                                          ],
                                          Localizations.localeOf(context)
                                                      .languageCode ==
                                                  "en"
                                              ? "en"
                                              : "ar",
                                          companies[index].clicks??Clicks(facebook: "  ", youtube: "", instagram: "", chat: "", whatsapp: ""),
                                          companies[index].rating == "null"
                                              ? "0"
                                              : companies[index].rating,
                                          companies[index].ratingNo == "null"
                                              ? "0"
                                              : companies[index].ratingNo,
                                          companies[index].map,
                                          companies[index].address??"",
                                          companies[index].details,
                                        ),
                                      ))
                                      .whenComplete(() async {});
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 7),
                                  child: HomeCard(
                                    categoryId: companies[index].companyId,
                                    title: companies[index].companyName ?? "",
                                    image: companies[index].picpath,
                                    address: companies[index].address ?? "",
                                    facebookUrl:
                                        companies[index].social!.facebook ?? "",
                                    instagramUrl:
                                        companies[index].social!.instagram ?? "",
                                    twitterUrl:
                                        companies[index].social!.twitter ?? "",
                                    whatsappUrl:
                                        companies[index].companymobile ?? "",
                                    phone: companies[index].companymobile ?? "",
                                  ),
                                ),
                              );
                            },
                          )
                        : isLoadingProducts
                            ? Loader(width: MediaQuery.of(context).size.width ,
                      height: MediaQuery.of(context).size.height * 0.5,)
                            : ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: cvs.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: EmployeesCards(
                                      isCompanyProfile: true,
                                      isCV: false,
                                      data: cvs[index],
                                      name: cvs[index].nameAr,
                                      whatsApp: cvs[index].whatsapp,
                                      img: cvs[index].image1,
                                      phone: cvs[index].mobile,
                                      country: cvs[index].nationality?.titleAr??"",
                                      job: cvs[index].occupation?.titleAr??"", onagree: (){print("ho");}, amount: " ", cvId: "", onDelete: (){print("hi delete");},
                                    ),
                                  );
                                })
                  ],
                ),
              ),
            ),
    );
  }
}
