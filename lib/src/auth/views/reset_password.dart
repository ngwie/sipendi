import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../utils/string_validation.dart';
import '../models/user_auth.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPasswordScreen> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atur Ulang Sandi'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: _requestOtpForm(context),
        ),
      ),
    );
  }

  Widget _requestOtpForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

                  final phone = _phoneController.value.text
                      .trim()
                      .replaceFirst(RegExp(r'^0'), '62');

                  await model.requestOtp(phone: phone);

                  if (context.mounted) {
                    context.push('/reset-password/verify-otp', extra: phone);
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
                  : const Text('Kirim OTP'),
            ),
          ),
        ],
      ),
    );
  }
}
