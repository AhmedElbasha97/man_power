import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:manpower/Global/Settings.dart';
import 'package:manpower/models/client/userClient.dart';
import 'package:manpower/models/other/authresult.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String loginLink = "login";
  String loginwoker = "/worker";
  String signUp = "signup/client";
  String editProfile = "set/client/info";
  String clientProfile = "client/profile";

  Future<AuthResult?> login(
      { String? username,  String? password,  String? type}) async {
    AuthResult result;
    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String link = "$baseUrl$loginLink";
    if (type == "worker") {
      link += loginwoker;
    }
    try {
      response = await Dio()
          .post(link, data: {"username": "$username", "password": "$password"});
      result = AuthResult.fromJson(response.data);
      if (response.data != null &&
          response.data != "" &&
          response.data['status'] == "success") {
        prefs.setString("type", type!);
        prefs.setString(
            "id",
            type == "client"
                ? response.data["data"]["memberid"]
                : type == "worker"
                    ? response.data["data"]["workerid"]
                    : response.data["data"]["companyid"]);
        prefs.setString(
            "name",
            type == "client"
                ? response.data["data"]["username"]
                : response.data["data"]["name"]);
        if (type == "company") {
          prefs.setString("image", response.data["data"]["picpath"]);
          prefs.setString('companyData', jsonEncode(response.data));
        }
      }
      return result;
    } on DioError catch (e) {
      print('error in LoginService => ${e.response}');

    }
  }

  Future<AuthResult?> createAccount(
      { String? name,
       String? username,
       String? password,
       String? mobile,
       String? email}) async {
    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AuthResult result;

    try {
      response = await Dio().post("$baseUrl$signUp", data: {
        "name": "$name",
        "username": "$username",
        "mobile": "$mobile",
        "email": "$email",
        "password": "$password"
      });
      result = AuthResult.fromJson(response.data);
      print(response.data);
      if (response.data['status'] == "success" && response.data != null) {
        prefs.setString("type", "client");
        prefs.setString("id", "${response.data['data']['memberid']}");
        prefs.setString("name", "${response.data['data']['username']}");
      }
      return result;
    } on DioError catch (e) {
      print('error in LoginService => ${e.response}');

    }
  }

  Future<AuthResult?> editAccount(
      { String? name,
       String? username,
       String? password,
       String? mobile,
       String? email}) async {
    Response response;
    AuthResult result;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      var data = FormData.fromMap({
        "client_id": "$id",
        "name_en": name,
        "username": username,
        "mobile": mobile,
        "email": email,
        "password": password
      });
      response = await Dio().post("$baseUrl$editProfile", data: data);
      result = AuthResult.fromJson(response.data);
      return result;
    } on DioError catch (e) {
      print('error in LoginService => ${e.response}');

    }
  }

  Future<UserClientMOdel?> getClientAccount({ String? id}) async {
    Response response;
    UserClientMOdel data;
    try {
      var body = FormData.fromMap({
        "client_id": id,
      });
      response = await Dio().post("$baseUrl$clientProfile", data: body);
      if (response.data['error'] == null && response.data != null) {
        data = UserClientMOdel.fromJson(response.data);
        return data;
      }
    } on DioError catch (e) {
      print('error in LoginService => ${e.response}');
    }
  }
}
