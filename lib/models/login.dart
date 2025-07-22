import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
    String cif;
    String token;

    Login({
        required this.cif,
        required this.token,
    });

    factory Login.fromJson(Map<String, dynamic> json) => Login(
        cif: json["cif"],
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "cif": cif,
        "token": token,
    };
}
