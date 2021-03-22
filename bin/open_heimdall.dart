import 'package:coruja/coruja.dart';
import 'package:open_heimdall/ErrorNotificationRoute.dart';
import 'package:open_heimdall/PgDaoFactory.dart';
import 'package:open_heimdall/HelloWorldRoute.dart';
import 'dart:io';

import 'package:open_heimdall/open_heimdall_request.dart';

void main(List<String> arguments) async {
  Map<String, String> envVars = Platform.environment;
  var firebase_key = envVars['OPENHEIMDALL_FIREBASE_KEY'];

  if (firebase_key == null) {
    print('Set OPENHEIMDALL_FIREBASE_KEY environment variable pointing to firebase key json');
    exit(1);
  }

  var keyFile = File(firebase_key);
  var firebase_key_content = await keyFile.readAsString();

  var endpoint = Coruja();
  endpoint.setRequestFactory(OpenHeimdalRequestFactory(PgDaoFactory(), firebase_key_content));

  endpoint.addPostRoute('/v1/error', PostErrorNotificationRoute);
  endpoint.addPostRoute('/v1/error/:program/:scope', PostErrorNotificationTest);
  endpoint.addGetRoute('/v1/error/:program', GetProgramErrorsRoute);
  endpoint.addGetRoute('/v1/error', GetErrorNotificationRoute);
  endpoint.addGetRoute('/', HelloWorldRoute);

  endpoint.listen();

  ProcessSignal.sigint.watch().listen((ProcessSignal signal) {
    endpoint.close();
  });
}
