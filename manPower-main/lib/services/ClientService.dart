import 'package:dio/dio.dart';
import 'package:manpower/Global/Settings.dart';
import 'package:manpower/models/client/favoriteEmployee.dart';
import 'package:manpower/models/client/walletItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientService {
  String transations = "transaction";
  String favorite = "favorite";
  String addFavorite = "add/favorite";
  String deleteFavorite = "delete/favorite";

  Future<List<WalletItem>> getTransations() async {
    Response response;
    List<WalletItem> list = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString("id") ?? "";
      var body = {"client_id": userId};
      response = await Dio().post('$baseUrl$transations', data: body);
      List data = response.data;
      data.forEach((element) {
        list.add(WalletItem.fromJson(element));
      });
    } on DioError catch (e) {
      print('${e.response}');

      return [];
    }
    return list;
  }

  Future<List<FavoriteEmployee>> favoraiteList() async {
    Response response;
    List<FavoriteEmployee> list = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString("id") ?? "";
      var body = {"client_id": userId};
      response = await Dio().post('$baseUrl$favorite', data: body);
      List data = response.data;
      data.forEach((element) {
        list.add(FavoriteEmployee.fromJson(element));
      });
    } on DioError catch (e) {
      print('${e.response}');

      return [];
    }
    return list;
  }

  Future<bool> addToFavorite(String workerId) async {
    Response response;
    bool result = false;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString("id") ?? "";
      var body = {"client_id": userId, "worker_id": workerId};
      response = await Dio().post('$baseUrl$addFavorite', data: body);
      var data = response.data;
      if (data["status"] != "failed") {
        return true;
      }
    } on DioError catch (e) {
      print('${e.response}');
      return false;
    }
    return result;
  }

  Future<bool> deleteFromFavorite(String favoriteId) async {
    Response response;
    bool result = false;
    try {
      var body = {
        "favorite_id": favoriteId,
      };
      response = await Dio().post('$baseUrl$deleteFavorite', data: body);
      var data = response.data;
      if (data["status"] != "failed") {
        return true;
      }
    } on DioError catch (e) {
      print('${e.response}');
      return false;
    }
    return result;
  }
}
