import 'dart:convert';
import 'dart:io';
import 'package:open_heimdall/DaoFactory.dart';
import 'package:open_heimdall/errorPost.dart';
import 'package:open_heimdall/responseUtils.dart';

Function ErrorNotificationRoute = (HttpRequest request, DaoFactory daoFactory, ResponseUtils responseUtils) {
    if (request.headers.contentType?.mimeType != 'application/json') {
      responseUtils.sendErrorResponse(request, 400, 'Unknown body format', 'Bad Request');
    }

    var errorDao = daoFactory.getErrorNotificationDao();
    
    utf8.decoder.bind(request).listen((String content) {
      try {
        var receivedError = ErrorPost.fromJson(content);
        errorDao.save(receivedError);
        request.response
          ..statusCode = 200
          ..close();
      }
      catch (e) {
        responseUtils.sendErrorResponse(request, 400, e.toString(), 'FormatException');
      }
    });
};