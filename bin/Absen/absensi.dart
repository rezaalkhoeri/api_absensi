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

class Absensi {
  Future<Response> getAbsensi(Request req) async {
    var token = req.headers["authorization"];
    var verifyJWT = await auth.validateJWT(token.toString());
    if (!verifyJWT) {
      return Response.notFound("Error: Unauthorized");
    }

    var conn = await dbconn.connectSql();

    var sql =
        'SELECT absen.*, pegawai.nama, jabatan.jabatan, departemen.nama_departemen FROM absen JOIN pegawai ON absen.id_pegawai = pegawai.id JOIN departemen ON departemen.id = pegawai.id_dp JOIN jabatan ON jabatan.id = pegawai.id_jabatan';

    var getData = await conn.query(sql);

    return Response.ok(getData.toString());
  }

  Future<Response> absensiPegawai(Request req) async {
    var token = req.headers["authorization"];
    var verifyJWT = await auth.validateJWT(token.toString());
    if (!verifyJWT) {
      return Response.notFound("Error: Unauthorized");
    }

    var conn = await dbconn.connectSql();
    String bodyRequest = await req.readAsString();
    var data = json.decode(bodyRequest);

    var id_pegawai = data["id_pegawai"];
    var masuk = data["id_masuk"];
    var keluar = data["jam_keluar"];
    var tanggal = data["jam_masuk"];
    var status = data["status"];

    await conn.query(
        "INSERT INTO absen (id_pegawai, jam_masuk, jam_keluar, tanggal, status) VALUES (?,?,?,?,?)",
        [id_pegawai, masuk, keluar, tanggal, status]);

    return Response.ok("Insert Absensi Success");
  }
}
