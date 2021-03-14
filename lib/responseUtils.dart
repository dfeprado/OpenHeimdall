import 'dart:convert';
import 'dart:io';

class ResponseUtils {
  String generateErrorResponse(int code, String message, String type) {
    final error = {
      'code': code,
      'message': message,
      'type': type
    };
    return jsonEncode(error);
  }

  void sendErrorResponse(HttpRequest request, int code, String message, String type) {
    sendResponse(request, code, generateErrorResponse(code, message, type));
  }

  void sendResponse(HttpRequest request, int statusCode, String msg) {
    request.response.statusCode = statusCode;
    if (msg.isNotEmpty) {
      request.response.write(msg);
    }
    request.response.close();
  }
}