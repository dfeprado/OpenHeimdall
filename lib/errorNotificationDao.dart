import 'errorPost.dart';

abstract class ErrorNotificationDao {
  Future<int> save(ErrorPost error);
  Future<List<ErrorPost>> getAll();
  Future<List<ErrorPost>> getAllFrom(String program);
}