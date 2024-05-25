import 'package:dio/dio.dart';
import 'login/LoginModel.dart';
import 'notification/NotificationData.dart';
import 'order/OrderModel.dart';
import 'order/OrdersData.dart';

class BodyAPIModel<T> {
   bool success;
   String message;
   T data;
   int status;

  BodyAPIModel(DioErrorType errorType) {

    if ( errorType == DioErrorType.DEFAULT){
      print("DioErrorType.DEFAULT");
      success = false;
      message = "internet connection not found";
      status = 0;
    }
    else if ( errorType == DioErrorType.CONNECT_TIMEOUT){
      success = false;
      message = "CONNECT TIMEOUT";
      status = 0;
    }

    else if ( errorType == DioErrorType.RECEIVE_TIMEOUT){
      success = false;
      message = "RECEIVE TIMEOUT";
      status = 0;
    }
    else if ( errorType == DioErrorType.SEND_TIMEOUT){
      success = false;
      message = "SEND TIMEOUT";
      status = 0;
    }else {
      print("DioErrorType.DEFAULT = else");
      success = false;
      message = "internet connection not found";
      status = 0;
    }
//    if ( errorType == DioErrorType.CANCEL){
//
//    }
//    success = json['success'];
//    message = json['message'];
//    status = json['status'];
  }
  BodyAPIModel.fromJson(Map<String, dynamic> json)
      : success = json['success'],
        data =  json['data']==null?null: CheckInput.fromJson(json['data']),
        message = json['message'],
        status = json['status'];


  @override
  String toString() {

    return "STR OUTPUT {success: ${success} message ${message}";
  }
}

//todo very important class //////////////////////////////////////////////
class CheckInput {
  static T fromJson<T, k>(dynamic json) {
    if (json is Iterable) {
      print("(json is Iterable) = ");
    } else if (T == LoginModel) {
      return LoginModel.fromJson(json) as T;
    } else if (T == NotificationData) {
      return NotificationData.fromJson(json) as T;
    } else if (T == OrdersData) {
      return OrdersData.fromJson(json) as T;
    } else if (T == OrderModel) {
      return OrderModel.fromJson(json) as T;
    } else if (T == Object) {
      return null;
    } else {
      throw Exception("Unknown class");
    }
  }

  static List<K> _fromJsonList<K>(List jsonList) {
    if (jsonList == null) {
      return null;
    }

    List<K> output = List();

    for (Map<String, dynamic> json in jsonList) {
      output.add(fromJson(json));
    }

    return output;
  }
}
