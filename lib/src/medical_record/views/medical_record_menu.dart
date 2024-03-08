import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../models/medical_record_page_type.dart';

class MedicalRecordMenuScreen extends StatelessWidget {
  const MedicalRecordMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kondisi Fisik'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            _menuItem(
              context,
              pageType: MedicalRecordPageType.bloodSugar,
              label: 'Gula Darah',
            ),
            const SizedBox(height: 16),
            _menuItem(
              context,
              pageType: MedicalRecordPageType.hemoglobin,
              label: 'HbA1c',
            ),
            const SizedBox(height: 16),
            _menuItem(
              context,
              pageType: MedicalRecordPageType.bloodPressure,
              label: 'Tekanan Darah',
            ),
            const SizedBox(height: 16),
            _menuItem(
              context,
              pageType: MedicalRecordPageType.cholesterol,
              label: 'Kolesterol',
            ),
            const SizedBox(height: 16),
            _menuItem(
              context,
              pageType: MedicalRecordPageType.bodyWeight,
              label: 'Berat Badan',
            ),
            const SizedBox(height: 16),
            _menuItem(
              context,
              pageType: MedicalRecordPageType.abdominalCircumference,
              label: 'Lingkar Perut',
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context,
      {required MedicalRecordPageType pageType, required String label}) {
    return ElevatedButton(
      onPressed: () {
        context.push('/medical-record/${pageType.name}');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        children: [
          SvgPicture.asset('assets/icon/doctor.svg', width: 32),
          const SizedBox(width: 16),
          Text(
            label,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
