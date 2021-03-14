import 'dart:io';
import 'package:open_heimdall/DaoFactory.dart';
import 'package:open_heimdall/responseUtils.dart';

Function HelloWorldRoute = (HttpRequest request, DaoFactory daoFactory, ResponseUtils responseUtils) {
  responseUtils.sendResponse(request, 200, 'Hello World!');
};