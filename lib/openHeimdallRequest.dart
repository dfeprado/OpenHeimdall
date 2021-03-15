import 'dart:io';
import 'dart:convert';
import 'package:open_heimdall/DaoFactory.dart';

class RouteParams {
  final _params = <String, String>{};

  RouteParams(List<String> paramNames, RegExpMatch paramValues) {
    for (var i = 0; i < paramNames.length; i++) {
      _params[paramNames[i]] = paramValues.group(i + 1);
    }
  }

  String operator [](String paramName) {
    return _params[paramName];
  }
}

class OpenHeimdallRequest {
  final HttpRequest _request;
  final RouteParams param;
  final DaoFactory daoFactory;

  OpenHeimdallRequest(this._request, this.param, this.daoFactory);

  void sendOk({String body = ''}) {
    _request.response
      ..statusCode = 200
      ..write(body)
      ..close();
  }

  void sendRequestBadFormat({String body = ''}) {
    _request.response
      ..statusCode = 400
      ..write(body)
      ..close();
  }

  Future<String> get body async {
    var result = StringBuffer();
    await for (var chunk in utf8.decoder.bind(_request)) {
      result.write(chunk);
    }
    return result.toString();
  }

  HttpHeaders get headers => _request.headers;
}