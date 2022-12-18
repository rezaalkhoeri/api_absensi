import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql1/mysql1.dart';

class Connection {
  Future<MySqlConnection> connectSql() async {
    var settings = ConnectionSettings(
        host: '127.0.0.1',
        port: 3306,
        user: 'user_absensi',
        password: 'password',
        db: 'absensi_pegawai');

    var conn = await MySqlConnection.connect(settings);

    return conn;

    // var results = await conn.query('select * from admin', []);
    // return Response.ok(results.toString());
  }
}
