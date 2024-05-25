
import 'package:drivers/constants/constants.dart';
import 'package:flutter/cupertino.dart';

class PeriodModel {
  PeriodModel({
      this.id,
      this.startDeliveryTime,
      this.endDeliveryTime,
      this.ordersCount,
    });

    int id;
    String startDeliveryTime;
    String endDeliveryTime;
    int ordersCount;

    getPeriod(BuildContext context){
      return getTranslated(context, "from")+" "+startDeliveryTime+" "+
          getTranslated(context, "to")+" "+endDeliveryTime;
    }

    factory PeriodModel.fromJson(Map<String, dynamic> json) => PeriodModel(
      id: json["id"],
      startDeliveryTime: json["start_delivery_time"],
      endDeliveryTime: json["end_delivery_time"],
      ordersCount: json["orders_count"],
    );

    Map<String, dynamic> toJson() => {
      "id": id,
      "start_delivery_time": startDeliveryTime,
      "end_delivery_time": endDeliveryTime,
      "orders_count": ordersCount,
    };
  }
