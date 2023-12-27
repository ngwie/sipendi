import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_auth.dart';
import '../../utils/string_validation.dart';

const List<Map<String, String>> _genderList = [
  {'label': 'Laki-Laki', 'value': 'male'},
  {'label': 'Perempuan', 'value': 'female'},
];

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _bodyHeightController = TextEditingController();
  final _genderController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            _signUpForm(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Sudah punya akun'),
                TextButton(
                  child: const Text('Masuk di sini'),
                  onPressed: () => context.pushReplacement('/login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _signUpForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Registrasi Akun',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _fullNameController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nama Lengkap',
            ),
            validator: (value) => StringValidation.isEmpty(value)
                ? 'Nama tidak boleh kosong'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nomor HP',
              hintText: '0812xxxxxx',
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
              labelText: 'Kata Sandi',
            ),
            validator: (value) => StringValidation.isEmpty(value)
                ? 'Password tidak boleh kosong'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            readOnly: true,
            controller: _birthDateController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Tanggal Lahir',
            ),
            validator: (value) => StringValidation.isEmpty(value)
                ? 'Tanggal lahir tidak boleh kosong'
                : null,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('dd-MM-yyyy').format(pickedDate);
                setState(() {
                  _birthDateController.text = formattedDate;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _bodyHeightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Tinggi Bandan',
            ),
            validator: (value) => StringValidation.isEmpty(value)
                ? 'Tinggi badan tidak boleh kosong'
                : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Jenis Kelamin',
              contentPadding: EdgeInsets.symmetric(
                vertical: 17.5,
                horizontal: 10,
              ),
            ),
            validator: (value) => StringValidation.isEmpty(value)
                ? 'Jenis kelamin tidak boleh kosong'
                : null,
            onChanged: (value) {
              setState(() {
                _genderController.text = value ?? '';
              });
            },
            items: _genderList.map<DropdownMenuItem<String>>((item) {
              return DropdownMenuItem<String>(
                value: item['value'],
                child: Text(item['label']!),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            maxLines: 3,
            minLines: 3,
            controller: _addressController,
            keyboardType: TextInputType.streetAddress,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Alamat',
              alignLabelWithHint: true,
            ),
            validator: (value) => StringValidation.isEmpty(value)
                ? 'Alamat tidak boleh kosong'
                : null,
          ),
          const SizedBox(height: 16),
          Consumer<UserAuthModel>(
            builder: (context, model, child) => ElevatedButton(
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
                  : const Text('Daftar'),
              onPressed: () async {
                if (_isLoading) return;
                if (!_formKey.currentState!.validate()) return;

                try {
                  setState(() {
                    _isLoading = true;
                  });

                  final fullName = _fullNameController.value.text.trim();
                  final phone = _phoneController.value.text
                      .trim()
                      .replaceFirst(RegExp(r'^0'), '62');
                  final password = _passwordController.value.text;
                  final birthDate = _birthDateController.value.text;
                  final bodyHeight = _bodyHeightController.value.text.trim();
                  final gender = _genderController.value.text.trim();
                  final address = _addressController.value.text.trim();

                  await model.signUp(
                    fullName: fullName,
                    phone: phone,
                    password: password,
                    birthDate: birthDate,
                    bodyHeight: bodyHeight,
                    gender: gender,
                    address: address,
                  );

                  if (context.mounted) {
                    context.pushReplacement('/login');
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
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Unexpected error occurred'),
                      behavior: SnackBarBehavior.floating,
                    ));
                  }
                }

                setState(() {
                  _isLoading = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
