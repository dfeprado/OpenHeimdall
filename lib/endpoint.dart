import 'dart:io';
import 'package:open_heimdall/DaoFactory.dart';
import 'package:open_heimdall/openHeimdallRequest.dart';

typedef EndpointRouteFn = void Function(OpenHeimdallRequest request);

class _RoutePattern {
  final _params = List<String>.empty(growable: true);
  RegExp _pattern;

  _RoutePattern(String path) {
    // 1. Separa os nomes dos parâmetros
    path = path.toLowerCase();
    var paramsPattern = RegExp(r':([a-z0-9]+)');
    var matches = paramsPattern.allMatches(path);

    for (var match in matches) {
      _params.add(match[1]);
    }

    // 2. Converte o caminho para um RoutePattern
    path = path.replaceAll(RegExp(r':[a-z0-9]+'), '([a-zA-Z0-9]+)');
    _pattern = RegExp('^' + path);
  }
}

class HeimdallEndpoint {
  HttpServer _server;
  final DaoFactory daoFactory;
  final Map<_RoutePattern, EndpointRouteFn> _getRoutes = {};
  final Map<_RoutePattern, EndpointRouteFn> _postRoutes = {};

  HeimdallEndpoint(this.daoFactory);

  void getRoute(String path, EndpointRouteFn routeFunction) {
    if (_getRoutes.containsKey(path)) {
      _getRoutes.remove(path);
    }
    _getRoutes[_RoutePattern(path)] = routeFunction;
  }

  void postRoute(String path, EndpointRouteFn routeFunction) {
    if (_postRoutes.containsKey(path)) {
      _postRoutes.remove(path);
    }
    _postRoutes[_RoutePattern(path)] = routeFunction;
  }

  void _setRouteNotFoundResponse(HttpRequest request) {
    request.response
      ..statusCode = 404
      ..close();
  }

  void _onRequest(HttpRequest request) {
    Map<_RoutePattern, EndpointRouteFn> routes;

    if (request.method == 'GET') {
      routes = _getRoutes;
    }
    else if (request.method == 'POST') {
      routes = _postRoutes;
    }
    else {
      _setRouteNotFoundResponse(request);
      return;
    }

    var path = request.uri.toString();
    for (var routePath in routes.keys) {
      var match = routePath._pattern.firstMatch(path);
      if (match != null) {
        try {
          routes[routePath](OpenHeimdallRequest(request, RouteParams(routePath._params, match), daoFactory));
        } catch(e) {
          request.response
            ..statusCode = 404
            ..close();
        }
        return;
      }
    }

    _setRouteNotFoundResponse(request);
  }

  void start() async {
    var _server = await HttpServer.bind(InternetAddress.anyIPv4, 8881);
    print('Open Heimdall binds with ${_server.address}:${_server.port}');
    _server.listen(_onRequest);
  }

  void stop() async {
    print('Open Heimdall is stopping');
    await _server.close(force: true);
  }
}