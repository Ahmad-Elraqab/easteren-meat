
import 'package:drivers/models/responses/pagination/PaginationModel.dart';
import 'NotificationModel.dart';

class NotificationData {
  NotificationData({
    this.items,
    this.pagination,
    this.notificationsCount,
  });

  List<NotificationModel> items;
  Pagination pagination;
  int notificationsCount;

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    items: List<NotificationModel>.from(json["items"].map((x) => NotificationModel.fromJson(x))),
    pagination: Pagination.fromJson(json["pagination"]),
    notificationsCount: json["notifications_count"],
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "pagination": pagination.toJson(),
    "notifications_count": notificationsCount,
  };
}
