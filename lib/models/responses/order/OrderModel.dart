
import 'package:flutter/cupertino.dart';

import 'CategoryModel.dart';
import 'DriverModel.dart';
import 'ProductsData.dart';
import 'ShippingModel.dart';

class OrderModel {
  int id;
  String orderNumber;
  dynamic finalAmount;
  dynamic totalAmount;
  int discount;
  dynamic taxAmount;
  dynamic transportationAmount;
  int status;
  String statusName;
  String deliverDay;
  String cancelReason;
  String updatedAt;
  String createdAt;
  List<OrderProducts> orderProducts;
  DriverModel driver;
  DeliverTime deliverTime;
  Invoice invoice;

  OrderModel({this.id, this.orderNumber, this.finalAmount, this.totalAmount, this.discount, this.taxAmount, this.transportationAmount, this.status, this.statusName, this.deliverDay, this.cancelReason, this.updatedAt, this.createdAt, this.orderProducts, this.driver, this.deliverTime, this.invoice});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    finalAmount = json['final_amount'];
    totalAmount = json['total_amount'];
    discount = json['discount'];
    taxAmount = json['tax_amount'];
    transportationAmount = json['transportation_amount'];
    status = json['status'];
    statusName = json['status_name'];
    deliverDay = json['deliver_day'];
    cancelReason = json['cancel_reason'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    if (json['order_products'] != null) {
      orderProducts = new List<OrderProducts>();
      json['order_products'].forEach((v) { orderProducts.add(new OrderProducts.fromJson(v)); });
    }
    driver = json['driver'] != null ? new DriverModel.fromJson(json['driver']) : null;
    deliverTime = json['deliver_time'] != null ? new DeliverTime.fromJson(json['deliver_time']) : null;
    invoice = json['invoice'] != null ? new Invoice.fromJson(json['invoice']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_number'] = this.orderNumber;
    data['final_amount'] = this.finalAmount;
    data['total_amount'] = this.totalAmount;
    data['discount'] = this.discount;
    data['tax_amount'] = this.taxAmount;
    data['transportation_amount'] = this.transportationAmount;
    data['status'] = this.status;
    data['status_name'] = this.statusName;
    data['deliver_day'] = this.deliverDay;
    data['cancel_reason'] = this.cancelReason;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    if (this.orderProducts != null) {
      data['order_products'] = this.orderProducts.map((v) => v.toJson()).toList();
    }
    if (this.deliverTime != null) {
      data['driver'] = this.driver;
    }
    if (this.deliverTime != null) {
      data['deliver_time'] = this.deliverTime.toJson();
    }
    if (this.invoice != null) {
      data['invoice'] = this.invoice.toJson();
    }
    return data;
  }
}

class OrderProducts {
  int id;
  List<OtherAdding> productOthers;
  dynamic price;
  int quantity;
  dynamic amount;
//  List<dynamic> substocks;
  Product product;
  Segments segment;

  OrderProducts({this.id, this.productOthers, this.price, this.quantity, this.amount, /*this.substocks,*/ this.product, this.segment});

  OrderProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['product_others'] != null) {
      productOthers = new List<OtherAdding>();
      json['product_others'].forEach((v) { productOthers.add(new OtherAdding.fromJson(v)); });
    }
    price = json['price'];
    quantity = json['quantity'];
    amount = json['amount'];
//    substocks = List<dynamic>.from(json["substocks"].map((x) => x));
    /*if (json['substocks'] != null) {
      substocks = new List<Null>();
      json['substocks'].forEach((v) { substocks.add(new Null.fromJson(v)); });
    }*/
    product = json['product'] != null ? new Product.fromJson(json['product']) : null;
    segment = json['segment'] != null ? new Segments.fromJson(json['segment']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.productOthers != null) {
      data['product_others'] = this.productOthers.map((v) => v.toJson()).toList();
    }
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['amount'] = this.amount;
//    data['substocks'] = this.substocks;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    if (this.segment != null) {
      data['segment'] = this.segment.toJson();
    }
    return data;
  }
}

class ProductOthers {
  int id;
  String name;
  int price;

  ProductOthers({this.id, this.name, this.price});

  ProductOthers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}

class Product {
  int id;
  String name;
  String cover;
  String description;
  int rate;
  dynamic price;
  CategoryModel category;
  int quantity;
  int perOrder;
  dynamic finalPrice;
  int discount;
  String endDiscount;
  int isFavorite;
  List<Images> images;
  List<OtherAdding> otherAdding;
  List<Segments> segments;

