import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  final String supabaseUrl;
  final String supabaseAnonKey;

  AppConfig({required this.supabaseUrl, required this.supabaseAnonKey});

  static Future<AppConfig> forEnvironment([String? env]) async {
    // set default to dev if nothing was passed
    env = env ?? 'dev';

    // hardcoded for now
    const supabaseUrl = "https://stukaubuhnosgjmtblwh.supabase.co";
    const supabaseAnonKey =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN0dWthdWJ1aG5vc2dqbXRibHdoIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODg5NTk2MzQsImV4cCI6MjAwNDUzNTYzNH0.0X8sdHTS_m2FyfwyT2nGsOSgcLbk8yWkwJ6Zdep2IJw";
    return AppConfig(
        supabaseUrl: supabaseUrl, supabaseAnonKey: supabaseAnonKey);

    // load the json file
    // final contents = await rootBundle.loadString(
    //   'assets/config/.env.$env.json',
    // );

    // decode our json
    // final json = jsonDecode(contents);

    // convert our JSON into an instance of our AppConfig class
    // return AppConfig(
    //     supabaseUrl: json['supabase']['url'],
    //     supabaseAnonKey: json['supabase']['anonKey']);
  }
}
