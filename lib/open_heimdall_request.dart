import 'dart:io';
import 'dart:convert';
import 'errorPost.dart';
import 'DaoFactory.dart';
import 'package:coruja/coruja.dart';
import 'package:googleapis_auth/auth_io.dart';

var _FCM_SEND_MESSAGE_URL = 'https://fcm.googleapis.com/v1/projects/_PROJECT_ID_/messages:send';

class OpenHeimdalRequestFactory implements CorujaJsonRequestFactory {
  final DaoFactory _daoFactory;
  late ServiceAccountCredentials _serviceAccountCredentials;

  OpenHeimdalRequestFactory(this._daoFactory, String firebaseKey) {
    var firebaseJson = json.decode(firebaseKey);
    _serviceAccountCredentials = ServiceAccountCredentials.fromJson(firebaseJson);
    _FCM_SEND_MESSAGE_URL = _FCM_SEND_MESSAGE_URL.replaceAll('_PROJECT_ID_', firebaseJson['project_id']);
  }

  @override
  CorujaRequest build(HttpRequest request, Map<String, String> routeParams) {
    return OpenHeimdallRequest(_daoFactory, _serviceAccountCredentials, request, routeParams);
  }
}

class OpenHeimdallRequest extends CorujaJsonRequest {
  final DaoFactory daoFactory;
  final ServiceAccountCredentials _serviceAccountCredentials;
  final List<String> _scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  OpenHeimdallRequest(this.daoFactory, this._serviceAccountCredentials, HttpRequest request, Map<String, String> routeParams) : super(request, routeParams);

  Future<Map<String, dynamic>> sendNotification(ErrorPost error) async {
    var fcmAuthClient = await clientViaServiceAccount(_serviceAccountCredentials, _scopes);

    var jsonContent = json.encode({
      'message': {
        'topic': error.program,
        'android': {
          'collapse_key': error.program,
          'notification': {
            'title': '${error.program}',
            'body': 'Erro em ${error.scope}',
            'sound': 'default',
            'notification_priority': 'PRIORITY_MAX',
            'channel_id': 'OpenHeimdallErrorsChannel'
          },
        },
      }
    });

    var response = await fcmAuthClient.post(
      Uri.parse(_FCM_SEND_MESSAGE_URL),
      body: jsonContent
    );
    return json.decode(response.body);
  }
}