import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import '../Auth/auth.dart';
import '../db_connection.dart';
import '../server.dart';

final Connection dbconn = Connection();
final Auth auth = Auth();

class User {
  Future<Response> getUser(Request req) async {
    var token = req.headers["authorization"];
    var verifyJWT = await auth.validateJWT(token.toString());
    if (!verifyJWT) {
      return Response.notFound("Error: Unauthorized");
    }

    var conn = await dbconn.connectSql();

    var getData = await conn.query("SELECT * FROM users");

    return Response.ok(getData.toString());
  }

  Future<Response> insertUser(Request req) async {
    var token = req.headers["authorization"];
    var verifyJWT = await auth.validateJWT(token.toString());
    if (!verifyJWT) {
      return Response.notFound("Error: Unauthorized");
    }

    var conn = await dbconn.connectSql();
    String bodyRequest = await req.readAsString();
    var data = json.decode(bodyRequest);

    var username = data["username"];
    var password = md5.convert(utf8.encode(data["password"])).toString();

    await conn.query("INSERT INTO users (username, password) VALUES (?,?)",
        [username, password]);

    return Response.ok("Create Users Success");
  }

  Future<Response> editUser(Request req) async {
    var token = req.headers["authorization"];
    var verifyJWT = await auth.validateJWT(token.toString());
    if (!verifyJWT) {
      return Response.notFound("Error: Unauthorized");
    }

    var conn = await dbconn.connectSql();
    String bodyRequest = await req.readAsString();
    var data = json.decode(bodyRequest);

    var id = data["id"];
    var username = data["username"];
    var password = md5.convert(utf8.encode(data["password"])).toString();

    var findData = await conn.query("SELECT * FROM users WHERE id=?", [id]);
    if (findData.isEmpty) {
      return Response.notFound("Error: Data Not Found");
    }

    await conn.query("UPDATE users SET username=?, password=? WHERE id=?",
        [username, password, id]);

    return Response.ok("Update Users Success");
  }

  Future<Response> deleteUser(Request req) async {
    var token = req.headers["authorization"];
    var verifyJWT = await auth.validateJWT(token.toString());
    if (!verifyJWT) {
      return Response.notFound("Error: Unauthorized");
    }

    var conn = await dbconn.connectSql();
    String bodyRequest = await req.readAsString();
    var data = json.decode(bodyRequest);

    var id = data["id"];

    var findReport = await conn.query("SELECT * FROM users WHERE id=?", [id]);
    if (findReport.isEmpty) {
      return Response.notFound("Error: Data Not Found");
    }

    await conn.query("DELETE from users WHERE id=?", [id]);

    return Response.ok("Delete Users Success");
  }
}
