import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sipendi/src/models/userAuth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 18),
                    const Text(
                      'Registrasi Akun',
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF75B79E)),
                    ),
                    const SizedBox(height: 18),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nama Lengkap',
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nomor HP',
                        hintText: '621212xxxxxx',
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Kata Sandi',
                      ),
                    ),
                    const SizedBox(height: 18),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Tanggal Lahir',
                      ),
                    ),
                    const SizedBox(height: 18),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Tinggi Bandan',
                      ),
                    ),
                    const SizedBox(height: 18),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Jenis Kelamin',
                      ),
                    ),
                    const SizedBox(height: 18),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Alamat',
                      ),
                    ),
                    const SizedBox(height: 18),
                    Consumer<UserAuthModel>(
                      builder: (context, model, child) => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: const Color(0xFF75B79E)),
                        onPressed: () async {
                          try {
                            await model.signUp(_phoneController.value.text,
                                _passwordController.value.text);

                            if (context.mounted) {
                              context.pushReplacement('/login');
                            }
                          } on AuthException catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(error.message),
                              behavior: SnackBarBehavior.floating,
                            ));
                          } catch (error) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Unexpected error occurred'),
                              behavior: SnackBarBehavior.floating,
                            ));
                          }
                        },
                        child: const Text(
                          'Daftar',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFEEF9BF)),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Sudah punya akun'),
                    TextButton(
                        onPressed: () {
                          context.pushReplacement('/login');
                        },
                        child: const Text('Masuk di sini'))
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
