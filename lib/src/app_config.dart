import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  final String supabaseUrl;
  final String supabaseAnonKey;

  AppConfig({required this.supabaseUrl, required this.supabaseAnonKey});

  static Future<AppConfig> forEnvironment([String? env]) async {
    // set default to dev if nothing was passed
    env = env ?? 'dev';

    // load the json file
    final contents = await rootBundle.loadString(
      'assets/config/.env.$env.json',
    );

    // decode our json
    final json = jsonDecode(contents);

    // convert our JSON into an instance of our AppConfig class
    return AppConfig(
        supabaseUrl: json['supabase']['url'],
        supabaseAnonKey: json['supabase']['anonKey']);
  }
}
