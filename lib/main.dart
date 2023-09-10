import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sipendi/src/app.dart';
import 'package:sipendi/src/app_config.dart';
import 'package:sipendi/src/models/user_auth.dart';
import 'package:sipendi/src/utils/sqlite_db.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = await AppConfig.forEnvironment();
  await Supabase.initialize(
      url: config.supabaseUrl, anonKey: config.supabaseAnonKey);

  await SqliteDb.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserAuthModel()),
      ],
      child: const App(),
    ),
  );
}
