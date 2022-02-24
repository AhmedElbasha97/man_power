import 'package:flutter/material.dart';
import 'package:manpower/Pages/Notification/widget/notifiction_cell.dart';
import 'package:manpower/models/other/notification_model.dart';
import 'package:manpower/services/notification/notification_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Global/theme.dart';
import '../../widgets/loader.dart';
class NotificationsListScreen extends StatefulWidget {
  const NotificationsListScreen({Key? key}) : super(key: key);

  @override
  _NotificationsListScreenState createState() => _NotificationsListScreenState();
}

class _NotificationsListScreenState extends State<NotificationsListScreen> {
  bool isLoading = true;
  var type ;
  late List<Datum>? userNotificationList;
  getAllListOfNotification()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    type = prefs.getString("type");
    final userList= await NotificationServices().listAllNotification();
    userNotificationList = userList.data;
    isLoading=false;
    setState(() {

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getAllListOfNotification();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(
          Localizations.localeOf(context).languageCode == "en"
              ?"Notification list":"قيمة الاشعرات",
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
      body: isLoading?Loader(): userNotificationList?.length==0?
      Container(
        height: MediaQuery.of(context).size.height ,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("assets/icon/notification_holder.png"),
            ),
            SizedBox(height: 20,),
            Text(Localizations.localeOf(context).languageCode == "en"
                ?"no Notification available":"لا يوجد اشعرات متوفره لان",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20

              ),),
          ],
        ),
      ):ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: userNotificationList?.length,
          itemBuilder: (context, int index) {
            return NotificationCell(press: () { NotificationServices.notificationSelectingAction(userNotificationList![index].type??"", context); },notification: userNotificationList![index],type: type,);
          }),
    );
  }
}