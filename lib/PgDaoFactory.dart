import 'package:open_heimdall/DaoFactory.dart';
import 'package:open_heimdall/ErrorNotificationDao.dart';
import 'package:open_heimdall/pgErrorNotificationDao.dart';

class PgDaoFactory extends DaoFactory {
  @override
  ErrorNotificationDao getErrorNotificationDao() {
    return PgErrorNotificationDao();
  }
}