  Product({this.id, this.name, this.cover, this.description, this.rate, this.price, this.category, this.quantity, this.perOrder, this.finalPrice, this.discount, this.endDiscount, this.isFavorite, this.images, this.otherAdding, this.segments});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cover = json['cover'];
    description = json['description'];
    rate = json['rate'];
    price = json['price'];
    category = json['category'] != null ? new CategoryModel.fromJson(json['category']) : null;
    quantity = json['quantity'];
    perOrder = json['per_order'];
    finalPrice = json['final_price'];
    discount = json['discount'];
    endDiscount = json['end_discount'];
    isFavorite = json['is_favorite'];
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) { images.add(new Images.fromJson(v)); });
    }
    if (json['other_adding'] != null) {
      otherAdding = new List<OtherAdding>();
      json['other_adding'].forEach((v) { otherAdding.add(new OtherAdding.fromJson(v)); });
    }
    if (json['segments'] != null) {
      segments = new List<Segments>();
      json['segments'].forEach((v) { segments.add(new Segments.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['cover'] = this.cover;
    data['description'] = this.description;
    data['rate'] = this.rate;
    data['price'] = this.price;
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    data['quantity'] = this.quantity;
    data['per_order'] = this.perOrder;
    data['final_price'] = this.finalPrice;
    data['discount'] = this.discount;
    data['end_discount'] = this.endDiscount;
    data['is_favorite'] = this.isFavorite;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    if (this.otherAdding != null) {
      data['other_adding'] = this.otherAdding.map((v) => v.toJson()).toList();
    }
    if (this.segments != null) {
      data['segments'] = this.segments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  int id;
  String name;
  String icon;

  Category({this.id, this.name, this.icon});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    return data;
  }
}

class Images {
  int id;
  String image;

  Images({this.id, this.image});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    return data;
  }
}

class DeliverTime {
  int id;
  String startDeliveryTime;
  String endDeliveryTime;
  int ordersCount;

  DeliverTime({this.id, this.startDeliveryTime, this.endDeliveryTime, this.ordersCount});

  DeliverTime.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDeliveryTime = json['start_delivery_time'];
    endDeliveryTime = json['end_delivery_time'];
    ordersCount = json['orders_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['start_delivery_time'] = this.startDeliveryTime;
    data['end_delivery_time'] = this.endDeliveryTime;
    data['orders_count'] = this.ordersCount;
    return data;
  }
}

class Invoice {
  int id;
  String payType;
  dynamic amount;
  int discount;
  String notes;
  String user;
  String userMobile;
  PromoCode promoCode;
  Bank bank;
  ShippingModel shipping;

  Invoice({this.id, this.payType, this.amount, this.discount, this.notes, this.user, this.userMobile, this.promoCode, this.bank, this.shipping});

  Invoice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    payType = json['pay_type'];
    amount = json['amount'];
    discount = json['discount'];
    notes = json['notes'];
    user = json['user'];
    userMobile = json['user_mobile'];
    promoCode = json['promo_code'] != null ? new PromoCode.fromJson(json['promo_code']) : null;
    bank = json['bank'] != null ? new Bank.fromJson(json['bank']) : null;
    shipping = json['shipping'] != null ? new ShippingModel.fromJson(json['shipping']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pay_type'] = this.payType;
    data['amount'] = this.amount;
    data['discount'] = this.discount;
    data['notes'] = this.notes;
    data['user'] = this.user;
    data['user_mobile'] = this.userMobile;
    if (this.promoCode != null) {
      data['promo_code'] = this.promoCode.toJson();
    }
    if (this.bank != null) {
      data['bank'] = this.bank.toJson();
    }
    if (this.shipping != null) {
      data['shipping'] = this.shipping.toJson();
    }
    return data;
  }
}

class PromoCode {
  int id;
  String name;
  String promoCode;
  dynamic totalAmount;
  int discount;
  String startDate;
  String endDate;

  PromoCode({this.id, this.name, this.promoCode, this.totalAmount, this.discount, this.startDate, this.endDate});

  PromoCode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    promoCode = json['promo_code'];
    totalAmount = json['total_amount'];
    discount = json['discount'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['promo_code'] = this.promoCode;
    data['total_amount'] = this.totalAmount;
    data['discount'] = this.discount;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}

class Bank {
  int id;
  String name;
  String accountNumber;
  String iBan;
  String icon;

  Bank({this.id, this.name, this.accountNumber, this.iBan, this.icon});

  Bank.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    accountNumber = json['account_number'];
    iBan = json['i_ban'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['account_number'] = this.accountNumber;
    data['i_ban'] = this.iBan;
    data['icon'] = this.icon;
    return data;
  }
}

class Shipping {
  int id;
  int defaultValue;
  String address;
  String addressName;
  double lat;
  double lng;

  Shipping({this.id, this.defaultValue, this.address, this.addressName, this.lat, this.lng});

  Shipping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    defaultValue = json['default'];
    address = json['address'];
    addressName = json['address_name'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['default'] = this.defaultValue;
    data['address'] = this.address;
    data['address_name'] = this.addressName;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}