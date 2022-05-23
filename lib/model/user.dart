class User {
  String? name;
  String? phoneNumber;
  String? email;
  String? homeAddress;
  String? password;

  User(
      {this.name,
      this.phoneNumber,
      this.email,
      this.homeAddress,
      this.password});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    homeAddress = json['homeAddress'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phoneNum'] = phoneNumber;
    data['email'] = email;
    data['address'] = homeAddress;
    data['password'] = password;
    return data;
  }
}
