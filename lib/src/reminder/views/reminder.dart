import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../models/reminder_model.dart';

import '../../utils/sqlite_db.dart';

const contextAssetMap = {
  'taking_medicine': 'assets/icon/meds.svg',
  'medical_record': 'assets/icon/list_alt.svg',
};

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  List<ReminderModel> _reminders = [];

  @override
  void initState() {
    super.initState();
    _getUserReminder(context);
  }

  Future<void> _getUserReminder(BuildContext context) async {
    try {
      final reminders = await SqliteDb.client.query('reminder');
      final reminderTimes = await SqliteDb.client.query('reminder_time');

      final List<dynamic> res = reminders.map((reminder) {
        final times = reminderTimes
            .where((time) => time['reminder_id'] == reminder['id'])
            .toList();
        return {...reminder, 'time_list': times};
      }).toList();

      setState(() {
        _reminders = ReminderModel.fromHashList(res);
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
      appBar: AppBar(
        title: const Text('Pengingat'),
      ),
      body: SafeArea(
        child: Builder(builder: (context) {
          // TODO: add loading view

          if (_reminders.isEmpty) {
            return _empty(context);
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _reminders.length,
            itemBuilder: (context, index) => _reminderItem(
              context,
              reminder: _reminders[index],
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bool? value = await context.push('/reminder/add');
          if ((value ?? false) && context.mounted) {
            _getUserReminder(context);
          }
        },
        tooltip: 'Tambah Pengingat',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _reminderItem(
    BuildContext context, {
    required ReminderModel reminder,
  }) {
    final String reminderIcon =
        contextAssetMap[reminder.context] ?? 'assets/icon/meds.svg';
    final String reminderTitle = reminder.referenceName ?? 'Pengingat';
    final String reminderTimes = reminder.times
        .map((reminderTime) => reminderTime.time.format(context))
        .join(', ');

    return ElevatedButton(
      onPressed: () async {
        final bool? value = await context.push('/reminder/${reminder.id}');
        if ((value ?? false) && context.mounted) {
          _getUserReminder(context);
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(reminderIcon, width: 32),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reminderTitle,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 2),
              Text(
                reminderTimes,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _empty(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icon/reminder.svg',
            width: 100,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 20),
          Text(
            'Belum ada pengingat',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 56, width: double.infinity),
        ],
      ),
    );
  }
}
