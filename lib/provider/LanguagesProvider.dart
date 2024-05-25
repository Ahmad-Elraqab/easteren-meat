import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drivers/models/responses/login/LoginModel.dart';
import 'package:drivers/singleton/APIsData.dart';
import 'package:drivers/singleton/AppSharedPreferences.dart';
import 'package:drivers/singleton/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:easternmeatapp/singleton/dio.dart' as dio;

class LanguagesProvider extends ChangeNotifier {
  final SharedPreferences sharedPreferences;

  LanguagesProvider({@required this.sharedPreferences});

  Locale _appLocale = Locale('en');

  Locale get appLocal => _appLocale ?? Locale("en");

  fetchLocale() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();

    //call functions like pref.getInt(), etc. here
    sharedPreferences.reload();
    if (sharedPreferences.getString('language_code') == null) {
      _appLocale =
          Locale(Platform.localeName.split('_')[1] == "US" ? "ar" : "ar");
      print("APPLocal null" + Platform.localeName.split('_')[1]);

      return Null;
    }
    _appLocale = Locale(sharedPreferences.getString('language_code'));
    this._appLocale = _appLocale;
    notifyListeners();
    print("APPLocal $_appLocale");

    return _appLocale;
  }

  void changeLanguage(
      BuildContext context, Locale type, String lang, Function onDone) async {
    print("changeLanguage");
    _appLocale = type;
    if (getIt<AppSharedPreferences>().getUserToken() != null) {
      var preferences = await SharedPreferences.getInstance();
      preferences.reload();
      Map userMap = jsonDecode(preferences.getString('user'));
      LoginModel user = LoginModel.fromJson(userMap);
      print('user.accessToken: ${user.accessToken}');
      getIt<Dio>().options.headers = {
        "Authorization": "Bearer ${user.accessToken}",
        'Accept-Language':
            getIt<LanguagesProvider>().appLocal.languageCode.toLowerCase(),
      };
      print({
        'Accept-Language':
            getIt<LanguagesProvider>().appLocal.languageCode.toLowerCase(),
        "Authorization": "Bearer ${user.accessToken}",
      });
      if (type.languageCode.toLowerCase() == "ar") {
        _appLocale = Locale("ar");
        sharedPreferences.setString('language_code', 'ar');
        sharedPreferences.setString('countryCode', 'SA');
      } else {
        _appLocale = Locale("en");
        sharedPreferences.setString('language_code', 'en');
        sharedPreferences.setString('countryCode', 'US');
      }
      print(
          "language_code aaa--- ${sharedPreferences.getString("language_code")}");
      print(
          "language_code aaa--- ${sharedPreferences.getString("countryCode")}");
      sharedPreferences.reload();

      await getIt<APIsData>().updatelanguage(lang).then(
        (value) {
          notifyListeners();
          onDone();
        },
      ).catchError((error) {
        print("catchError >> _ordersDataList = " + error.toString());
//        showError(context, error);
      });
    } else {
      print("no user");
      getIt<Dio>().options.headers = {
        'Accept-Language':
            getIt<LanguagesProvider>().appLocal.languageCode.toLowerCase(),
      };
      if (type.languageCode.toLowerCase() == "ar") {
        _appLocale = Locale("ar");
        sharedPreferences.setString('language_code', 'ar');
        sharedPreferences.setString('countryCode', 'SA');
      } else {
        _appLocale = Locale("en");
        sharedPreferences.setString('language_code', 'en');
        sharedPreferences.setString('countryCode', 'US');
      }
      print(
          "language_code aaa--- ${sharedPreferences.getString("language_code")}");
      print(
          "language_code aaa--- ${sharedPreferences.getString("countryCode")}");
      sharedPreferences.reload();
      notifyListeners();
    }
  }
}
