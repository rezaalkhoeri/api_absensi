import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql1/mysql1.dart';

class HelloWorld {
  Response rootHandler(Request request) {
    return Response.ok('Hello, World!\n');
  }
}
