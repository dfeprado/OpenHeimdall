import 'package:coruja/coruja.dart';

void HelloWorldRoute(CorujaRequest request) {
  request.writeResponse(content: 'Hello World!');
}