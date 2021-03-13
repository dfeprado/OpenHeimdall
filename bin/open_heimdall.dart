import 'package:open_heimdall/endpoint.dart';
import 'package:open_heimdall/pgErrorNotificationDao.dart';
import 'dart:io';

void main(List<String> arguments) {
  var endpoint = HeimdallEndpoint(PgErrorNotificationDao());
  endpoint.start();

  ProcessSignal.sigint.watch().listen((ProcessSignal signal) {
    endpoint.stop();
  });
}
