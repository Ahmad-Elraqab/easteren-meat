
import 'package:drivers/models/responses/pagination/PaginationModel.dart';

import 'OrderModel.dart';

class OrdersData {
  OrdersData({
    this.items,
    this.pagination,
  });

  List<OrderModel> items;
  Pagination pagination;

  factory OrdersData.fromJson(Map<String, dynamic> json) => OrdersData(
    items: List<OrderModel>.from(json["items"].map((x) => OrderModel.fromJson(x))),
    pagination: Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "pagination": pagination.toJson(),
  };
}