import 'errorNotificationDao.dart';
import 'errorPost.dart';
import 'package:postgres/postgres.dart';

class PgErrorNotificationDao extends ErrorNotificationDao {
  Future<PostgreSQLConnection> _getConnection({bool opened = false}) async {
    var connection = PostgreSQLConnection('market-db.danielprado.dev', 10031, 'open_heimdall', username: 'dfeprado', password: 'dia290193');
    if (opened) {
      await connection.open();
    }

    return connection;
  }

  final _SQL_SAVE_ERROR = 
    'insert into notified_errors (datetime, program, scope, type, message) '
    'values (@datetime::timestamp, @program, @scope, @type, @message)';

  @override
  Future<int> save(ErrorPost error) async {
    var connection = await _getConnection(opened: true);
    return await connection.execute(
      _SQL_SAVE_ERROR, 
      substitutionValues: {'datetime': error.timestamp, 'program': error.program, 'scope': error.scope, 'type': error.type, 'message': error.message}
    );
  }
}