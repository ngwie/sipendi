import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../patient_medicine/bloc/patient_medicine_bloc.dart';
import '../../utils/alarm_notification.dart';
import '../../utils/sqlite_db.dart';
import '../../widgets/icon/alarm.dart';
import '../bloc/reminder_bloc.dart';
import '../models/reminder.dart';
import '../models/reminder_model.dart';
import '../models/reminder_time.dart';

class ReminderEditScreen extends StatefulWidget {
  final String id;

  const ReminderEditScreen({super.key, required this.id});

  @override
  State<ReminderEditScreen> createState() => _ReminderEditScreenState();
}

class _ReminderEditScreenState extends State<ReminderEditScreen> {
  Future<void> _removeReminder() async {
    final reminderTimesHash = await SqliteDb.client.query(
      'reminder_time',
      where: 'reminder_id = ?',
      whereArgs: [widget.id],
    );

    final reminderTimes = ReminderTimeModel.formHashList(reminderTimesHash);

    for (var reminderTime in reminderTimes) {
      await AlarmNotification.cancel(id: reminderTime.id);
    }

    await SqliteDb.client.delete(
      'reminder_time',
      where: 'reminder_id = ?',
      whereArgs: [widget.id],
    );

    await SqliteDb.client.delete(
      'reminder',
      where: 'id = ?',
      whereArgs: [widget.id],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Hapus Pengingat',
              onPressed: () => _showAlertDialog(context),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: _reminderBlocConsumer(context));
  }

  Widget _reminderBlocConsumer(BuildContext context) {
    return BlocConsumer<ReminderBloc, ReminderState>(
      bloc: BlocProvider.of<ReminderBloc>(context)..add(ReminderFetched()),
      listener: (context, state) {
        if (state is! ReminderError) return;

        final errorMessage =
            state.error != '' ? state.error : 'Unexpected error occurred';

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
          behavior: SnackBarBehavior.floating,
        ));
      },
      builder: (context, state) {
        final reminderLoading =
            state is ReminderInitial || state is ReminderLoading;
        final reminder = state.reminders.firstWhereOrNull(
            (reminder) => reminder.id.toString() == widget.id);

        return _patientMedicineBlocConsumer(
          context,
          reminder: reminder,
          reminderLoading: reminderLoading,
        );
      },
    );
  }

  Widget _patientMedicineBlocConsumer(BuildContext context,
      {required bool reminderLoading, Reminder? reminder}) {
    return BlocConsumer<PatientMedicineBloc, PatientMedicineState>(
      bloc: BlocProvider.of<PatientMedicineBloc>(context)
        ..add(PatientMedicineFetched()),
      listener: (context, state) {
        if (state is! PatientMedicineError) return;

        final errorMessage =
            state.error != '' ? state.error : 'Unexpected error occurred';

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
          behavior: SnackBarBehavior.floating,
        ));
      },
      builder: (context, state) {
        final patientMedicineLoading =
            state is PatientMedicineInitial || state is PatientMedicineLoading;
        final loading = reminderLoading || patientMedicineLoading;

        final patientMedicine = state.patientMedicines.firstWhereOrNull(
            (patientMedicine) => patientMedicine.id == reminder?.referenceId);

        print(state.patientMedicines.length);

        return SingleChildScrollView(
          child: Column(
            children: [
              _hero(context, loading: loading, reminder: reminder),
              const SizedBox(height: 20),
              _reminderTimeList(context, reminder: reminder),
            ],
          ),
        );
      },
    );
  }

  Widget _hero(BuildContext context,
      {required bool loading, Reminder? reminder}) {
    return Container(
      padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...(loading
                ? [
                    const SizedBox(height: 20),
                    Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ]
                : [
                    Center(
                      child: SvgPicture.asset('assets/icon/reminder.svg',
                          width: 64),
                    ),
                  ]),
            const SizedBox(height: 24),
            ...(reminder != null
                ? [
                    Text(
                      reminder.referenceName ?? '',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    Text(
                      'Obat Setelah Makan',
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    Text(
                      'Setiap hari, 2x Sehari',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ]
                : []),
          ],
        ),
      ),
    );
  }

  Widget _reminderTimeList(BuildContext context, {Reminder? reminder}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Waktu Pemakaian',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ...(reminder?.times ?? []).fold(
            [],
            (mem, time) => [
              ...mem,
              _reminderTimeItem(context, reminderTime: time),
              const SizedBox(height: 16),
            ],
          )
        ],
      ),
    );
  }

  Widget _reminderTimeItem(BuildContext context,
      {required ReminderTime reminderTime}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Row(
        children: [
          const AlarmIcon(width: 32),
          const SizedBox(width: 16),
          Text(
            reminderTime.time.format(context),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
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
          await _removeReminder();

          if (context.mounted) {
            Navigator.pop(context);
            context.pop(true);
          }
        } catch (error) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Gagal menghapus pengingat'),
              behavior: SnackBarBehavior.floating,
            ));
          }
        }
      },
    );

    AlertDialog removeConfirmationAlert = AlertDialog(
      title: const Text('Hapus Pengingat'),
      content: const Text('Apakah anda yakin ingin menghapus pengingat'),
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
