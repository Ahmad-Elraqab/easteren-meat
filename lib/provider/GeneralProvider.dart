import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:drivers/constants/constants.dart';
import 'package:drivers/models/responses/BodyAPIModel.dart';
import 'package:drivers/models/responses/bank/BankModel.dart';
import 'package:drivers/models/responses/login/LoginModel.dart';
import 'package:drivers/models/responses/notification/NotificationModel.dart';
import 'package:drivers/models/responses/order/OrderModel.dart';
import 'package:drivers/models/responses/periods/PeriodModel.dart';
import 'package:drivers/singleton/APIsData.dart';
import 'package:drivers/singleton/AppSharedPreferences.dart';
import 'package:drivers/singleton/dio.dart';
import 'package:drivers/views/home/HomeScreen.dart';
import 'package:drivers/views/login/Login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GeneralProvider extends ChangeNotifier {
  bool _unauthenticated = false;
  List<BankModel> _bankList = List<BankModel>();
  List<NotificationModel> _notificationsList = List<NotificationModel>();
  List<OrderModel> _ordersDataCurrentList = List<OrderModel>();
  List<OrderModel> _ordersDataPreviousList = List<OrderModel>();
  List<PeriodModel> _periodsList = List<PeriodModel>();
  LoginModel _loginModel;

  bool get unauthenticated => _unauthenticated;
  List<BankModel> get bankList => _bankList;
  List<NotificationModel> get notificationsList => _notificationsList;
  List<OrderModel> get ordersDataCurrentList => _ordersDataCurrentList;
  List<OrderModel> get ordersDataPreviousList => _ordersDataPreviousList;
  List<PeriodModel> get periodsList => _periodsList;
  LoginModel get loginModel => _loginModel;

  //pagination
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool _isLoading = true;
  var nextPage = 1;
  int _lastPage = 1;

  int get lastPage => _lastPage;

  bool get isLoading => _isLoading;

  void userLogin({BuildContext context, Map<String, String> body}) {
    _isLoading = false;
    print('start create account');
    getIt<APIsData>().userLogin(body).then(
      (user) {
        _isLoading = true;
        LoginModel _user = user.data;

        getIt<AppSharedPreferences>().setUserToken(_user.accessToken);
        getIt<AppSharedPreferences>().setUserImage(_user.image);
        getIt<AppSharedPreferences>().setUserMobile(_user.mobile);
        getIt<AppSharedPreferences>().setFullName(_user.name);
        getIt<AppSharedPreferences>().setCarType(_user.carType);
        getIt<AppSharedPreferences>().setCarNumber(_user.carNumber);
        getIt<AppSharedPreferences>().setUserId(_user.id);
        getIt<AppSharedPreferences>().setLogin(_user);
        getIt<AppSharedPreferences>().sharedPreferences.reload();

        print("Token :>>>> ${_user.accessToken}");
        refreshToken();
        print('finish create account2');
        notifyListeners();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            child: HomeScreen(0),
            create: (context) => GeneralProvider(),
          ),
        ));
      },
    ).catchError((error) {
      _isLoading = true;
      print("catchError");
      showErrorOrUnauth(context, error);
    });
  }

  void userLogout(BuildContext context) {
    print('start logout');
    getIt<APIsData>().logout().then(
      (value) {
        print('finish logout');
        notifyListeners();

        firebaseMessaging.unsubscribeFromTopic(
            "driver_${getIt<AppSharedPreferences>().getUserId()}");
        //todo clear all data
        getIt<AppSharedPreferences>().clear();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                      child: Login(),
                      create: (context) => GeneralProvider(),
                    )),
            (Route<dynamic> route) => false);
      },
    ).catchError((error) {
      print("catchError");
      showError(context, error);
    });
  }

  void getBanks(BuildContext context, Function onDone) {
    _isLoading = false;
    getIt<APIsData>().getBanks().then(
      (value) {
        _isLoading = true;
        print("_bankModel = " + value.data.toString());
        _bankList = value.data;
        notifyListeners();
        onDone();
      },
    ).catchError((error) {
      _isLoading = true;
      print("catchError = " + error.toString());
      showErrorOrUnauth(context, error);
    });
  }

  void getNotifications(
      BuildContext context, int currentPage, Function onDone) {
    _isLoading = false;
    getIt<APIsData>().getNotifications(currentPage).then(
      (value) {
        _isLoading = true;
        print("_notificationsModelList = " + value.data.items.toString());
        _notificationsList = value.data.items;
        _lastPage = value.data.pagination.lastPage;
        notifyListeners();
        onDone();
      },
    ).catchError((error) {
      _isLoading = true;
      print("catchError >> _notificationsModelList = " + error.toString());
      showErrorOrUnauth(context, error);
    });
  }

  void getOrdersData(BuildContext context, int currentPage, String orderType,
      Function onDone) {
    _isLoading = false;
    getIt<APIsData>().getOrdersData(currentPage, orderType).then(
          (value) {
        _isLoading = true;
        print("_ordersDataList = " + value.data.items.toString());
//        if(orderType == PENDING)
//          _ordersDataProccrssingList.addAll(value.data.items);
        if(orderType == CURRENT)
          _ordersDataCurrentList.addAll(value.data.items);
        else if(orderType == PREVIOUS)
          _ordersDataPreviousList.addAll(value.data.items);
        _lastPage = value.data.pagination.lastPage;
        notifyListeners();
        onDone();
      },
    ).catchError((error) {
      _isLoading = true;
//      print("catchError >> _ordersDataList = " + error.toString());
      showErrorOrUnauth(context, error);
    });
  }

  void changeOrderStatus(BuildContext context, int orderId,
      Map<String, dynamic> data, Function onDone) {
    _isLoading = false;
    getIt<APIsData>().changeOrderStatus(orderId, data).then(
          (value) {
        _isLoading = true;
        print("changeOrderStatus = " + value.toString());
        notifyListeners();
        onDone();
      },
    ).catchError((error) {
      _isLoading = true;
      print("catchError >> changeOrderStatus = " + error.toString());
      showErrorOrUnauth(context, error);
    });
  }

  void getPeriods(BuildContext context, int shippingId, String date, Function onDone) {
    getIt<APIsData>().getPeriods(date, shippingId).then(
          (value) {
        print("_periodsList = " + value.data.toString());
        _periodsList = value.data;
        notifyListeners();
        onDone();
      },
    ).catchError((error) {
      print("catchError >> _periodsList = " + error.toString());
//      showError(context, error);
      onDone();
    });
  }

  void getMyProfile(BuildContext context, Function onDone) {
    getIt<APIsData>().getMyProfile().then(
          (value) {
        print("getMyProfile = " + value.data.toString());
        _loginModel = value.data;
        notifyListeners();
        onDone();
      },
    ).catchError((error) {
      print("catchError >> getMyProfile = " + error.toString());
//      showError(context, error);
      onDone();
    });
  }

  void showErrorOrUnauth(BuildContext context, dynamic error) async {
    BodyAPIModel errorModel;
    if ((error as DioError).response != null) {
      final jsonData = json.decode(error.response.toString());
      print("(error as DioError).response != null >>> " +
          error.response.toString());
      errorModel = BodyAPIModel.fromJson(jsonData);
      if (errorModel.status == 401) {
        _unauthenticated = true;
        print("Unauthenticated Unauthenticated");

        firebaseMessaging.unsubscribeFromTopic(
            "driver_${getIt<AppSharedPreferences>().getUserId()}");
        //todo clear all data
        getIt<AppSharedPreferences>().clear();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  child: Login(),
                  create: (context) => GeneralProvider(),
                )),
                (Route<dynamic> route) => false);

        await notifyListeners();
      } else {
        print("showError");
        showError(context, error);
      }
    }
  }

  clear() {
    if (_notificationsList != null) _notificationsList.clear();
    if (_ordersDataCurrentList != null) _ordersDataCurrentList.clear();
    if (_ordersDataPreviousList != null) _ordersDataPreviousList.clear();
  }
}
