import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? message;
  String? sender;
  String? reciever;
  FieldValue? time;

  MessageModel({this.message, this.sender, this.reciever, this.time});

  MessageModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    sender = json['sender'];
    reciever = json['reciever'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['sender'] = this.sender;
    data['reciever'] = this.reciever;
    data['time'] = this.time;
    return data;
  }
}
