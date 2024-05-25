class BankModel {
  BankModel({
    this.id,
    this.name,
    this.accountNumber,
    this.iBan,
    this.icon,
    this.selected,
  });

  int id;
  String name;
  String accountNumber;
  String iBan;
  String icon;
  bool selected;

  factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
    id: json["id"],
    name: json["name"],
    accountNumber: json["account_number"],
    iBan: json["i_ban"],
    icon: json["icon"],
    selected: json["selected"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "account_number": accountNumber,
    "i_ban": iBan,
    "icon": icon,
    "selected": selected,
  };
}
