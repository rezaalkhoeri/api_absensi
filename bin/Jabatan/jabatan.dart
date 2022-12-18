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

class Jabatan {
  Future<Response> getJabatan(Request req) async {
    var token = req.headers["authorization"];
    var verifyJWT = await auth.validateJWT(token.toString());
    if (!verifyJWT) {
      return Response.notFound("Error: Unauthorized");
    }

    var conn = await dbconn.connectSql();

    var getData = await conn.query("SELECT * FROM jabatan");

    return Response.ok(getData.toString());
  }

  Future<Response> insertJabatan(Request req) async {
    var token = req.headers["authorization"];
    var verifyJWT = await auth.validateJWT(token.toString());
    if (!verifyJWT) {
      return Response.notFound("Error: Unauthorized");
    }

    var conn = await dbconn.connectSql();
    String bodyRequest = await req.readAsString();
    var data = json.decode(bodyRequest);

    var jabatan = data["jabatan"];

    await conn.query("INSERT INTO jabatan (jabatan) VALUES (?)", [jabatan]);

    return Response.ok("Insert Jabatan Success");
  }

  Future<Response> editJabatan(Request req) async {
    var token = req.headers["authorization"];
    var verifyJWT = await auth.validateJWT(token.toString());
    if (!verifyJWT) {
      return Response.notFound("Error: Unauthorized");
    }

    var conn = await dbconn.connectSql();
    String bodyRequest = await req.readAsString();
    var data = json.decode(bodyRequest);

    var id = data["id"];
    var jabatan = data["jabatan"];

    var findData = await conn.query("SELECT * FROM jabatan WHERE id=?", [id]);
    if (findData.isEmpty) {
      return Response.notFound("Error: Data Not Found");
    }

    await conn.query("UPDATE jabatan SET jabatan=?  WHERE id=?", [jabatan, id]);

    return Response.ok("Update Jabatan Success");
  }

  Future<Response> deleteJabatan(Request req) async {
    var token = req.headers["authorization"];
    var verifyJWT = await auth.validateJWT(token.toString());
    if (!verifyJWT) {
      return Response.notFound("Error: Unauthorized");
    }

    var conn = await dbconn.connectSql();
    String bodyRequest = await req.readAsString();
    var data = json.decode(bodyRequest);

    var id = data["id"];

    var findReport = await conn.query("SELECT * FROM jabatan WHERE id=?", [id]);
    if (findReport.isEmpty) {
      return Response.notFound("Error: Data Not Found");
    }

    await conn.query("DELETE from jabatan WHERE id=?", [id]);

    return Response.ok("Delete Jabatan Success");
  }
}
