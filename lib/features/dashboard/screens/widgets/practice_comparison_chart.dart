import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PracticeComparisonChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const PracticeComparisonChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Practice Comparison',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxValue(),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.blueGrey,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          rod.toY.toStringAsFixed(2),
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              data[value.toInt()]['name'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _createBarGroups(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  double _getMaxValue() {
    if (data.isEmpty) return 100; // Default max value if no data

    double max = 0;
    for (var practice in data) {
      final total = ((practice['udaEarnings'] as num? ?? 0) +
              (practice['hygieneEarnings'] as num? ?? 0) +
              (practice['privateEarnings'] as num? ?? 0))
          .toDouble();
      if (total > max) max = total;
    }
    return max > 0 ? max * 1.2 : 100; // Add 20% padding or use default
  }

  List<BarChartGroupData> _createBarGroups() {
    if (data.isEmpty) {
      return []; // Return empty list if no data
    }

    return List.generate(data.length, (index) {
      final practice = data[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (practice['udaEarnings'] as num? ?? 0).toDouble(),
            color: Colors.blue,
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
          BarChartRodData(
            toY: (practice['hygieneEarnings'] as num? ?? 0).toDouble(),
            color: Colors.green,
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
          BarChartRodData(
            toY: (practice['privateEarnings'] as num? ?? 0).toDouble(),
            color: Colors.orange,
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    });
  }

  Widget _buildLegend() {
    if (data.isEmpty) {
      return const SizedBox.shrink(); // Hide legend if no data
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('UDA', Colors.blue),
        const SizedBox(width: 16),
        _buildLegendItem('Hygiene', Colors.green),
        const SizedBox(width: 16),
        _buildLegendItem('Private', Colors.orange),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
