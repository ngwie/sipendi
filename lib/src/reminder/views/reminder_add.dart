import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../patient_medicine/bloc/patient_medicine_bloc.dart';
import '../../patient_medicine/models/patient_medicine.dart';
import '../../utils/alarm_notification.dart';
import '../../utils/sqlite_db.dart';
import '../../utils/string_validation.dart';

import '../../models/medicine_model.dart';
import '../bloc/reminder_bloc.dart';
import '../models/reminder_model.dart';

// enum ReminderContext { takingMedicine, medicalRecord }

/* const List<Map<String, dynamic>> _medicalRecordList = [
  {'id': 1, 'label': 'Berat Badan', 'value': 'body_weight'},
  {'id': 2, 'label': 'Gula Darah', 'value': 'blood_sugar'},
]; */

class ReminderAddScreen extends StatefulWidget {
  const ReminderAddScreen({super.key});

  @override
  State<ReminderAddScreen> createState() => _ReminderAddScreenState();
}

class _ReminderAddScreenState extends State<ReminderAddScreen> {
  // final _supabase = Supabase.instance.client;

  // final ReminderContext _reminderContext = ReminderContext.takingMedicine;

  final _formKey = GlobalKey<FormState>();
  final _medicineIdController = TextEditingController();
  final _medicineNameController = TextEditingController();
  // final _medicalRecordController = TextEditingController();
  final List<TimeOfDay> _reminderTimes = [];

  // bool _isLoading = false;

  /* Future<List<MedicineModel>> _searchMed(String filter) async {
    try {
      final List res = await _supabase
          .from('patient_medicine')
          .select('id, medicine!inner(id, name)')
          .eq('active', true)
          .ilike('medicine.name', '%$filter%')
          .limit(10);
      final medList = res.map((pm) => pm['medicine']).toList();
      return MedicineModel.fromHashList(medList);
    } catch (error) {
      return [];
    }
  } */

