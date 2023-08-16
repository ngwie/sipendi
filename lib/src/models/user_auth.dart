import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'user_detail.dart';

class UserAuthModel extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  UserDetail? _userDetail;

  User? get user => _supabase.auth.currentUser;
  Session? get session => _supabase.auth.currentSession;
  UserDetail? get userDetail => _userDetail;

  bool get signedIn => session != null;

  Future<void> _assignUserDetail({dynamic data}) async {
    data ??= await _supabase.from('user').select().eq('id', user!.id);

    _userDetail = UserDetail(
        id: data[0]['id'],
        fullName: data[0]['full_name'],
        phone: data[0]['phone'],
        birthDate: DateTime.parse(data[0]['birth_date']),
        address: data[0]['address']);

    notifyListeners();
  }

  UserAuthModel() {
    if (signedIn) _assignUserDetail();
  }

  Future<void> signIn(String phone, String password) async {
    await _supabase.auth.signInWithPassword(phone: phone, password: password);
    await _assignUserDetail();
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    _userDetail = null;

    notifyListeners();
  }

  Future<void> signUp({
    required String fullName,
    required String phone,
    required String password,
    required String gender,
    required String birthDate,
    String? address,
    required String bodyHeight,
  }) async {
    await _supabase.auth.signUp(phone: phone, password: password);
    final data = await _supabase.from('user').insert({
      'id': user!.id,
      'full_name': fullName,
      'phone': phone,
      'gender': gender,
      'birth_date': DateFormat('dd-MM-yyyy').parse(birthDate).toIso8601String(),
      'address': address,
      'created_by': user!.id,
      'created_at': 'now()',
    }).select();
    await _supabase.from('medical_record').insert({
      'user_id': user!.id,
      'type': 'body_height',
      'value': bodyHeight,
      'created_by': user!.id,
      'created_at': 'now()',
    });

    await _assignUserDetail(data: data);
  }
}
