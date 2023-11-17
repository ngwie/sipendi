import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/app.dart';
import 'src/models/user_auth.dart';
import 'src/utils/config.dart';
import 'src/utils/sqlite_db.dart';
import 'src/utils/alarm_notification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Config.loadEnvVariables();

  await SqliteDb.initialize();
  await AlarmNotification.initialize();
  await Supabase.initialize(
    url: Config.value.supabaseUrl,
    anonKey: Config.value.supabaseAnonKey,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserAuthModel()),
      ],
      child: const App(),
    ),
  );
}
