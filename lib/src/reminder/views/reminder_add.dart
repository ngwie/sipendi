import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../patient_medicine/bloc/patient_medicine_bloc.dart';
import '../../patient_medicine/models/patient_medicine.dart';
import '../../utils/string_validation.dart';
import '../bloc/reminder_bloc.dart';

class ReminderAddScreen extends StatefulWidget {
  const ReminderAddScreen({super.key});

  @override
  State<ReminderAddScreen> createState() => _ReminderAddScreenState();
}

class _ReminderAddScreenState extends State<ReminderAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _medicineIdController = TextEditingController();
  final _medicineNameController = TextEditingController();
  final List<TimeOfDay> _reminderTimes = [];

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
        if (state is ReminderSuccess) {
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
        final loading = state is ReminderLoading;

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: loading
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )
              : const Text('Simpan'),
          onPressed: () {
            if (loading) return;

            final addReminder = ReminderAdded(
              reminderContext: 'taking_medicine',
              referenceId: int.parse(_medicineIdController.text),
              referenceName: _medicineNameController.text,
              reminderTimes:
                  _reminderTimes.map((time) => time.format(context)).toList(),
            );

            context.read<ReminderBloc>().add(addReminder);
          },
        );
      },
    );
  }
}
