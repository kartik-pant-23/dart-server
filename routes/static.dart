import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class Static {
  Router get router {
    final router = Router();

    router.get('/', (request) async {
      return Response.ok(await File("build/index.html").openRead(),
          headers: {"Content-type": "text/html"});
    });

    router.get('/packages', (request) async {
      return Response.ok(await File("build/packages.html").openRead(),
          headers: {"Content-type": "text/html"});
    });

    router.get('/login', (request) async {
      return Response.ok(await File("build/login.html").openRead(),
          headers: {"Content-type": "text/html"});
    });

    return router;
  }
}
