import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../utils/string_validation.dart';
import '../models/user_auth.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String phone;

  const VerifyOtpScreen({super.key, required this.phone});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtpScreen> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verfikasi OTP'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: _validateOtpForm(context),
        ),
      ),
    );
  }

  Widget _validateOtpForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Kode OTP',
            ),
            validator: (value) => StringValidation.isEmpty(value)
                ? 'Kode OTP tidak boleh kosong'
                : null,
          ),
          const SizedBox(height: 16),
          Consumer<UserAuthModel>(
            builder: (_, model, child) => ElevatedButton(
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

                  await model.verifyOtp(
                    phone: widget.phone,
                    token: _otpController.value.text.trim(),
                  );

                  if (context.mounted) {
                    context.push('/reset-password/change-password');
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
                  : const Text('Verifikasi'),
            ),
          ),
        ],
      ),
    );
  }
}
