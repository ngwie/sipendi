import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sipendi/src/models/user_auth.dart';
import 'package:sipendi/src/utils/string_validation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Pendamping Diabetes',
                  style: TextStyle(fontSize: 24.0, color: Color(0xFF75B79E)),
                ),
                const SizedBox(height: 36),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Silakan Masuk',
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF75B79E)),
                    ),
                    const SizedBox(height: 18),
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
                    const SizedBox(height: 18),
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
                    const SizedBox(height: 18),
                    Consumer<UserAuthModel>(
                      builder: (context, model, child) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              backgroundColor: const Color(0xFF75B79E)),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFEEF9BF),
                                  ),
                                )
                              : const Text(
                                  'Masuk',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFEEF9BF)),
                                ),
                          onPressed: () async {
                            if (_isLoading) return;
                            if (!_formKey.currentState!.validate()) return;

                            try {
                              setState(() {
                                _isLoading = true;
                              });

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
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(error.message),
                                  behavior: SnackBarBehavior.floating,
                                ));
                              }
                            } catch (error) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Unexpected error occurred'),
                                  behavior: SnackBarBehavior.floating,
                                ));
                              }
                            }

                            setState(() {
                              _isLoading = true;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Tidak punya akun?'),
                    TextButton(
                        onPressed: () {
                          context.pushReplacement('/register');
                        },
                        child: const Text('Daftar di sini'))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
