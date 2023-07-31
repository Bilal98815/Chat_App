import 'package:chat_app/auth_service.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Preferences {

  AuthService authService = AuthService();

  void setUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = await authService.getUserDetails(emailId);

    debugPrint('------->> Email of logged in user in checkbox ${user?.email}');

    prefs.setString('name', user?.name ?? '');
    prefs.setString('email', user?.email ?? '');
    prefs.setString('fcm', user?.fcm ?? '');
    prefs.setString('status', user?.status ?? '');
  }

  Future<UserModel> getSharedPreferenceUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    String? email = prefs.getString('email');
    String? fcm = prefs.getString('fcm');
    String? status = prefs.getString('status');

    UserModel user = UserModel();

    user.name = name;
    user.email = email;
    user.fcm = fcm;
    user.status = status;

    return user;

  }

  void clearPrferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    debugPrint('NAME BEFORE CLEARING');
    debugPrint(prefs.getString('name'));
    prefs.clear();
    debugPrint('NAME AFTER CLEARING');
    debugPrint(prefs.getString('name'));
  }

}