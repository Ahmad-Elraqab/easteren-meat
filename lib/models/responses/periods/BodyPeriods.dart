// To parse this JSON data, do
//
//     final pendingOrder = pendingOrderFromJson(jsonString);

import 'dart:convert';

import 'PeriodModel.dart';

BodyPeriods pendingOrderFromJson(String str) => BodyPeriods.fromJson(json.decode(str));

String pendingOrderToJson(BodyPeriods data) => json.encode(data.toJson());

class BodyPeriods {
  bool success;
  List<PeriodModel> data;
  String message;
  int status;

  BodyPeriods({this.success, this.data, this.message, this.status});

  BodyPeriods.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<PeriodModel>();
      json['data'].forEach((v) {
        data.add(new PeriodModel.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}