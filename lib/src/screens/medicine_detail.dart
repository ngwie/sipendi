import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sipendi/src/utils/string_med.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MedicineDetailScreen extends StatefulWidget {
  final String? id;

  const MedicineDetailScreen({super.key, required this.id});

  @override
  State<MedicineDetailScreen> createState() => _MedicineDetailState();
}

class _MedicineDetailState extends State<MedicineDetailScreen> {
  final _supabase = Supabase.instance.client;
  Map? _userMedicine;

  @override
  void initState() {
    super.initState();
    _getUserMedicineDetail(context);
  }

  Future<void> _getUserMedicineDetail(BuildContext context) async {
    try {
      if (widget.id == null) return;

      var response = await _supabase
          .from('patient_medicine')
          .select('*, medicine(*)')
          .eq('id', widget.id)
          .single();

      setState(() {
        _userMedicine = response;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Unexpected error occurred'),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  Future<void> _deactivateUserMedicine(BuildContext context) async {
    try {
      if (widget.id == null) return;

      await _supabase.from('patient_medicine').update({
        'active': false,
        'updated_at': 'now()',
        'updated_by': _supabase.auth.currentUser?.id,
      }).eq('id', widget.id);

      if (context.mounted) {
        Navigator.pop(context);
        context.pop(true);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Fail to remove medicine'),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color(0xFF75B79E)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Hapus obat',
            onPressed: () => _showAlertDialog(context),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userMedicine?['medicine']['name'] ?? '',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6A8CAF),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  StringMed.consumptionRuleText(
                      rule: _userMedicine?['consumption_rule']),
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
                      _userMedicine?['start_date'] ?? '',
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
                          dose: _userMedicine?['dose'],
                          doseUnit: _userMedicine?['dose_unit'],
                        ),
                      ),
                      const SizedBox(width: 18),
                      _doseCard(
                          label: 'Frekuensi',
                          text: StringMed.doseFrequencyText(
                            freq: _userMedicine?['recurrence_frequency'],
                            type: _userMedicine?['recurrence_type'],
                          )),
                    ],
                  ),
                ),
                const Text(
                  'Deskripsi:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6A8CAF),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  _userMedicine?['medicine']['descriptions'] ?? '',
                  style: const TextStyle(
                    color: Color(0xFF6A8CAF),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
      child: Text('Iya, Saya yakin'),
      onPressed: () => _deactivateUserMedicine(context),
    );

    AlertDialog removeConfirmationAlert = AlertDialog(
      title: const Text('Hapus Obat'),
      content: const Text('Apakah anda yakin ingin menghapus obat ini'),
      actions: [
        cancelButton,
        confirmButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => removeConfirmationAlert,
    );
  }
}
