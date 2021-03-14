import 'package:open_heimdall/ErrorNotificationRoute.dart';
import 'package:open_heimdall/PgDaoFactory.dart';
import 'package:open_heimdall/endpoint.dart';
import 'package:open_heimdall/HelloWorldRoute.dart';
import 'dart:io';

void main(List<String> arguments) {
  var endpoint = HeimdallEndpoint(PgDaoFactory());

  endpoint.getRoute('/', HelloWorldRoute);
  endpoint.postRoute('/v1/error', ErrorNotificationRoute);
  endpoint.start();

  ProcessSignal.sigint.watch().listen((ProcessSignal signal) {
    endpoint.stop();
  });
}
