import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sipendi/src/models/medicine_search_model.dart';
import 'package:sipendi/src/utils/string_validation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const List<Map<String, String>> _genderList = [
  {'label': 'Laki-Laki', 'value': 'male'},
  {'label': 'Perempuan', 'value': 'female'},
];

const List<Map<String, String>> _consumptionRuleList = [
  {'label': 'Sebelum Makan', 'value': 'before_meal'},
  {'label': 'Sesudah Makan', 'value': 'after_meal'},
  {'label': 'Saat Makan', 'value': 'during_meal'},
];

const List<Map<String, String>> _doseUnitList = [
  {'label': 'Tablet', 'value': 'tablet'},
  {'label': 'Kapsul', 'value': 'capsul'},
  {'label': 'Kaplet', 'value': 'kaplet'},
  {'label': 'Sendok Teh', 'value': 'tea_spoon'},
  {'label': 'Sendok Makan', 'value': 'table_spoon'},
  {'label': 'Milli', 'value': 'ml'},
  {'label': 'Pen', 'value': 'pen'},
];

const List<Map<String, String>> _recurrenceTypeList = [
  {'label': 'Jam', 'value': 'hours'},
  {'label': 'Hari', 'value': 'days'},
  {'label': 'Minggu', 'value': 'weeks'},
  {'label': 'Bulan', 'value': 'months'},
];

class MedicineAddScreen extends StatefulWidget {
  const MedicineAddScreen({super.key});

  @override
  State<MedicineAddScreen> createState() => _MedicineAddState();
}

class _MedicineAddState extends State<MedicineAddScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _medicineController = TextEditingController();
  final _consumptionRuleController = TextEditingController();
  final _doseController = TextEditingController();
  final _doseUnitController = TextEditingController();
  final _recurrenceFrequencyController = TextEditingController();
  final _recurrenceTypeController = TextEditingController();
  final _startDateController = TextEditingController();

  Future<List<MedicineSearchModel>> _searchMed(String filter) async {
    try {
      final List response = await _supabase
          .from('medicine')
          .select('id, name')
          .ilike('name', '%$filter%')
          .limit(10);
      return MedicineSearchModel.fromHashList(response);
    } catch (error) {
      return [];
    }
  }

  Future<void> _addMed() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final medicineId = _medicineController.text;
      final consumptionRule = _consumptionRuleController.text;
      final dose = _doseController.text.trim();
      final doseUnit = _doseUnitController.text;
      final freq = _recurrenceFrequencyController.text.trim();
      final freqType = _recurrenceTypeController.text;
      final startDate = DateFormat('dd-MM-yyyy')
          .parse(_startDateController.text.trim())
          .toIso8601String();

      await _supabase.from('patient_medicine').insert({
        'user_id': _supabase.auth.currentUser?.id,
        'medicine_id': medicineId,
        'active': true,
        'start_date': startDate,
        'dose': dose,
        'dose_unit': doseUnit,
        'recurrence_type': freqType,
        'recurrence_frequency': freq,
        'consumption_rule': consumptionRule,
      });

      if (context.mounted) {
        context.pop(true);
      }
    } on AuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message),
        behavior: SnackBarBehavior.floating,
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Unexpected error occurred'),
        behavior: SnackBarBehavior.floating,
      ));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color(0xFF75B79E)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tambah Obat',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6A8CAF),
                    ),
                  ),
                  const SizedBox(height: 18),
                  DropdownSearch<MedicineSearchModel>(
                    asyncItems: (String filter) => _searchMed(filter),
                    popupProps: PopupProps.menu(
                      showSelectedItems: true,
                      showSearchBox: true,
                      isFilterOnline: true,
                      itemBuilder: (context, item, isSelected) {
                        return ListTile(
                          selected: isSelected,
                          title: Text(item.name),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 24),
                        );
                      },
                    ),
                    compareFn: (item1, item2) => item1.id == item2.id,
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Nama Obat",
                      ),
                    ),
                    validator: (value) => StringValidation.isEmpty(value?.name)
                        ? 'Nama obat tidak boleh kosong'
                        : null,
                    onChanged: (value) {
                      setState(() {
                        _medicineController.text = '${value?.id}';
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Aturan Pakai',
                    ),
                    validator: (value) => StringValidation.isEmpty(value)
                        ? 'Aturan pakai tidak boleh kosong'
                        : null,
                    onChanged: (value) {
                      setState(() {
                        _consumptionRuleController.text = value ?? '';
                      });
                    },
                    items: _consumptionRuleList
                        .map<DropdownMenuItem<String>>((item) {
                      return DropdownMenuItem<String>(
                        value: item['value'],
                        child: Text(item['label']!),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Dosis',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6A8CAF),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _doseController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Dosis',
                          ),
                          validator: (value) => StringValidation.isEmpty(value)
                              ? 'Dosis tidak boleh kosong'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Satuan',
                          ),
                          validator: (value) => StringValidation.isEmpty(value)
                              ? 'Satuan dosis pakai tidak boleh kosong'
                              : null,
                          onChanged: (value) {
                            setState(() {
                              _doseUnitController.text = value ?? '';
                            });
                          },
                          items: _doseUnitList
                              .map<DropdownMenuItem<String>>((item) {
                            return DropdownMenuItem<String>(
                              value: item['value'],
                              child: Text(item['label']!),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Frekuensi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6A8CAF),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _recurrenceFrequencyController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Setiap',
                          ),
                          validator: (value) => StringValidation.isEmpty(value)
                              ? 'Frekuesi pemakaian tidak boleh kosong'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Jam/Hari/Minggu',
                          ),
                          validator: (value) => StringValidation.isEmpty(value)
                              ? 'Satuan frekuesi tidak boleh kosong'
                              : null,
                          onChanged: (value) {
                            setState(() {
                              _recurrenceTypeController.text = value ?? '';
                            });
                          },
                          items: _recurrenceTypeList
                              .map<DropdownMenuItem<String>>((item) {
                            return DropdownMenuItem<String>(
                              value: item['value'],
                              child: Text(item['label']!),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    readOnly: true,
                    controller: _startDateController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tanggal Mulai Pemakain',
                    ),
                    validator: (value) => StringValidation.isEmpty(value)
                        ? 'Tanggal mulai pemakain tidak boleh kosong'
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
                          _startDateController.text = formattedDate;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: _addMed,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: const Color(0xFF75B79E),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Color(0xFFEEF9BF),
                            ),
                          )
                        : const Text(
                            'Tambah',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFEEF9BF),
                            ),
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
