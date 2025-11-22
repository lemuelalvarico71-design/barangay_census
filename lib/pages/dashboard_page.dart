import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/db_helper.dart';

class DashboardPage extends StatefulWidget {
  final String fullname;
  const DashboardPage({super.key, required this.fullname});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  List<FlSpot> actualData = [];
  List<FlSpot> predictedData = [];
  bool isLoading = true;
  String errorMessage = '';
  int projected2035 = 0;
  String avgAnnualGrowth = '0.0';
  String totalGrowthRate = '0.0';
  int currentPopulation = 0;
int currentHouseholds = 0;
int currentYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);
    _loadAndPredictPopulation();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


Future<void> _loadAndPredictPopulation() async {
  setState(() => isLoading = true);

  try {
    final db = DBHelper.instance;
    currentYear = DateTime.now().year;  // Always up-to-date

    final Map<int, int> yearPopulation = {};
    final Map<int, int> yearHouseholds = {};

    // Fetch data from 2015 to current year
    for (int year = 2015; year <= currentYear; year++) {
      final results = await db.query(
        '''
        SELECT 
          COALESCE(SUM(total_members), 0) as total_pop,
          COUNT(*) as household_count 
        FROM households 
        WHERE census_year = ?
        ''',
        [year],
      );

      final row = results.isNotEmpty ? results.first : null;
      final int pop = row != null && row[0] != null ? (row[0] as num).toInt() : 0;
      final int hh = row != null && row[1] != null ? (row[1] as num).toInt() : 0;

      if (pop > 0 || hh > 0) {
        yearPopulation[year] = pop;
        yearHouseholds[year] = hh;
      }
    }

    // Build actual data for chart
    actualData = yearPopulation.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
        .toList();

    if (actualData.length < 2) {
      setState(() {
        errorMessage = 'Not enough data for prediction (need 2+ years)';
        isLoading = false;
      });
      return;
    }

    // Linear Regression
    final reg = _performLinearRegression(actualData);
    final slope = reg['slope']!;
    final intercept = reg['intercept']!;

    // Predict next 10 years
    final lastYear = actualData.last.x.toInt();
    predictedData = [];
    for (int i = 1; i <= 10; i++) {
      final year = lastYear + i;
      final pop = (slope * year + intercept).round();
      predictedData.add(FlSpot(year.toDouble(), pop.toDouble()));
    }

    // Get current year real stats
    currentPopulation = yearPopulation[currentYear] ?? actualData.last.y.toInt();
    currentHouseholds = yearHouseholds[currentYear] ?? 0;

    // Projection stats
    projected2035 = (slope * 2035 + intercept).round();
    final growth10yr = projected2035 - currentPopulation;
    totalGrowthRate = ((growth10yr / currentPopulation) * 100).toStringAsFixed(1);
    avgAnnualGrowth = ((growth10yr / 10) / currentPopulation * 100).toStringAsFixed(2);

    setState(() => isLoading = false);
  } catch (e) {
    setState(() {
      errorMessage = 'Error: $e';
      isLoading = false;
    });
  }
}

  Map<String, double> _performLinearRegression(List<FlSpot> points) {
    final n = points.length;
    final sumX = points.map((p) => p.x).reduce((a, b) => a + b);
    final sumY = points.map((p) => p.y).reduce((a, b) => a + b);
    final sumXY = points.map((p) => p.x * p.y).reduce((a, b) => a + b);
    final sumX2 = points.map((p) => p.x * p.x).reduce((a, b) => a + b);

    final slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    final intercept = (sumY - slope * sumX) / n;

    return {'slope': slope, 'intercept': intercept};
  }

  double get minY {
    final all = [...actualData, ...predictedData];
    return all.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 200;
  }

  double get maxY {
    final all = [...actualData, ...predictedData];
    return all.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 300;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('Welcome, ${widget.fullname}!'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade700,
        elevation: 1,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadAndPredictPopulation),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
              : FadeTransition(
                  opacity: _animation,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Barangay Dr. Jose Rizal - Population Growth Forecast',
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),

                        // Current Stats
                        Row(
                        
                          children: [
                            _buildStatCard("Current Population", actualData.last.y.toInt().toString(), Colors.blue),
                            SizedBox(width: 10,), 
                           _buildStatCard("Households ($currentYear)", currentHouseholds.toString(), Colors.teal),
                            SizedBox(width: 10,), 
                            _buildStatCard("Last Census Year", actualData.last.x.toInt().toString(), Colors.purple),
                            SizedBox(width: 10,), 
                            _buildStatCard("Data Points Used", actualData.length.toString(), Colors.orange),
                          ],
                        ),

                        const SizedBox(height: 24),

                        Text(
                          'Population Trend & 10-Year Forecast (Linear Regression)',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 16),

                        // Chart
                        Container(
                          height: 400,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.08), blurRadius: 12)],
                          ),
                          child: LineChart(
  LineChartData(
    minY: minY,
    maxY: maxY,
    gridData: FlGridData(
      show: true,
      horizontalInterval: 200,
      getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade300, strokeWidth: 1),
    ),
    borderData: FlBorderData(show: false),
    titlesData: FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          interval: 1, // Show every year
          getTitlesWidget: (value, meta) {
            final year = value.toInt();
            // Only show labels for actual + predicted years
            final allYears = [
              ...actualData.map((e) => e.x.toInt()),
              ...predictedData.map((e) => e.x.toInt()),
            ];
            if (allYears.contains(year)) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  year.toString(),
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          interval: 200,
          getTitlesWidget: (value, meta) {
            return Text(
              value.toInt().toString(),
              style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
            );
          },
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    ),
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            final year = spot.x.toInt();
            final isPredicted = year > actualData.last.x.toInt();
            return LineTooltipItem(
              '$year\n${spot.y.toInt()} residents',
              TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              children: [
                TextSpan(
                  text: isPredicted ? ' (Projected)' : ' (Actual)',
                  style: TextStyle(
                    color: isPredicted ? Colors.orange.shade200 : Colors.blue.shade200,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            );
          }).toList();
        },
      ),
    ),
    lineBarsData: [
      // Actual Data
      LineChartBarData(
        spots: actualData,
        isCurved: true,
        color: Colors.blue.shade600,
        barWidth: 4,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.2)),
      ),
      // Predicted Data (Dashed)
      LineChartBarData(
        spots: predictedData,
        isCurved: true,
        color: Colors.red.shade600,
        barWidth: 3,
        dashArray: [10, 6],
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: true, color: Colors.red.withOpacity(0.15)),
      ),
    ],
  ),
),
                        ),

                        const SizedBox(height: 24),

                        // Forecast Summary
                        Row(
                          children: [
                            Expanded(child: _buildStatCard("Projected 2035", projected2035.toString(), Colors.red)),
                            SizedBox(width: 10,), 
                            Expanded(child: _buildStatCard("10-Yr Growth", "$totalGrowthRate%", Colors.indigo)),
                            SizedBox(width: 10,), 
                            Expanded(child: _buildStatCard("Avg Annual Growth", "$avgAnnualGrowth%", Colors.green)),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(color: Colors.black87, fontSize: 15),
                                children: [
                                  const TextSpan(text: "Based on "),
                                  TextSpan(text: "Linear Regression", style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const TextSpan(text: " of actual census data from "),
                                  TextSpan(text: "${actualData.first.x.toInt()}–${actualData.last.x.toInt()}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const TextSpan(text: ", the population is projected to reach "),
                                  TextSpan(text: "$projected2035", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                                  const TextSpan(text: " by 2035, with an average annual growth rate of "),
                                  TextSpan(text: "$avgAnnualGrowth%", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                                  const TextSpan(text: "."),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildStatCard(String title, String value, MaterialColor color) {
    return Expanded(
      child: Card(
        color: Colors.white,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color.shade700)),
              const SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}