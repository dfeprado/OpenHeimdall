import 'dart:convert';
import 'package:coruja/coruja.dart';

import 'errorPost.dart';
import 'open_heimdall_request.dart';

void PostErrorNotificationRoute(CorujaRequest request) async {
  try {
    var receivedError = ErrorPost.fromJson(await request.body);
    var errorDao = (request as OpenHeimdallRequest).daoFactory.getErrorNotificationDao();
    await errorDao.save(receivedError);
    request.writeResponse();
  } on FormatException catch(e) {
    request.writeResponse(code: 400, content: '$e');
  }
}

void GetErrorNotificationRoute(CorujaRequest request) async {
  var errorDao = (request as OpenHeimdallRequest).daoFactory.getErrorNotificationDao();
  var errorList = await errorDao.getAll();
  request.writeResponse(content: jsonEncode(errorList));
}

void GetProgramErrorsRoute(CorujaRequest request) async {
  var errorList = await (request as OpenHeimdallRequest)
    .daoFactory
    .getErrorNotificationDao()
    .getAllFrom(request.routeParams['program']!);
  request.writeResponse(content: jsonEncode(errorList));
}

void PostErrorNotificationTest(CorujaRequest request) async {
  var error = ErrorPost(DateTime.now(), request.routeParams['program']!, request.routeParams['scope']!, 'testing', 'testing');
  var fcmResponse = await (request as OpenHeimdallRequest).sendNotification(error);
  if (fcmResponse['error'] != null) {
    request.writeResponse(code: fcmResponse['error']['code'], content: json.encode(fcmResponse));
  }
  else {
    request.writeResponse(code: 200);
  }
}