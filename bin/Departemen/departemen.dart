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

final Connection dbconn = Connection();
final Auth auth = Auth();

class Departemen {
  Future<Response> getDepartemen(Request req) async {
    var token = req.headers["authorization"];
    var verifyJWT = await auth.validateJWT(token.toString());
    if (!verifyJWT) {
      return Response.notFound("Error: Unauthorized");
    }

    var conn = await dbconn.connectSql();

    var getData = await conn.query("SELECT * FROM departemen");

    return Response.ok(getData.toString());
  }

  Future<Response> insertDepartemen(Request req) async {
    var token = req.headers["authorization"];
    var verifyJWT = await auth.validateJWT(token.toString());
    if (!verifyJWT) {
      return Response.notFound("Error: Unauthorized");
    }

    var conn = await dbconn.connectSql();
    String bodyRequest = await req.readAsString();
    var data = json.decode(bodyRequest);

    var departemen = data["departemen"];

    await conn.query(
        "INSERT INTO departemen (nama_departemen) VALUES (?)", [departemen]);

    return Response.ok("Insert Departemen Success");
  }

  Future<Response> editDepartemen(Request req) async {
    var token = req.headers["authorization"];
    var verifyJWT = await auth.validateJWT(token.toString());
    if (!verifyJWT) {
      return Response.notFound("Error: Unauthorized");
    }

    var conn = await dbconn.connectSql();
    String bodyRequest = await req.readAsString();
    var data = json.decode(bodyRequest);

    var id = data["id"];
    var departemen = data["nama_departemen"];

    var findData =
        await conn.query("SELECT * FROM departemen WHERE id=?", [id]);
    if (findData.isEmpty) {
      return Response.notFound("Error: Data Not Found");
    }

    await conn.query(
        "UPDATE departemen SET nama_departemen=? WHERE id=?", [departemen, id]);

    return Response.ok("Update Departemen Success");
  }

  Future<Response> deleteDepartemen(Request req) async {
    var token = req.headers["authorization"];
    var verifyJWT = await auth.validateJWT(token.toString());
    if (!verifyJWT) {
      return Response.notFound("Error: Unauthorized");
    }

    var conn = await dbconn.connectSql();
    String bodyRequest = await req.readAsString();
    var data = json.decode(bodyRequest);

    var id = data["id"];

    var findReport =
        await conn.query("SELECT * FROM departemen WHERE id=?", [id]);
    if (findReport.isEmpty) {
      return Response.notFound("Error: Data Not Found");
    }

    await conn.query("DELETE from departemen WHERE id=?", [id]);

    return Response.ok("Delete Departemen Success");
  }
}
