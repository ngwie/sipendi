import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../bloc/consultation_bloc.dart';
import '../models/consultation.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: BlocConsumer<ConsultationBloc, ConsultationState>(
          bloc: BlocProvider.of<ConsultationBloc>(context)
            ..add(ConsultationFetched()),
          listenWhen: (previous, current) =>
              previous.status == ConsultationStatus.loading,
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            // consultations aren't empty, show the consultation
            if (state.consultations.isNotEmpty) {
              return _itemList(context, consultations: state.consultations);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Konsultasi',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                // consultations are empty and state is initial, show loading
                // consultations are empty and state is not initial, show empty state
                state.status == ConsultationStatus.initial
                    ? _loading(context)
                    : _empty(context),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/consultation/add'),
        tooltip: 'Tambah Konsultasi/Keluhan',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _itemList(
    BuildContext context, {
    required Set<Consultation> consultations,
  }) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Konsultasi',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          ...consultations.map(
              (consultation) => _item(context, consultation: consultation)),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, {required Consultation consultation}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            consultation.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            consultation.body,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          // TODO: go to thread messages
        ],
      ),
    );
  }

  Widget _loading(BuildContext context) {
    return const Center(
      heightFactor: 8,
      child: CircularProgressIndicator(
        color: Color(0xFF75B79E),
      ),
    );
  }

  Widget _empty(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icon/chat.svg',
            width: 100,
          ),
          const SizedBox(
            height: 22,
            width: double.infinity,
          ),
          Text(
            'Belum ada konsultasi atau keluhan',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(
            height: 56,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