  /* Future _saveReminder(BuildContext context) async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;
    if (_reminderTimes.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Jam pengingat tibak boleh kosong'),
          behavior: SnackBarBehavior.floating,
        ));
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? reminderContext;
      int? referenceId;
      String? referenceName;

      if (_reminderContext == ReminderContext.takingMedicine) {
        reminderContext = 'taking_medicine';
        referenceId = _medicineId;
        referenceName = _medicineName;
      } else {
        final recType = _medicalRecordList
            .firstWhere((mr) => mr['value'] == _medicalRecordController.text);

        reminderContext = 'medical_record';
        referenceId = recType['id'];
        referenceName = recType['label'];
      }

      final reminderId = await SqliteDb.client.insert('reminder', {
        'active': 1,
        'context': reminderContext,
        'reference_id': referenceId,
        'reference_name': referenceName,
        'recurrence_type': 'every_day',
      });

      Batch batch = SqliteDb.client.batch();
      for (var time in _reminderTimes) {
        if (context.mounted) {
          batch.insert('reminder_time', {
            'reminder_id': reminderId,
            'time': time.format(context),
          });
        }
      }
      await batch.commit(noResult: true);

      final reminders = await SqliteDb.client.query(
        'reminder',
        where: 'id = ?',
        whereArgs: [reminderId],
      );
      final reminderTimes = await SqliteDb.client.query(
        'reminder_time',
        where: 'reminder_id = ?',
        whereArgs: [reminderId],
      );

      final reminder = ReminderModel.fromHash({
        ...reminders.first,
        'time_list': reminderTimes,
      });

      String title = '';
      String body = '';

      if (reminder.context == 'taking_medicine') {
        title = 'Pengingat Obat';
        body = 'Waktunya minum obat ${reminder.referenceName}';
      } else {
        title = 'Pengingat';
        body = 'Waktunya mengukur ${reminder.referenceName}';
      }

      for (var reminderTime in reminder.times) {
        await AlarmNotification.schedule(
          id: reminderTime.id,
          time: reminderTime.time,
          title: title,
          body: body,
        );
      }

      if (context.mounted) {
        context.pop(true);
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.toString()),
          behavior: SnackBarBehavior.floating,
        ));
      }
    }

    setState(() {
      _isLoading = false;
    });
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pengingat'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _reminderForm(context),
        ),
      ),
    );
  }

  Widget _reminderForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _reminderMedicineInput(context),
          const SizedBox(height: 16),
          _reminderTimeInput(context),
          const SizedBox(height: 16),
          _reminderSubmitButton(context),
        ],
      ),
    );
  }

  Widget _reminderMedicineInput(BuildContext context) {
    return BlocBuilder<PatientMedicineBloc, PatientMedicineState>(
      bloc: BlocProvider.of<PatientMedicineBloc>(context)
        ..add(PatientMedicineFetched()),
      builder: (context, state) => DropdownSearch<PatientMedicine>(
        items: state.patientMedicines.toList(),
        itemAsString: (item) => item.medicine.name,
        compareFn: (item1, item2) => item1.id == item2.id,
        validator: (value) => StringValidation.isEmpty(value?.medicine.name)
            ? 'Nama obat tidak boleh kosong'
            : null,
        onChanged: (value) => setState(() {
          _medicineIdController.text = value?.id.toString() ?? '';
          _medicineNameController.text = value?.medicine.name ?? '';
        }),
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nama Obat',
          ),
        ),
        popupProps: PopupProps.menu(
          showSelectedItems: true,
          showSearchBox: true,
          isFilterOnline: true,
          itemBuilder: (context, item, isSelected) => ListTile(
            selected: isSelected,
            title: Text(item.medicine.name),
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          ),
        ),
      ),
    );
  }

  Widget _reminderTimeInput(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: 8,
      children: [
        ...List<Widget>.generate(
          _reminderTimes.length,
          (int index) => InputChip(
            label: Text(_reminderTimes[index].format(context)),
            avatar: const Icon(Icons.alarm),
            onDeleted: () {
              setState(() => _reminderTimes.removeAt(index));
            },
          ),
        ),
        InputChip(
          label: const Text('Tambah Jam'),
          avatar: const Icon(Icons.add),
          onPressed: () async {
            final selectedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );

            if (selectedTime != null) {
              setState(() => _reminderTimes.add(selectedTime));
            }
          },
        ),
      ],
    );
  }

  Widget _reminderSubmitButton(BuildContext context) {
    return BlocConsumer<ReminderBloc, ReminderState>(
      listenWhen: (previous, current) => previous is ReminderLoading,
      listener: (context, state) {
        if (state is ReminderAdded) {
          context.pop();
        }

        if (state is ReminderError) {
          final errorMessage =
              state.error != '' ? state.error : 'Unexpected error occurred';

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
          child: const Text('Simpan'),
          onPressed: () {
            // await state.;
          },
        );
      },
    );
  }

  /* List<Widget> _buildReminderForm(BuildContext context) {
    return [
      / Column(
        children: <Widget>[
          RadioButton<ReminderContext>(
            label: const Text('Obat'),
            value: ReminderContext.takingMedicine,
            groupValue: _reminderContext,
            onChanged: (ReminderContext? value) {
              setState(() {
                _reminderContext = value!;
              });
            },
          ),
          RadioButton<ReminderContext>(
            label: const Text('Rekam Data'),
            value: ReminderContext.medicalRecord,
            groupValue: _reminderContext,
            onChanged: (ReminderContext? value) {
              setState(() {
                _reminderContext = value!;
              });
            },
          ),
        ],
      ),
      const SizedBox(height: 16), /
      ...(_reminderContext == ReminderContext.takingMedicine
          ? _buildMedicineReminderInputs(context)
          : _buildMedicalRecordReminderInputs(context)),
      const SizedBox(height: 16),
      Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 8,
        children: [
          ...List<Widget>.generate(
            _reminderTimes.length,
            (int index) => InputChip(
              label: Text(_reminderTimes[index].format(context)),
              avatar: Icon(Icons.alarm),
              onDeleted: () {
                setState(() {
                  _reminderTimes.removeAt(index);
                });
              },
            ),
          ),
          InputChip(
            label: const Text('Tambah Jam'),
            avatar: const Icon(Icons.add),
            onPressed: () async {
              final selectedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (selectedTime != null) {
                setState(() {
                  _reminderTimes.add(selectedTime);
                });
              }
            },
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildMedicineReminderInputs(BuildContext context) {
    return [
      DropdownSearch<MedicineModel>(
        asyncItems: (String filter) => _searchMed(filter),
        popupProps: PopupProps.menu(
          showSelectedItems: true,
          showSearchBox: true,
          isFilterOnline: true,
          itemBuilder: (context, item, isSelected) {
            return ListTile(
              selected: isSelected,
              title: Text(item.name),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            );
          },
        ),
        compareFn: (item1, item2) => item1.id == item2.id,
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nama Obat',
          ),
        ),
        validator: (value) => StringValidation.isEmpty(value?.name)
            ? 'Nama obat tidak boleh kosong'
            : null,
        onChanged: (value) {
          setState(() {
            _medicineId = value?.id;
            _medicineName = value?.name;
          });
        },
      ),
    ];
  }

  List<Widget> _buildMedicalRecordReminderInputs(BuildContext context) {
    return [
      DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Tipe Rekam Data',
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
            _medicalRecordController.text = value ?? '';
          });
        },
        items: _medicalRecordList.map<DropdownMenuItem<String>>((item) {
          return DropdownMenuItem<String>(
            value: item['value'],
            child: Text(item['label']!),
          );
        }).toList(),
      ),
    ];
  } */
}
