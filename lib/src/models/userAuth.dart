import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserAuthModel extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  User? get user => _supabase.auth.currentUser;
  Session? get session => _supabase.auth.currentSession;

  bool get signedIn => session != null;

  Future<void> signIn(String phone, String password) async {
    await _supabase.auth.signInWithPassword(phone: phone, password: password);

    notifyListeners();
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();

    notifyListeners();
  }

  Future<void> signUp(String phone, String password) async {
    await _supabase.auth.signUp(phone: phone, password: password);

    notifyListeners();
  }
}
