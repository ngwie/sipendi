import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../models/medical_record_page_type.dart';

class MedicalRecordMenuScreen extends StatelessWidget {
  const MedicalRecordMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kondisi Fisik',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 18),
                _menuItem(
                  context,
                  pageType: MedicalRecordPageType.bloodSugar,
                  label: 'Gula Darah',
                ),
                const SizedBox(height: 18),
                _menuItem(
                  context,
                  pageType: MedicalRecordPageType.hemoglobin,
                  label: 'HbA1c',
                ),
                const SizedBox(height: 18),
                _menuItem(
                  context,
                  pageType: MedicalRecordPageType.bloodPressure,
                  label: 'Tekanan Darah',
                ),
                const SizedBox(height: 18),
                _menuItem(
                  context,
                  pageType: MedicalRecordPageType.cholesterol,
                  label: 'Kolesterol',
                ),
                const SizedBox(height: 18),
                _menuItem(
                  context,
                  pageType: MedicalRecordPageType.bodyWeight,
                  label: 'Berat Badan',
                ),
                const SizedBox(height: 18),
                _menuItem(
                  context,
                  pageType: MedicalRecordPageType.abdominalCircumference,
                  label: 'Lingkar Perut',
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icon/doctor.svg',
            width: 38,
          ),
          const SizedBox(width: 18),
          Text(
            label,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Color(0xFF75B79E),
            ),
          ),
        ],
      ),
    );
  }
}
