import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'Absen/absensi.dart';
import 'Departemen/departemen.dart';
import 'Jabatan/jabatan.dart';
import 'Pegawai/pegawai.dart';
import 'User/user.dart';
import 'db_connection.dart';
import 'Auth/auth.dart';

final Connection dbconn = Connection();
final Auth auth = Auth();
final User user = User();
final Pegawai pegawai = Pegawai();
final Jabatan jabatan = Jabatan();
final Departemen departemen = Departemen();
final Absensi absensi = Absensi();

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/sql', dbconn.connectSql)
  ..post('/login', auth.login)

  // Master User
  ..get('/getUser', user.getUser)
  ..post('/insertUser', user.insertUser)
  ..patch('/editUser', user.editUser)
  ..delete('/deleteUser', user.deleteUser)

  // Master Pegawai
  ..get('/getPegawai', pegawai.getPegawai)
  ..post('/insertPegawai', pegawai.insertPegawai)
  ..patch('/editPegawai', pegawai.editPegawai)
  ..delete('/deletePegawai', pegawai.deletePegawai)

  // Master Jabatan
  ..get('/getJabatan', jabatan.getJabatan)
  ..post('/insertJabatan', jabatan.insertJabatan)
  ..patch('/editJabatan', jabatan.editJabatan)
  ..delete('/deleteJabatan', jabatan.deleteJabatan)

  // Master Departemen
  ..get('/getDepartemen', departemen.getDepartemen)
  ..post('/insertDepartemen', departemen.insertDepartemen)
  ..patch('/editDepartemen', departemen.editDepartemen)
  ..delete('/deleteDepartemen', departemen.deleteDepartemen)

  // TRX Absensi
  ..get('/getAbsensi', absensi.getAbsensi)
  ..post('/absensiPegawai', absensi.absensiPegawai);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final _handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '3000');
  final server = await serve(_handler, ip, port);
  print('Server listening on port ${server.port}');
}
