
class ShippingModel {
  ShippingModel({
    this.id,
    this.welcomeDefault,
    this.address,
    this.addressName,
    this.lat,
    this.lng,
    this.selected,
  });

  int id;
  int welcomeDefault;
  String address;
  String addressName;
  dynamic lat;
  dynamic lng;
  bool selected;

  factory ShippingModel.fromJson(Map<String, dynamic> json) => ShippingModel(
    id: json["id"],
    welcomeDefault: json["default"],
    address: json["address"],
    addressName: json["address_name"],
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
    selected: json["selected"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "default": welcomeDefault,
    "address": address,
    "address_name": addressName,
    "lat": lat,
    "lng": lng,
    "selected": selected,
  };
}
