import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import '../db_connection.dart';

final Connection dbconn = Connection();

class Auth {
  Future<Response> login(Request req) async {
    var conn = await dbconn.connectSql();
    String body = await req.readAsString();
    var obj = jsonDecode(body);

    var username = obj['username'];
    var password = obj['password'];

    var findUser =
        await conn.query('SELECT * FROM users WHERE username = ?', [username]);

    await conn.close();
    if (findUser.isNotEmpty) {
      var matchPassword = findUser.first.fields["password"] ==
          md5.convert(utf8.encode(password)).toString();
      if (matchPassword) {
        final payload = JWT({"user": findUser.first.fields});
        var token = payload.sign(SecretKey('absensi_pegawai'));
        var user = {"user": findUser.first.fields, "jwt": token};
        return Response.ok(user.toString());
      }
      return Response.notFound("Error: Password not match");
    }
    return Response.notFound("Error: Username not match");
  }

  Future<bool> validateJWT(String token) async {
    var splitBearer = token.split(" ")[1];

    try {
      final verifyJWT = JWT.verify(splitBearer, SecretKey("absensi_pegawai"));
      if (verifyJWT.payload.toString().contains("user")) {
        return true;
      }
    } on JWTError catch (_) {
      return false;
    }

    return false;
  }
}
