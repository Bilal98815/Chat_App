class UserModel {
  String? name;
  String? email;
  String? fcm;
  String? status;

  UserModel({this.name, this.email, this.fcm, this.status});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    fcm = json['fcm'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['fcm'] = this.fcm;
    data['status'] = this.status;
    return data;
  }
}
