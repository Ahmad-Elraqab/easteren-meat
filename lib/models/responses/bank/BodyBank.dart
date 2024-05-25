import 'dart:convert';
import 'BankModel.dart';

BodyBank welcomeFromJson(String str) => BodyBank.fromJson(json.decode(str));

String welcomeToJson(BodyBank data) => json.encode(data.toJson());

class BodyBank {
  BodyBank({
    this.success,
    this.data,
    this.message,
    this.status,
  });

  bool success;
  List<BankModel> data;
  String message;
  int status;

  factory BodyBank.fromJson(Map<String, dynamic> json) => BodyBank(
    success: json["success"],
    data: List<BankModel>.from(json["data"].map((x) => BankModel.fromJson(x))),
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
    "status": status,
  };
}
