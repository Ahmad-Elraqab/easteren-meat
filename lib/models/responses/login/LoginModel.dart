
class LoginModel{
  int id;
  String name;
  String image;
  String mobile;
  String carType;
  String carNumber;
  String lang;
  String accessToken;
  String firebaseToken;
  int notificationsCount;

  LoginModel(
      {this.id,
        this.name,
        this.image,
        this.mobile,
        this.carType,
        this.carNumber,
        this.lang,
        this.accessToken,
        this.firebaseToken,
        this.notificationsCount});

  LoginModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    mobile = json['mobile'];
    carType = json['car_type'];
    carNumber = json['car_number'];
    lang = json['lang'];
    accessToken = json['access_token'];
    firebaseToken = json['firebase_token'];
    notificationsCount = json['notifications_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['mobile'] = this.mobile;
    data['car_type'] = this.carType;
    data['car_number'] = this.carNumber;
    data['lang'] = this.lang;
    data['access_token'] = this.accessToken;
    data['firebase_token'] = this.firebaseToken;
    data['notifications_count'] = this.notificationsCount;
    return data;
  }
}