import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_function/cloudbase_function.dart';
import 'config.dart';

CloudBaseCore core = CloudBaseCore.init({
  'env': envName,
  'appAccess': {
    'key': appKey,
    'version': appVersion
  }
});

CloudBaseAuth auth = CloudBaseAuth(core);

CloudBaseFunction cloudBaseFunction = CloudBaseFunction(core);
