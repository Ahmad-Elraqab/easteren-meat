
import 'package:drivers/models/responses/pagination/PaginationModel.dart';

import 'CategoryModel.dart';

class ProductsData {
  List<Products> items;
  Pagination pagination;

  ProductsData({this.items, this.pagination});

  ProductsData.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<Products>();
      json['items'].forEach((v) {
        items.add(new Products.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination.toJson();
    }
    return data;
  }
}

class Products {
  int id;
  String name;
  String cover;
  String description;
  dynamic rate;
  dynamic price;
  CategoryModel category;
  int quantity;
  int perOrder;
  dynamic finalPrice;
  dynamic discount;
  String endDiscount;
  int isFavorite;
  List<Images> images;
  List<OtherAdding> otherAdding;
  List<Segments> segments;

  Products(
      {this.id,
        this.name,
        this.cover,
        this.description,
        this.rate,
        this.price,
        this.category,
        this.quantity,
        this.perOrder,
        this.finalPrice,
        this.discount,
        this.endDiscount,
        this.isFavorite,
        this.images,
        this.otherAdding,
        this.segments});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cover = json['cover'];
    description = json['description'];
    rate = json['rate'];
    price = json['price'];
    category = json['category'] != null
        ? new CategoryModel.fromJson(json['category'])
        : null;
    quantity = json['quantity'];
    perOrder = json['per_order'];
    finalPrice = json['final_price'];
    discount = json['discount'];
    endDiscount = json['end_discount'];
    isFavorite = json['is_favorite'];
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
    if (json['other_adding'] != null) {
      otherAdding = new List<OtherAdding>();
      json['other_adding'].forEach((v) {
        otherAdding.add(new OtherAdding.fromJson(v));
      });
    }
    if (json['segments'] != null) {
      segments = new List<Segments>();
      json['segments'].forEach((v) {
        segments.add(new Segments.fromJson(v));
      });
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

class OtherAdding {
  int id;
  String name;
  dynamic price;
  bool selected;

  OtherAdding({this.id, this.name, this.price, this.selected});

  OtherAdding.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['selected'] = this.selected;
    return data;
  }
}

class Segments{
  int id;
  String name;
  dynamic price;
  bool selected;

  Segments({this.id, this.name, this.price, this.selected});

  Segments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['selected'] = this.selected;
    return data;
  }
}