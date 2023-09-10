import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  final _supabase = Supabase.instance.client;
  List? _medicines;

  @override
  void initState() {
    super.initState();
    _getUserMedicine(context);
  }

  Future<void> _getUserMedicine(BuildContext context) async {
    try {
      var response = await _supabase
          .from('patient_medicine')
          .select('id, medicine(name)')
          .eq('active', true);

      setState(() {
        _medicines = response;
      });
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Unexpected error occurred'),
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daftar Obat',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: _medicineList(context, medicines: _medicines),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bool? value = await context.push('/medicine/add');
          if ((value ?? false) && context.mounted) {
            _getUserMedicine(context);
          }
        },
        tooltip: 'Tambah Obat',
        backgroundColor: const Color(0xFF75B79E),
        child: const Icon(
          Icons.add,
          color: Color(0xFFEEF9BF),
        ),
      ),
    );
  }

  List<Widget> _medicineList(BuildContext context, {List<dynamic>? medicines}) {
    if (medicines == null) return [];
    return medicines.fold([], (val, med) {
      val.addAll([
        _medicineItem(
          context,
          id: med['id'],
          medicineName: med['medicine']['name'],
        ),
        const SizedBox(height: 18),
      ]);
      return val;
    });
  }

  Widget _medicineItem(BuildContext context,
      {required int id, required String medicineName}) {
    return ElevatedButton(
      onPressed: () async {
        final bool? value = await context.push('/medicine/${id.toString()}');
        if ((value ?? false) && context.mounted) {
          _getUserMedicine(context);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF75B79E),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icon/meds.svg',
            width: 38,
          ),
          const SizedBox(width: 18),
          Text(
            medicineName,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Color(0xFFEEF9BF),
            ),
          ),
        ],
      ),
    );
  }
}
