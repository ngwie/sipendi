import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../utils/string_validation.dart';
import '../models/user_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswordScreen> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atur Ulang Sandi'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: _changePasswordForm(context),
        ),
      ),
    );
  }

  Widget _changePasswordForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            controller: _passwordController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Kata Sandi Baru',
            ),
            validator: (value) => StringValidation.isEmpty(value)
                ? 'Kata sandi tidak boleh kosong'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            controller: _confirmPasswordController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ulangi Kata Sandi Baru',
            ),
            validator: (value) => StringValidation.isEmpty(value)
                ? 'Kata sandi tidak boleh kosong'
                : _passwordController.value.text != value
                    ? 'Kata sandi tidak sama'
                    : null,
          ),
          const SizedBox(height: 16),
          Consumer<UserAuthModel>(
            builder: (context, model, child) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () async {
                if (_isLoading) return;
                if (!_formKey.currentState!.validate()) return;

                try {
                  setState(() {
                    _isLoading = true;
                  });

                  await model.resetPassword(
                    password: _passwordController.value.text,
                  );

                  if (context.mounted) {
                    context.go('/');
                  }
                } on AuthException catch (error) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(error.message),
                      behavior: SnackBarBehavior.floating,
                    ));
                  }
                } catch (error) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(error.toString()),
                      behavior: SnackBarBehavior.floating,
                    ));
                  }
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Color(0xFFEEF9BF),
                      ),
                    )
                  : const Text('Ubah Kata Sandi'),
            ),
          ),
        ],
      ),
    );
  }
}
