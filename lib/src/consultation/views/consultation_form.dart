import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/cubit/config_cubit.dart';
import '../../utils/string_validation.dart';
import '../bloc/consultation_bloc.dart';
import '../models/consultation_form_data.dart';

class ConsultationFormScreen extends StatefulWidget {
  const ConsultationFormScreen({super.key});

  @override
  State<ConsultationFormScreen> createState() => _ConsultationFormState();
}

class _ConsultationFormState extends State<ConsultationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: BlocConsumer<ConsultationBloc, ConsultationState>(
          listenWhen: (previous, current) =>
              previous.statusAdd == ConsultationStatus.loading,
          listener: (context, state) {
            if (state.statusAdd == ConsultationStatus.success) {
              final lastConsultation = state.consultations.first;
              final phoneNumber =
                  context.read<ConfigCubit>().get('consultation_phone_number');
              final url = Uri.parse(
                  'https://wa.me/$phoneNumber?text=${lastConsultation.title}\n${lastConsultation.body}');

              launchUrl(url);
              context.pop();
            }

            if (state.statusAdd == ConsultationStatus.failure) {
              final errorMessage = state.errorAdd != ''
                  ? state.errorAdd
                  : 'Unexpected error occurred';

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(errorMessage),
                behavior: SnackBarBehavior.floating,
              ));
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                children: [
                  Text(
                    'Konsultasi',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Judul',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => StringValidation.isEmpty(value)
                        ? 'Judul tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    maxLines: 4,
                    minLines: 4,
                    controller: _bodyController,
                    decoration: const InputDecoration(
                      labelText: 'Pesan Keluhan/Konsultasi',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    validator: (value) => StringValidation.isEmpty(value)
                        ? 'Pesan tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () => _onSubmit(context, state),
                    child: state.statusAdd == ConsultationStatus.loading
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )
                        : const Text('Kirim'),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onSubmit(BuildContext context, ConsultationState state) {
    if (state.statusAdd == ConsultationStatus.loading) return;
    if (!_formKey.currentState!.validate()) return;

    final data = ConsultationFormData(
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
    );

    context.read<ConsultationBloc>().add(ConsultationAdded(data: data));
  }
}
