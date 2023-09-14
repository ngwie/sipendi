import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sipendi/src/models/reminder_model.dart';
import 'package:sipendi/src/utils/alarm_notification.dart';
import 'package:sipendi/src/utils/sqlite_db.dart';

class ReminderEditScreen extends StatefulWidget {
  final String id;

  const ReminderEditScreen({super.key, required this.id});

  @override
  State<ReminderEditScreen> createState() => _ReminderEditScreenState();
}

class _ReminderEditScreenState extends State<ReminderEditScreen> {
  Future<ReminderModel> _getReminder() async {
    final reminders = await SqliteDb.client.query(
      'reminder',
      where: 'id = ?',
      whereArgs: [widget.id],
    );
    final reminderTimes = await SqliteDb.client.query(
      'reminder_time',
      where: 'reminder_id = ?',
      whereArgs: [widget.id],
    );

    return ReminderModel.fromHash({
      ...reminders.first,
      'time_list': reminderTimes,
    });
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Hapus Pengingat',
            onPressed: () => _showAlertDialog(context),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: FutureBuilder(
              future: _getReminder(),
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
                  return _reminderDetail(context, snapshot.data!);
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

  Widget _reminderDetail(BuildContext context, ReminderModel reminder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          reminder.referenceName ?? 'Pengingat',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 18),
        Text(
          'Waktu Pemakaian',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 8,
          children: [
            ...List<Widget>.generate(
              reminder.times.length,
              (int index) => InputChip(
                label: Text(
                  reminder.times[index].time.format(context),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
                avatar: Icon(
                  Icons.alarm,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
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
