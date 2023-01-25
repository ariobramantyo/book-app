import 'dart:convert';

class Login {
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
}

// class Result {
//   Result({required this.message, required this.token});

//   String message;
//   String token;

//   factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Result.fromJson(Map<String, dynamic> json) => Result(
//         message: json["message"],
//         token: json["token"],
//       );

//   Map<String, dynamic> toJson() => {
//         "message": message,
//         "token": token,
//       };
// }
