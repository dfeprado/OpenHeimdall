import 'dart:convert';
import 'package:open_heimdall/errorPost.dart';
import 'package:open_heimdall/openHeimdallRequest.dart';

Function PostErrorNotificationRoute = (OpenHeimdallRequest request) async {
    if (request.headers.contentType?.mimeType != 'application/json') {
      request.sendRequestBadFormat();
    }

    var errorDao = request.daoFactory.getErrorNotificationDao();
    var body = await request.body;
    try {
      var receivedError = ErrorPost.fromJson(body);
      await errorDao.save(receivedError);
      request.sendOk();
    }
    catch (e) {
      request.sendRequestBadFormat(body: 'Format Exception');
    }
};

Function GetErrorNotificationRoute = (OpenHeimdallRequest request) async {
  var errorDao = request.daoFactory.getErrorNotificationDao();
  var errorList = await errorDao.getAll();
  request.sendOk(body: jsonEncode(errorList));
};

Function GetProgramErrorsRoute = (OpenHeimdallRequest request) async {
  var errorList = await request.daoFactory.getErrorNotificationDao().getAllFrom(request.param['program']);
  request.sendOk(body: jsonEncode(errorList));
};