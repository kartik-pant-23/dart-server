import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class PackagesApi {
  final List packages_data =
      json.decode(File('packages.json').readAsStringSync());

  Router get router {
    final router = Router();

    router.get('/', (Request request) async {
      var name = request.requestedUri.queryParameters['name'];
      if (name == null || name.isEmpty) {
        return Response.ok(json.encode(packages_data),
            headers: {'Content-Type': 'application/json'});
      }

      final packages = packages_data
          .where((package) => package['name'].contains(name))
          .toList();

      return Response.ok(json.encode(packages),
          headers: {'Content-Type': 'application/json'});
    });

    router.get('/download', (Request request) async {
      return Response.ok(await File('packages.json').readAsString(), headers: {
        "Content-type": "application/octet-stream",
        "Content-Disposition": 'attachment; filename="packages.json"'
      });
    });

    router.get('/<name>', (Request request, String name) {
      print("Packages API request!");
      final package = packages_data
          .firstWhere((package) => package['name'] == name, orElse: () => null);

      if (package != null) {
        return Response.ok(json.encode(package),
            headers: {'Content-Type': 'application/json'});
      }

      return Response.notFound("${name} Package not found");
    });

    router.get('/<name>/version/<number>',
        (Request request, String name, String version) {
      print("Packages API request!");
      final package = packages_data
          .firstWhere((package) => package['name'] == name, orElse: () => null);

      if (package != null) {
        List versions = package['versions'];
        final versionDetail = versions.firstWhere(
            (versionDetail) => versionDetail['version'] == version,
            orElse: () => null);

        if (versionDetail != null) {
          var info = {
            "version": versionDetail['version'],
            "archive_url": versionDetail['archive_url']
          };
          return Response.ok(json.encode(info),
              headers: {'Content-Type': 'application/json'});
        }

        return Response.notFound("${name}:${version} package not found");
      }

      return Response.notFound("'${name}' package not found");
    });

    return router;
  }
}
