import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:drivers/constants/colors.dart';
import 'package:drivers/constants/constants.dart';
import 'package:drivers/models/responses/BodyAPIModel.dart';
import 'package:drivers/models/responses/login/LoginModel.dart';
import 'package:drivers/provider/LanguagesProvider.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'APIsData.dart';
import 'AppSharedPreferences.dart';

final getIt = GetIt.instance;
final  firebaseMessaging = FirebaseMessaging();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

Future<void> init() async {
  getIt.registerLazySingleton<AppSharedPreferences>(
      () => AppSharedPreferences(sharedPreferences: getIt()));

  getIt.registerLazySingleton<LanguagesProvider>(
      () => LanguagesProvider(sharedPreferences: getIt()));

  getIt.registerLazySingleton<APIsData>(() => APIsData(client: getIt()));

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  Dio client = Dio(
    BaseOptions(
      headers: {
        'Accept-Language': 'ar',
//          getIt<AppSharedPreferences>().getLogin() == null?"notAuth":"Authorization": getIt<AppSharedPreferences>().getLogin() == null?"notAuth":getIt<AppSharedPreferences>().getLogin().access_token,
      },
    ),
  );

  getIt.registerLazySingleton<Dio>(() => client);
  getIt.registerLazySingleton(() => http.Client());

  getIt.registerLazySingleton(() async => await SharedPreferences.getInstance());

  refreshToken();
  firebaseMessaging.configure(
    onMessage: (Map<dynamic, dynamic> message) async {
      print("onMessage: $message");
//      showErrorString(context, $message)
    },
//    onBackgroundMessage: myBackgroundMessageHandler,
    onLaunch: (Map<dynamic, dynamic> message) async {
      print("onLaunch: $message");
    },
    onResume: (Map<dynamic, dynamic> message) async {
      print("onResume: $message");
    },
  );
}

void showNotification(Map<dynamic, dynamic> message) async {
  var android = new AndroidNotificationDetails('channel_id', "CHANNEL NAME", "channelDescription");
  var ios = new IOSNotificationDetails();
  var platform = new NotificationDetails(android, ios);
  await flutterLocalNotificationsPlugin.show(0, message["notification"]["title"], message["notification"]["body"], platform);
  var type = message['data']['type'].toString();
}

refreshToken() async {
  print("refreshToken .... ");
  var preferences = await SharedPreferences.getInstance();
  preferences.reload();
  if (preferences.getString('user') != null) {

    firebaseMessaging.subscribeToTopic("driver_${getIt<AppSharedPreferences>().getUserId()}");


    Map userMap = jsonDecode(preferences.getString('user'));
    LoginModel user = LoginModel.fromJson(userMap);
    print('user.accessToken: ${user.accessToken}');
    getIt<Dio>().options.headers = {
      "Authorization": "Bearer ${user.accessToken}",
      'Accept-Language': getIt<LanguagesProvider>().appLocal.languageCode.toLowerCase(),
    };

    print(getIt<Dio>().options.headers);
  } else {
    getIt<Dio>().options.headers = {
      'Accept-Language': getIt<LanguagesProvider>().appLocal.languageCode.toLowerCase(),
    };

    print("user = null >> "+getIt<Dio>().options.headers.toString());
  }
}

showError(BuildContext context, error) {
  print("showError = "+error.toString());
  if (error is DioError) {
    print("showError = "+(error as DioError).error.toString());
//    print("showError = "+(error as DioError).response.data.toString());
    BodyAPIModel errorMoadel;
    if ((error as DioError).response != null) {
      final jsonData = json.decode(error.response.toString());
      print("(error as DioError).response != null >>> "+error.response.toString());
      errorMoadel = BodyAPIModel.fromJson(jsonData);
    } else {
      errorMoadel = BodyAPIModel(error.type);
    }
    EdgeAlert.show(context,
        title: getTranslated(context, "sorry"),
        description: errorMoadel.message,
        gravity: EdgeAlert.TOP,
        icon: Icons.warning,
        backgroundColor: primaryColor);
  } else {
    print("showError >>> else");
    EdgeAlert.show(context,
        title: getTranslated(context, "sorry"),
        description: 'There is no internet Conntect',
        gravity: EdgeAlert.TOP,
        icon: Icons.warning,
        backgroundColor: Colors.redAccent);
  }
}

showErrorString(BuildContext context, dynamic error) {
  EdgeAlert.show(context,
      title: getTranslated(context, "sorry"),
      description: error,
      gravity: EdgeAlert.TOP,
      icon: Icons.warning,
      backgroundColor: Colors.redAccent);
}