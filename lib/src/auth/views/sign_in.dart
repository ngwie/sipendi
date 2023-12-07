import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_auth.dart';
import '../../utils/string_validation.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            const SizedBox(height: 40),
            Text(
              'Pendamping Diabetes',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 40),
            _signInForm(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Tidak punya akun?'),
                TextButton(
                  child: const Text('Daftar di sini'),
                  onPressed: () => context.pushReplacement('/register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _signInForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Silakan Masuk',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Nomor HP',
            ),
            validator: (value) => StringValidation.isEmpty(value)
                ? 'Nomor Hp tidak boleh kosong'
                : (!StringValidation.isValidPhone(value))
                    ? 'Format nomor Hp salah, coba dengan format 0812xxxxx'
                    : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            controller: _passwordController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Kata Sandi',
            ),
            validator: (value) => StringValidation.isEmpty(value)
                ? 'Password tidak boleh kosong'
                : null,
          ),
          const SizedBox(height: 16),
          Consumer<UserAuthModel>(
            builder: (context, model, child) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Color(0xFFEEF9BF),
                        ),
                      )
                    : const Text('Masuk'),
                onPressed: () async {
                  if (_isLoading) return;
                  if (!_formKey.currentState!.validate()) return;

                  setState(() {
                    _isLoading = true;
                  });

                  try {
                    final phone = _phoneController.value.text
                        .trim()
                        .replaceFirst(RegExp(r'^0'), '62');
                    final password = _passwordController.value.text;
                    await model.signIn(phone, password);

                    if (context.mounted) {
                      context.pushReplacement('/');
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
                  }

                  setState(() {
                    _isLoading = false;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
