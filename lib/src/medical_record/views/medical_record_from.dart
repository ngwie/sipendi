import 'package:flutter/material.dart';
import 'package:sipendi/src/utils/string_validation.dart';

import '../models/medical_record_page_type.dart';

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
                    _textTitle(context, pageType: pageType),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 18),
                  ..._formField(context, pageType: pageType),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('Simpan'),
                    onPressed: () async {
                      // save and go back
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _textTitle(
    BuildContext context, {
    required MedicalRecordPageType pageType,
  }) {
    switch (pageType) {
      case MedicalRecordPageType.bloodPressure:
        return 'Tekanan Darah';
      case MedicalRecordPageType.bloodSugar:
        return 'Gula Darah';
      case MedicalRecordPageType.hemoglobin:
        return 'HbA1C';
      case MedicalRecordPageType.cholesterol:
        return 'Kolesterol';
      case MedicalRecordPageType.bodyWeight:
        return 'Berat Badan';
      case MedicalRecordPageType.abdominalCircumference:
        return 'Lingkar Perut';
      default:
        return '';
    }
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
}
