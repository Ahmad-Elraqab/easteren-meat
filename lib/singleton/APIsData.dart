import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drivers/constants/constants.dart';
import 'package:drivers/models/responses/BodyAPIModel.dart';
import 'package:drivers/models/responses/MainModel.dart';
import 'package:drivers/models/responses/bank/BodyBank.dart';
import 'package:drivers/models/responses/login/BodyLoginModel.dart';
import 'package:drivers/models/responses/login/LoginModel.dart';
import 'package:drivers/models/responses/notification/NotificationData.dart';
import 'package:drivers/models/responses/order/OrderModel.dart';
import 'package:drivers/models/responses/order/OrdersData.dart';
import 'package:drivers/models/responses/periods/BodyPeriods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:dio/dio.dart' as dio;

import 'dio.dart';

class APIsData {
  final Dio client;

  var url = "https://www.easternmeat.com/api/v1/driver/";
  var customer_url = "https://easternmeat.alhaddaq.com/api/v1/";

  APIsData({@required this.client});

  void setAuthorizationHeader(dynamic token) {
    client.options.headers.addAll({"Authorization": token});
  }

  void setLangHeader(dynamic lang) {
    client.options.headers.addAll({"Accept-Language": lang});
  }

  Future<Null> hideWaiting() async {
//    NativeProgressHud.hideWaiting(); // hide hud
  }

  Future<BodyAPIModel<LoginModel>> login(dynamic mobile, dynamic password) async {
    print("Login");
    print(url + 'login');

    final response = await client.post(url + 'login',
        data: {"mobile": mobile, "password": password}); //.catchError((error){

    print('login response: $response');

    if (response != null && response.data != null) {
      final jsonData = json.decode(response.toString());
      print('jsonData');
      print(jsonData);
      var login = BodyAPIModel<LoginModel>.fromJson(jsonData);
      print('login');
      print(login.toString());
      return login;
    } else {
      print("response or data == null");
    }
  }

  Future<void> logout() async {
    await client.post('${url}logout');
  }

  Future<BodyLoginModel> userLogin(Map<String, String> body) async {
    body.removeWhere((key, value) => value == null);

    print('start createAccount');
    body.forEach((key, value) {
      if (value is int) {
        body[key] = value.toString();
      }
    });
    print('full object: ${body.toString()}');

    var response = await client.post(url + 'login', data: body);
    print("EndFinish");
    print('add new response.data.toString()');
    print(response.toString());
    if (response != null && response.data != null) {
      print("response successfully BodyLoginModel");
      var main = BodyLoginModel.fromJson(json.decode(response.toString()));
      print("EndFinishee3");

      return main;
    }else{
      print("response or data == null");
    }
  }

  Future<BodyBank> getBanks() async {
    final response = await client.get('${url}banks');

    if (response != null && response.data != null) {
      print("response != null && response.data != null");
      final jsonData = json.decode(response.toString());
      var bankModel = BodyBank.fromJson(jsonData);
      print("response"+bankModel.toString());
      return bankModel;
    } else {
      print("response or data == null");
    }
  }

  Future<BodyAPIModel<NotificationData>> getNotifications(int currentPage) async {
    final response = await client.get('${url}my_notifications?page='+currentPage.toString());

    if (response != null && response.data != null) {
      print("response != null && response.data != null");
      final jsonData = json.decode(response.toString());
      var bankModel = BodyAPIModel<NotificationData>.fromJson(jsonData);
      print("response"+bankModel.toString());
      return bankModel;
    }
  }

  Future<BodyAPIModel<LoginModel>> updatelanguage(String lang) async {
    final response = await client.post('${url}updateLanguage',
        data: {"lang": lang});

    if (response != null && response.data != null) {
      final jsonData = json.decode(response.toString());
      var updatelanguage = BodyAPIModel<LoginModel>.fromJson(jsonData);
      return updatelanguage;
    } else {
    }
  }

  Future<BodyAPIModel<LoginModel>> getMyProfile() async {
    final response = await client.post('${url}my_profile');

    if (response != null && response.data != null) {
      final jsonData = json.decode(response.toString());
      var updatelanguage = BodyAPIModel<LoginModel>.fromJson(jsonData);
      return updatelanguage;
    } else {
    }
  }

  Future<BodyAPIModel<OrdersData>> getOrdersData(int currentPage, String orderType) async {
    var response;
//    if(orderType == PENDING)
//      response = await client.get('${url}orders/pending?page='+currentPage.toString());
    if(orderType == CURRENT)
      response = await client.get('${url}orders/current?page='+currentPage.toString());
    else if(orderType == PREVIOUS)
      response = await client.get('${url}orders/previous?page='+currentPage.toString());

    if (response != null && response.data != null) {
      print("response != null && response.data != null");
      final jsonData = json.decode(response.toString());
      BodyAPIModel<OrdersData> ordersData = BodyAPIModel<OrdersData>.fromJson(jsonData);
      print("response"+ordersData.toString());
      return ordersData;
    } else {
      print("response or data == null");
    }
  }

  Future<MainModel> changeOrderStatus(int orderId, Map<String, dynamic> data) async {
    var response = await client.post('${url}finishOrder/'+orderId.toString(),
        data: data);
    if (response != null && response.data != null) {
      print("response != null && response.data != null");
      print("response = "+response.toString());
      final jsonData = json.decode(response.toString());
      var changeOrderStatus = MainModel.fromJson(jsonData);

      return changeOrderStatus;
    } else {
      print("response or data == null");
    }
  }

  Future<BodyPeriods> getPeriods(String date, int shippingId) async {
    print("date = "+date.toString());
    final response = await client.post(customer_url+'newGetPeriods',
        data: {"date": date, "shipping_id": shippingId});

    if (response != null && response.data != null) {
      print("response != null && response.data != null");
      final jsonData = json.decode(response.toString());
      var bodyPeriods = BodyPeriods.fromJson(jsonData);
      print("response"+bodyPeriods.toString());
      return bodyPeriods;
    } else {
      print("response or data == null");
    }
  }

}
