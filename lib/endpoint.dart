import 'dart:io';
import 'dart:convert';
import 'errorPost.dart';
import 'errorNotificationDao.dart';

class HeimdallEndpoint {
  HttpServer _server;
  final ErrorNotificationDao errorDao;

  HeimdallEndpoint(this.errorDao);

  String _formatError(int code, String message, String type) {
    final error = {
      'code': code,
      'message': message,
      'type': type
    };
    return jsonEncode(error);
  }

  void _onRequest(HttpRequest request) {
    print('A new ${request.method} request was received!');
    if (request.method == 'GET') {
      request.response.statusCode = 200;
      request.response..
        write('Hello World!')..
        close();
    }
    else if (request.method == 'POST' && request.headers.contentType?.mimeType == 'application/json') {
      utf8.decoder.bind(request).listen((String content) {
        try {
          var receivedError = ErrorPost.fromJson(content);
          errorDao.save(receivedError);
          request.response
            ..statusCode = 200
            ..close();
        }
        catch (e) {
          request.response
            ..statusCode = 400
            ..write(_formatError(400, e.toString(), 'FormatException'))
            ..close();
        }
      });
    }
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