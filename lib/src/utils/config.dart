import 'dart:convert';
import 'package:flutter/services.dart';

class Config {
  Config._constructor({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
  });

  final String supabaseUrl;
  final String supabaseAnonKey;

  static Config? _value;

  static Config get value {
    if (_value != null) return _value!;

    throw StateError('Ensure you have loaded the variable');
  }

  static Future<void> loadEnvVariables([String? env = 'dev']) async {
    // load the json file
    final contents = await rootBundle.loadString(
      'assets/config/.env.$env.json',
    );

    // decode our json
    final json = jsonDecode(contents);

    // convert our JSON into an instance of our AppConfig class
    _value = Config._constructor(
      supabaseUrl: json['supabase']['url'],
      supabaseAnonKey: json['supabase']['anonKey'],
    );
  }
}
