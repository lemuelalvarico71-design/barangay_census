import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  static List<ChartData> _calculateLinearRegression(List<ChartData> data) {
    if (data.length < 2) return [];

    double sumX = 0, sumY = 0, sumXY = 0, sumXSquare = 0;
    int n = data.length;

    for (var point in data) {
      sumX += point.x;
      sumY += point.y;
      sumXY += point.x * point.y;
      sumXSquare += point.x * point.x;
    }

    double slope = (n * sumXY - sumX * sumY) / (n * sumXSquare - sumX * sumX);
    double intercept = (sumY - slope * sumX) / n;

    List<ChartData> regressionPoints = [];
    int minX = data.map((e) => e.x).reduce((a, b) => a < b ? a : b);
    int maxX = data.map((e) => e.x).reduce((a, b) => a > b ? a : b);
    regressionPoints.add(ChartData(minX, (slope * minX + intercept).round()));
    regressionPoints.add(ChartData(maxX, (slope * maxX + intercept).round()));

    return regressionPoints;
  }

  @override
  Widget build(BuildContext context) {
    final barData = [
      ChartData(0, 2000, 'Population'),
      ChartData(1, 400, 'Households'),
    ];
    final regressionData = _calculateLinearRegression([
      ChartData(0, 2000),
      ChartData(2, 1900),
      ChartData(3, 1950),
    ]);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Summary Statistics',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Population:', style: TextStyle(fontSize: 16)),
                        const Text('2000', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Households:', style: TextStyle(fontSize: 16)),
                        const Text('400', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Last Updated: 10/22/2025 02:50 PM PST',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
  height: 300,
  child: SfCartesianChart(
    primaryXAxis: NumericAxis(),
    primaryYAxis: NumericAxis(
      labelStyle: const TextStyle(color: Colors.black),
      majorGridLines: const MajorGridLines(color: Colors.grey),
    ),
    series: <CartesianSeries<ChartData, num>>[
      ColumnSeries<ChartData, num>(
        dataSource: barData,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
        color: const Color.fromRGBO(0, 0, 255, 1),
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      ),
      LineSeries<ChartData, num>(
        dataSource: regressionData,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
        color: const Color.fromRGBO(255, 0, 0, 1),
        width: 2,
      ),
    ],
    selectionGesture: ActivationMode.none,
  ),
)

          ],
        ),
      
    );
  }
}

class ChartData {
  final int x;
  final int y;
  final String? category;

  ChartData(this.x, this.y, [this.category]);
}