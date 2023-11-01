import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../bloc/medical_record_bloc.dart';
import '../models/medical_record.dart';
import '../models/medical_record_type.dart';
import '../models/medical_record_page_type.dart';

class MedicalRecordDetailScreen extends StatelessWidget {
  final String pageTypeName;

  const MedicalRecordDetailScreen({super.key, required this.pageTypeName});

  @override
  Widget build(BuildContext context) {
    final pageType = MedicalRecordPageType.values.byName(pageTypeName);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      body: BlocBuilder<MedicalRecordBloc, MedicalRecordState>(
          bloc: BlocProvider.of<MedicalRecordBloc>(context)
            ..add(MedicalRecordFetched(types: pageType.resourceTypes)),
          builder: (context, state) {
            final loading = state.status == MedicalRecordStateStatus.loading;
            final records = state.medicalRecords
                .where((record) => pageType.resourceTypes.contains(record.type))
                .toList();

            // records are empty and state is loading, show loading state
            // records are empty and state isn't loading or error, show N/a data
            // records aren't empty, render the records
            return SingleChildScrollView(
              child: Column(children: [
                _hero(
                  context,
                  pageType: pageType,
                  medicalRecords: records,
                  loading: loading,
                ),
                const SizedBox(height: 18),
                _addRecord(context),
                const SizedBox(height: 32),
                _chart(
                  context,
                  pageType: pageType,
                  medicalRecords: records,
                  loading: loading,
                ),
              ]),
            );
          }),
    );
  }

  Widget _hero(
    BuildContext context, {
    bool loading = false,
    required MedicalRecordPageType pageType,
    required List<MedicalRecord> medicalRecords,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32.0),
          bottomRight: Radius.circular(32.0),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: loading && medicalRecords.isEmpty
                  ? [
                      SizedBox(
                        height: 103,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      )
                    ]
                  : pageType.resourceTypes.map((resourceType) {
                      if (medicalRecords.isEmpty) {
                        return _lastRecordItem(
                          context,
                          value: 'N/A',
                          label: resourceType.label(),
                        );
                      }

                      final record = medicalRecords
                          .firstWhere((record) => record.type == resourceType);

                      return _lastRecordItem(
                        context,
                        value: record.value,
                        unit: resourceType.unit,
                        label: resourceType.label(val: int.parse(record.value)),
                      );
                    }).toList(),
            ),
            const SizedBox(height: 44),
            _lastRecordTime(
              context,
              time: medicalRecords.isNotEmpty
                  ? DateFormat('HH.ss, dd/MM/yyyy ')
                      .format(medicalRecords.first.createdAt)
                  : null,
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  Widget _lastRecordItem(
    BuildContext context, {
    required String value,
    String label = '',
    String unit = '',
  }) {
    final isUnitInline = unit == '%';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          Text(
            isUnitInline ? '$value%' : value,
            style: TextStyle(
              fontSize: isUnitInline ? 64 : 48,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          ...(!isUnitInline
              ? [
                  Text(
                    unit,
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  )
                ]
              : []),
        ],
      ),
    );
  }

  Widget _lastRecordTime(context, {String? time}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Waktu Rekam',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          time ?? '-',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ],
    );
  }

  Widget _addRecord(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add),
            Text(
              'Rekam Data',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        onPressed: () async {
          context.push('/medical-record/$pageTypeName/add');
        },
      ),
    );
  }

  Widget _chart(
    BuildContext context, {
    bool loading = false,
    required MedicalRecordPageType pageType,
    required List<MedicalRecord> medicalRecords,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Riwayat',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 8),
          SfCartesianChart(
            primaryXAxis: DateTimeAxis(),
            series: pageType.resourceTypes.map((resourceType) {
              final records = medicalRecords
                  .where((record) => record.type == resourceType)
                  .toList();

              return LineSeries<MedicalRecord, DateTime>(
                dataSource: records,
                xValueMapper: (MedicalRecord record, _) => record.createdAt,
                yValueMapper: (MedicalRecord record, _) =>
                    double.parse(record.value),
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
