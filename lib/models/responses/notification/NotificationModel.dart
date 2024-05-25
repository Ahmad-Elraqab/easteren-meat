
import 'package:drivers/models/responses/order/OrderModel.dart';

class NotificationModel {
  NotificationModel({
    this.id,
    this.title,
    this.details,
    this.type,
    this.typeId,
    this.sender,
    this.read,
    this.orderModel,
    this.createdAt,
    this.localCreatedAt,
  });

  String id;
  String title;
  String details;
  String type;
  int typeId;
  dynamic sender;
  int read;
  OrderModel orderModel;
  String createdAt;
  String localCreatedAt;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: json["id"],
    title: json["title"],
    details: json["details"],
    type: json["type"],
    typeId: json["type_id"],
    sender: json["sender"],
    read: json["read"],
    orderModel: json["order"] == null ? null : OrderModel.fromJson(json["order"]),
    createdAt: json["created_at"],
    localCreatedAt: json["local_created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "details": details,
    "type": type,
    "type_id": typeId,
    "sender": sender,
    "read": read,
    "order": orderModel == null ? null : orderModel.toJson(),
    "created_at": createdAt,
    "local_created_at": localCreatedAt,
  };
}
