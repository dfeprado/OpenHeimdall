import 'package:open_heimdall/ErrorNotificationRoute.dart';
import 'package:open_heimdall/PgDaoFactory.dart';
import 'package:open_heimdall/endpoint.dart';
import 'package:open_heimdall/HelloWorldRoute.dart';
import 'dart:io';

void main(List<String> arguments) {
  var endpoint = HeimdallEndpoint(PgDaoFactory());

  endpoint.postRoute('/v1/error', PostErrorNotificationRoute);

  endpoint.getRoute('/v1/error/:program', GetProgramErrorsRoute);
  endpoint.getRoute('/v1/error', GetErrorNotificationRoute);
  endpoint.getRoute('/', HelloWorldRoute);
  endpoint.start();

  ProcessSignal.sigint.watch().listen((ProcessSignal signal) {
    endpoint.stop();
  });
}
