import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
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
                      children: [
                        _lastRecordItem(
                          context,
                          value: 128.toString(),
                          unit: 'mg/dL',
                          label: 'Normal',
                        ),
                      ],
                    ),
                    const SizedBox(height: 44),
                    _lastRecordTime(context, time: '16.00. 27/09/2021'),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Container(
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
            ),
            const SizedBox(height: 32),
            Container(
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
                    // Initialize category axis
                    primaryXAxis: DateTimeAxis(),

                    series: <LineSeries<_ChartData, DateTime>>[
                      LineSeries<_ChartData, DateTime>(
                        // Bind data source
                        dataSource: <_ChartData>[
                          _ChartData(DateTime(1925), 415),
                          _ChartData(DateTime(1926), 408),
                          _ChartData(DateTime(1927), 415),
                          _ChartData(DateTime(1928), 350),
                          _ChartData(DateTime(1929), 375),
                          _ChartData(DateTime(1930), 500),
                          _ChartData(DateTime(1931), 390),
                          _ChartData(DateTime(1932), 450),
                          _ChartData(DateTime(1933), 440),
                          _ChartData(DateTime(1934), 350),
                          _ChartData(DateTime(1935), 400),
                          _ChartData(DateTime(1936), 365),
                          _ChartData(DateTime(1937), 490),
                          _ChartData(DateTime(1938), 400),
                          _ChartData(DateTime(1939), 520),
                          _ChartData(DateTime(1940), 510),
                          _ChartData(DateTime(1941), 395),
                          _ChartData(DateTime(1942), 380),
                          _ChartData(DateTime(1943), 404),
                          _ChartData(DateTime(1944), 400),
                          _ChartData(DateTime(1945), 500),
                        ],
                        xValueMapper: (_ChartData sales, _) => sales.x,
                        yValueMapper: (_ChartData sales, _) => sales.y,
                        // Enable data label
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                      )
                    ],
                  ),
                ],
              ),
            ),
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

    return Column(
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
    );
  }

  Widget _lastRecordTime(context, {required String time}) {
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
          time,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ],
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final DateTime x;
  final double y;
}
