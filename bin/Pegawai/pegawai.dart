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

class Pegawai {
  Future<Response> getPegawai(Request req) async {
    var token = req.headers["authorization"];
    var verifyJWT = await auth.validateJWT(token.toString());
    if (!verifyJWT) {
      return Response.notFound("Error: Unauthorized");
    }

    var conn = await dbconn.connectSql();

    var getData = await conn.query("SELECT * FROM pegawai");

    return Response.ok(getData.toString());
  }

  Future<Response> insertPegawai(Request req) async {
    var token = req.headers["authorization"];
    var verifyJWT = await auth.validateJWT(token.toString());
    if (!verifyJWT) {
      return Response.notFound("Error: Unauthorized");
    }

    var conn = await dbconn.connectSql();
    String bodyRequest = await req.readAsString();
    var data = json.decode(bodyRequest);

    var id_dep = data["id_dp"];
    var id_jab = data["id_jabatan"];
    var tgl_masuk = data["tgl_mulai_kerja"];
    var nama = data["nama"];
    var ttl = data["ttl"];
    var alamat = data["alamat"];
    var status = data["status"];

    await conn.query(
        "INSERT INTO pegawai (id_dp, id_jabatan, tgl_mulai_kerja, nama, ttl, alamat, status ) VALUES (?,?,?,?,?,?,?)",
        [id_dep, id_jab, tgl_masuk, nama, ttl, alamat, status]);

    return Response.ok("Insert Pegawai Success");
  }

  Future<Response> editPegawai(Request req) async {
    var token = req.headers["authorization"];
    var verifyJWT = await auth.validateJWT(token.toString());
    if (!verifyJWT) {
      return Response.notFound("Error: Unauthorized");
    }

    var conn = await dbconn.connectSql();
    String bodyRequest = await req.readAsString();
    var data = json.decode(bodyRequest);

    var id = data["id"];
    var id_dep = data["id_dp"];
    var id_jab = data["id_jabatan"];
    var tgl_masuk = data["tgl_mulai_kerja"];
    var nama = data["nama"];
    var ttl = data["ttl"];
    var alamat = data["alamat"];
    var status = data["status"];

    var findData = await conn.query("SELECT * FROM pegawai WHERE id=?", [id]);
    if (findData.isEmpty) {
      return Response.notFound("Error: Data Not Found");
    }

    await conn.query(
        "UPDATE pegawai SET id_dp=?, id_jabatan=? , tgl_mulai_kerja=?, nama=?, ttl=?, alamat=?, status=? WHERE id=?",
        [id_dep, id_jab, tgl_masuk, nama, ttl, alamat, status, id]);

    return Response.ok("Update Pegawai Success");
  }

  Future<Response> deletePegawai(Request req) async {
    var token = req.headers["authorization"];
    var verifyJWT = await auth.validateJWT(token.toString());
    if (!verifyJWT) {
      return Response.notFound("Error: Unauthorized");
    }

    var conn = await dbconn.connectSql();
    String bodyRequest = await req.readAsString();
    var data = json.decode(bodyRequest);

    var id = data["id"];

    var findReport = await conn.query("SELECT * FROM pegawai WHERE id=?", [id]);
    if (findReport.isEmpty) {
      return Response.notFound("Error: Data Not Found");
    }

    await conn.query("DELETE from pegawai WHERE id=?", [id]);

    return Response.ok("Delete Pegawai Success");
  }
}
