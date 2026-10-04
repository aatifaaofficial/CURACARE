import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/health_record.dart';
import '../theme/app_theme.dart';

class HealthProgressChart extends StatefulWidget {
  const HealthProgressChart({super.key, required this.records});

  final List<HealthRecord> records;

  @override
  State<HealthProgressChart> createState() => _HealthProgressChartState();
}

class _HealthProgressChartState extends State<HealthProgressChart> {
  int _rangeDays = 7;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final firstDay = todayStart.subtract(Duration(days: _rangeDays - 1));
    final records = widget.records.where((record) {
      final date = DateTime.tryParse(record.date);
      return date != null && !date.isBefore(firstDay) && !date.isAfter(todayStart.add(const Duration(days: 1)));
    }).toList()
      ..sort((first, second) => DateTime.parse(first.date).compareTo(DateTime.parse(second.date)));

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), boxShadow: const [BoxShadow(color: Color(0x0819324D), blurRadius: 14, offset: Offset(0, 5))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Health Progress', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.ink)),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 7, label: Text('7 Days')),
              ButtonSegment(value: 30, label: Text('30 Days')),
            ],
            selected: {_rangeDays},
            onSelectionChanged: (selection) => setState(() => _rangeDays = selection.first),
            showSelectedIcon: false,
            style: const ButtonStyle(visualDensity: VisualDensity.compact),
          ),
        ]),
        const SizedBox(height: 8),
        const Text('Pain level trend', style: TextStyle(fontSize: 11, color: AppTheme.muted)),
        const SizedBox(height: 14),
        if (records.isEmpty)
          const SizedBox(
            height: 155,
            child: Center(child: Text('No health records in this period.', style: TextStyle(color: AppTheme.muted))),
          )
        else
          SizedBox(height: 155, child: LineChart(LineChartData(
          minY: 0,
          maxY: 10,
          minX: 0,
          maxX: (records.length - 1).clamp(1, records.length).toDouble(),
          gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 2, getDrawingHorizontalLine: (_) => const FlLine(color: Color(0xFFEAF0F6), strokeWidth: 1)),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 22, interval: 2, getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(color: AppTheme.muted, fontSize: 10)))),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 22, interval: records.length > 7 ? (records.length / 7).ceilToDouble() : 1, getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= records.length) return const SizedBox.shrink();
              final date = DateTime.parse(records[index].date);
              return Padding(padding: const EdgeInsets.only(top: 8), child: Text('${date.month}/${date.day}', style: const TextStyle(color: AppTheme.muted, fontSize: 10)));
            })),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [LineChartBarData(
            spots: [for (var index = 0; index < records.length; index++) FlSpot(index.toDouble(), records[index].painLevel.toDouble())],
            isCurved: true,
            color: AppTheme.teal,
            barWidth: 3,
            dotData: FlDotData(show: true, getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(radius: 4, color: Colors.white, strokeColor: AppTheme.teal, strokeWidth: 2)),
            belowBarData: BarAreaData(show: true, color: AppTheme.teal.withValues(alpha: 0.10)),
          )],
        ))),
      ]),
    );
  }
}
