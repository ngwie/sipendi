import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/medical_record_bloc.dart';
import '../models/medical_record_form_data.dart';
import '../models/medical_record_page_type.dart';
import '../models/medical_record_type.dart';
import '../../utils/string_validation.dart';

class MedicalRecordAddScreen extends StatefulWidget {
  final String pageTypeName;

  const MedicalRecordAddScreen({super.key, required this.pageTypeName});

  @override
  State<MedicalRecordAddScreen> createState() => _MedicalRecordAddScreenState();
}

class _MedicalRecordAddScreenState extends State<MedicalRecordAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _bodyWeightController = TextEditingController();
  final _bloodSugarController = TextEditingController();
  final _cholesterolController = TextEditingController();
  final _hemoglobinA1cController = TextEditingController();
  final _abdominalCircumferenceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final pageType = MedicalRecordPageType.values.byName(widget.pageTypeName);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pageType.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 18),
                  ..._formField(context, pageType: pageType),
                  const SizedBox(height: 18),
                  _submitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _formField(
    BuildContext context, {
    required MedicalRecordPageType pageType,
  }) {
    switch (pageType) {
      case MedicalRecordPageType.bloodPressure:
        return [
          _inputField(
            context,
            label: 'Sistole',
            controller: _systolicController,
          ),
          const SizedBox(height: 18),
          _inputField(
            context,
            label: 'Diastole',
            controller: _diastolicController,
          ),
        ];
      case MedicalRecordPageType.bloodSugar:
        return [
          _inputField(
            context,
            label: 'Kadar Gula Darah',
            controller: _bloodSugarController,
          )
        ];
      case MedicalRecordPageType.hemoglobin:
        return [
          _inputField(
            context,
            label: 'Kadar HbA1c',
            controller: _hemoglobinA1cController,
          )
        ];
      case MedicalRecordPageType.cholesterol:
        return [
          _inputField(
            context,
            label: 'Kadar Kolesterol',
            controller: _cholesterolController,
          )
        ];
      case MedicalRecordPageType.bodyWeight:
        return [
          _inputField(
            context,
            label: 'Berat Badan',
            controller: _bodyWeightController,
          )
        ];
      case MedicalRecordPageType.abdominalCircumference:
        return [
          _inputField(
            context,
            label: 'Linkar Perut',
            controller: _abdominalCircumferenceController,
          )
        ];
      default:
        return [];
    }
  }

  Widget _inputField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) =>
          StringValidation.isEmpty(value) ? '$label tidak boleh kosong' : null,
    );
  }

  Widget _submitButton(BuildContext context) {
    return BlocConsumer<MedicalRecordBloc, MedicalRecordState>(
      listenWhen: (previous, current) =>
          previous.statusAdd == MedicalRecordStateStatus.loading,
      listener: (context, state) {
        if (state.statusAdd == MedicalRecordStateStatus.success) {
          context.pop();
        }

        if (state.statusAdd == MedicalRecordStateStatus.failure) {
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
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          onPressed: () => _onSubmit(context, state),
          child: state.statusAdd == MedicalRecordStateStatus.loading
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )
              : const Text('Simpan'),
        );
      },
    );
  }

  Future<void> _onSubmit(BuildContext context, MedicalRecordState state) async {
    if (state.statusAdd == MedicalRecordStateStatus.loading) return;
    if (!_formKey.currentState!.validate()) return;

    final List<MedicalRecordFormData> data = [];
    final pageType = MedicalRecordPageType.values.byName(widget.pageTypeName);

    for (var resourceType in pageType.resourceTypes) {
      switch (resourceType) {
        case MedicalRecordType.body_weight:
          data.add(MedicalRecordFormData(
            type: MedicalRecordType.body_weight,
            value: _bodyWeightController.text.trim(),
          ));
          break;
        case MedicalRecordType.hemoglobin_a1c:
          data.add(MedicalRecordFormData(
            type: MedicalRecordType.hemoglobin_a1c,
            value: _hemoglobinA1cController.text.trim(),
          ));
          break;
        case MedicalRecordType.blood_sugar:
          data.add(MedicalRecordFormData(
            type: MedicalRecordType.blood_sugar,
            value: _bloodSugarController.text.trim(),
          ));
          break;
        case MedicalRecordType.blood_pressure_systolic:
          data.add(MedicalRecordFormData(
            type: MedicalRecordType.blood_pressure_systolic,
            value: _systolicController.text.trim(),
          ));
          break;
        case MedicalRecordType.blood_pressure_diastolic:
          data.add(MedicalRecordFormData(
            type: MedicalRecordType.blood_pressure_diastolic,
            value: _diastolicController.text.trim(),
          ));
          break;
        case MedicalRecordType.cholesterol:
          data.add(MedicalRecordFormData(
            type: MedicalRecordType.cholesterol,
            value: _cholesterolController.text.trim(),
          ));
          break;
        case MedicalRecordType.abdominal_circumference:
          data.add(MedicalRecordFormData(
            type: MedicalRecordType.abdominal_circumference,
            value: _abdominalCircumferenceController.text.trim(),
          ));
          break;
        default:
      }
    }

    context.read<MedicalRecordBloc>().add(MedicalRecordAdded(data: data));
  }
}
