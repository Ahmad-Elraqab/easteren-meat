class DriverModel {
  DriverModel({
    this.id,
    this.name,
    this.image,
    this.mobile,
    this.carType,
    this.carNumber,
    this.lang,
    this.notificationsCount,
  });

  int id;
  String name;
  dynamic image;
  String mobile;
  String carType;
  String carNumber;
  String lang;
  int notificationsCount;

  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    mobile: json["mobile"],
    carType: json["car_type"],
    carNumber: json["car_number"],
    lang: json["lang"],
    notificationsCount: json["notifications_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "mobile": mobile,
    "car_type": carType,
    "car_number": carNumber,
    "lang": lang,
    "notifications_count": notificationsCount,
  };
}