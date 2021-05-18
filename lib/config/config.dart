import 'package:mysql1/mysql1.dart';

final String envName = 'running-society-app-3cas7433972e'; // env id
final String appKey = 'deaac04436be838554c134dd72c95b3a'; // app access key
final String appVersion = '1'; // app access version

final int appId = 1400512118;
final String secretKey = '1aa1cc6c55d9884e9cb9f5007231899b60308ac217517f88f19ecfbece7aa26c';

final ConnectionSettings settings = new ConnectionSettings(
  host: 'bj-cdb-l99d54hu.sql.tencentcdb.com',
  port: 60735,
  user: 'root',
  password: 'sqap!slec3MISH2fa',
  db: 'running_society'
);

MySqlConnection? conn;

void initializeDBConnection() async {
  conn = await MySqlConnection.connect(settings);
  print('connected');
}
