import 'dart:io';

class HeimdallEndpoint {
  HttpServer _server;
  void _onRequest(HttpRequest request) {
    print('A new ${request.method} request was received!');
    request.response.statusCode = 200;
    request.response.close();
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