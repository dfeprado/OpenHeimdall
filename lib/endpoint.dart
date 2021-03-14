import 'dart:io';
import 'package:open_heimdall/DaoFactory.dart';
import 'package:open_heimdall/responseUtils.dart';

typedef EndpointRouteFn = void Function(HttpRequest request, DaoFactory daoFactory, ResponseUtils responseUtils);

class HeimdallEndpoint {
  HttpServer _server;
  final DaoFactory daoFactory;
  final _responseUtils = ResponseUtils();
  final Map<String, EndpointRouteFn> _getRoutes = {};
  final Map<String, EndpointRouteFn> _postRoutes = {};

  HeimdallEndpoint(this.daoFactory);

  void getRoute(String path, EndpointRouteFn routeFunction) {
    if (_getRoutes.containsKey(path)) {
      _getRoutes.remove(path);
    }
    _getRoutes[path] = routeFunction;
  }

  void postRoute(String path, EndpointRouteFn routeFunction) {
    if (_postRoutes.containsKey(path)) {
      _postRoutes.remove(path);
    }
    _postRoutes[path] = routeFunction;
  }

  void _setRouteNotFoundResponse(HttpRequest request) {
    request.response
      ..statusCode = 404
      ..close();
  }

  void _onRequest(HttpRequest request) {
    Map<String, EndpointRouteFn> routes;

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
      if (routePath == path) {
        try {
          routes[routePath](request, daoFactory, _responseUtils);
        } catch(e) {
          _responseUtils.sendErrorResponse(request, 500, e.toString(), 'InternalServer');
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