import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sipendi/src/models/reminder_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const classAssetMap = {
  'taking_medicine': 'assets/icon/meds.svg',
  'medical_record': 'assets/icon/list_alt.svg',
};

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final _supabase = Supabase.instance.client;
  List<ReminderModel>? _reminders;

  @override
  void initState() {
    super.initState();
    _getUserReminder(context);
  }

  Future<void> _getUserReminder(BuildContext context) async {
    try {
      final response =
          await _supabase.from('reminder').select('*, reminder_time(*)');

      setState(() {
        _reminders = ReminderModel.fromHashList(response);
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pengingat',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: _reminderList(context, reminders: _reminders),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bool? value = await context.push('/reminder/add');
          if ((value ?? false) && context.mounted) {
            _getUserReminder(context);
          }
        },
        tooltip: 'Tambah Pengingat',
        backgroundColor: const Color(0xFF75B79E),
        child: const Icon(
          Icons.add,
          color: Color(0xFFEEF9BF),
        ),
      ),
    );
  }

  List<Widget> _reminderList(BuildContext context,
      {List<ReminderModel>? reminders}) {
    if (reminders == null) return [];
    return reminders.fold([], (val, rem) {
      val.addAll([
        _reminderItem(
          context,
          reminder: rem,
        ),
        const SizedBox(height: 18),
      ]);
      return val;
    });
  }

  Widget _reminderItem(BuildContext context,
      {required ReminderModel reminder}) {
    return ElevatedButton(
      onPressed: () async {
        final bool? value = await context.push('/reminder/${reminder.id}');
        if ((value ?? false) && context.mounted) {
          _getUserReminder(context);
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
            classAssetMap[reminder.className] ?? 'assets/icon/meds.svg',
            width: 38,
          ),
          const SizedBox(width: 18),
          Text(
            reminder.classContext ?? 'Pengingat',
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
