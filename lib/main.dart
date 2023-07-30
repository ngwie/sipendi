import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sipendi/src/app.dart';
import 'package:sipendi/src/app_config.dart';
import 'package:sipendi/src/models/userAuth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = await AppConfig.forEnvironment();
  await Supabase.initialize(
      url: config.supabaseUrl, anonKey: config.supabaseAnonKey);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserAuthModel()),
      ],
      child: const App(),
    ),
  );
}
