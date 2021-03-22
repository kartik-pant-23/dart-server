import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class UsersApi {
  Router get router {
    final router = Router();
    router.post("/login", (Request request) async {
      var body = json.decode(await request.readAsString());
      body["message"] = "Returned from API";
      return Response.ok(json.encode(body),
          headers: {"Content-Type": "application/json"});
    });
    return router;
  }
}
