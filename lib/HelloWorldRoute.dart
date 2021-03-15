import 'package:open_heimdall/openHeimdallRequest.dart';

Function HelloWorldRoute = (OpenHeimdallRequest request) {
  request.sendOk(body: 'Hello World!');
};