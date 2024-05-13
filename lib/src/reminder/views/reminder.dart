import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../bloc/reminder_bloc.dart';
import '../models/reminder.dart';

const contextAssetMap = {
  'taking_medicine': 'assets/icon/meds.svg',
  'medical_record': 'assets/icon/list_alt.svg',
};

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengingat'),
      ),
      body: SafeArea(
        child: BlocConsumer<ReminderBloc, ReminderState>(
            bloc: BlocProvider.of<ReminderBloc>(context)
              ..add(ReminderFetched()),
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
              final loading =
                  state is ReminderInitial || state is ReminderLoading;

              if (state.reminders.isEmpty) {
                if (loading) {
                  return _loading(context);
                }

                return _empty(context);
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: state.reminders.length,
                itemBuilder: (context, index) => _reminderItem(
                  context,
                  reminder: state.reminders.elementAt(index),
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bool? value = await context.push('/reminder/add');
          if ((value ?? false) && context.mounted) {
            // _getUserReminder(context);
          }
        },
        tooltip: 'Tambah Pengingat',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _reminderItem(BuildContext context, {required Reminder reminder}) {
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
          // _getUserReminder(context);
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
              Text(reminderTitle),
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

  Widget _loading(BuildContext context) {
    return const Center(
      heightFactor: 8,
      child: CircularProgressIndicator(),
    );
  }
}
