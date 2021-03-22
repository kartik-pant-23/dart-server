import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

import 'routes/packages.dart';
import 'routes/users.dart';
import 'routes/static.dart';

class ApiService {
  Handler get handler {
    final router = Router();
    router.mount('/api/packages/', PackagesApi().router);
    router.mount('/users/', UsersApi().router);
    router.mount('/', Static().router);
    return router;
  }
}

Future main() async {
  var staticHandler =
      createStaticHandler("build", defaultDocument: "index.html");

  final service = ApiService();

  var handler = Cascade().add(staticHandler).add(service.handler).handler;

  var server = await io.serve(handler, "localhost", 4000);
  server.autoCompress = true;

  print("Serving website at http://${server.address.host}:${server.port}");
  printAllApis(server.address.host, server.port);
}

void printAllApis(host, port) {
  print("[GET]  http://$host:$port/api/packages/");
  print("[GET]  http://$host:$port/api/packages/?name=<query>");
  print("[GET]  http://$host:$port/api/packages/<NAME>");
  print("[GET]  http://$host:$port/api/packages/<NAME>/version/<VERSION>");
  print("[POST] http://$host:$port/users/login");
}
