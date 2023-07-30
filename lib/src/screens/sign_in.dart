import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/userAuth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
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
                TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Nomor HP',
                    )),
                const SizedBox(height: 18),
                TextField(
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Kata Sandi',
                    )),
                const SizedBox(height: 18),
                Consumer<UserAuthModel>(
                  builder: (context, model, child) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: const Color(0xFF75B79E)),
                      onPressed: () async {
                        try {
                          await model.signIn(_phoneController.value.text,
                              _passwordController.value.text);

                          if (context.mounted) {
                            context.pushReplacement('/');
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
                        'Masuk',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFEEF9BF)),
                      ),
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
    );
  }
}
