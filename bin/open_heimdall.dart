import 'package:open_heimdall/endpoint.dart';
import 'dart:io';

void main(List<String> arguments) {
  var endpoint = HeimdallEndpoint();
  endpoint.start();

  ProcessSignal.sigint.watch().listen((ProcessSignal signal) {
    endpoint.stop();
  });
}
