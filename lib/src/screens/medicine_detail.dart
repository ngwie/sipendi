import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sipendi/src/models/user_medicine_model.dart';
import 'package:sipendi/src/utils/string_med.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MedicineDetailScreen extends StatelessWidget {
  final _supabase = Supabase.instance.client;

  final String id;

  MedicineDetailScreen({super.key, required this.id});

  Future<UserMedicineModel> _getUserMedicineDetail() async {
    final response = await _supabase
        .from('patient_medicine')
        .select('*, medicine(*)')
        .eq('id', id)
        .single();

    return UserMedicineModel.formHash(response);
  }

  Future<void> _deactivateUserMedicine() {
    return _supabase.from('patient_medicine').update({
      'active': false,
      'updated_at': 'now()',
      'updated_by': _supabase.auth.currentUser?.id,
    }).eq('id', id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Hapus obat',
            onPressed: () => _showAlertDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: FutureBuilder<dynamic>(
              future: _getUserMedicineDetail(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    heightFactor: 8,
                    child: CircularProgressIndicator(
                      color: Color(0xFF75B79E),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Unexpected error occurred',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                if (snapshot.hasData) {
                  return _userMedicineDetail(context, snapshot.data);
                }

                return const Center(
                  child: Text(
                    'Data tidak ditemukan',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _userMedicineDetail(
      BuildContext context, UserMedicineModel userMedicine) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          userMedicine.medicine.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          StringMed.consumptionRuleText(rule: userMedicine.consumptionRule),
          style: const TextStyle(
            fontSize: 24,
            color: Color(0xFF75B79E),
          ),
        ),
        const SizedBox(height: 1),
        Row(
          children: [
            const Text(
              'Mulai Pemakain: ',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF75B79E),
              ),
            ),
            Text(
              userMedicine.startDate,
              style: const TextStyle(
                color: Color(0xFF75B79E),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Row(
            children: [
              _doseCard(
                label: 'Dosis',
                text: StringMed.doseText(
                  dose: userMedicine.dose,
                  doseUnit: userMedicine.doseUnit,
                ),
              ),
              const SizedBox(width: 18),
              _doseCard(
                  label: 'Frekuensi',
                  text: StringMed.doseFrequencyText(
                    freq: userMedicine.recurrenceFrequency,
                    type: userMedicine.recurrenceType,
                  )),
            ],
          ),
        ),
        Text(
          'Deskripsi:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          userMedicine.medicine.descriptions ?? '',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget _doseCard({required String label, required String text}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: ShapeDecoration(
          color: const Color(0xFF75B79E),
          shadows: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              spreadRadius: 4,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFEEF9BF),
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFFEEF9BF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text('Batalkan'),
      onPressed: () => Navigator.pop(context),
    );

    Widget confirmButton = TextButton(
      child: const Text('Iya, Saya yakin'),
      onPressed: () async {
        try {
          await _deactivateUserMedicine();

          if (context.mounted) {
            Navigator.pop(context);
            context.pop(true);
          }
        } catch (error) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Gagal menghapus obat'),
              behavior: SnackBarBehavior.floating,
            ));
          }
        }
      },
    );

    AlertDialog removeConfirmationAlert = AlertDialog(
      title: const Text('Hapus Obat'),
      content: const Text('Apakah anda yakin ingin menghapus obat ini'),
      actions: [
        cancelButton,
        confirmButton,
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => removeConfirmationAlert,
    );
  }
}
