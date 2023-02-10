import 'dart:convert';

import 'package:equatable/equatable.dart';

class Login extends Equatable {
  Login({this.token, this.message});

  String? token;
  String? message;

  factory Login.fromRawJson(String str) => Login.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Login.fromJson(Map<String, dynamic> json) =>
      Login(token: json["token"], message: json["message"]);

  Map<String, dynamic> toJson() => {
        "token": token,
        "message": message,
      };

  @override
  List<Object?> get props => [token, message];
}
