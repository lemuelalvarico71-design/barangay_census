import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatefulWidget {
  final String fullname;

  const DashboardPage({super.key, required this.fullname});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Historical population data (actual)
  final List<FlSpot> populationData = const [
    FlSpot(2015, 1500),
    FlSpot(2016, 1600),
    FlSpot(2017, 1750),
    FlSpot(2018, 1900),
    FlSpot(2019, 2100),
    FlSpot(2020, 2300),
    FlSpot(2021, 2450),
    FlSpot(2022, 2600),
    FlSpot(2023, 2800),
  ];

  // Predicted population data (next 10 years using Linear Regression)
  final List<FlSpot> predictedData = const [
    FlSpot(2024, 2900),
    FlSpot(2025, 3050),
    FlSpot(2026, 3200),
    FlSpot(2027, 3350),
    FlSpot(2028, 3500),
    FlSpot(2029, 3675),
    FlSpot(2030, 3850),
    FlSpot(2031, 4020),
    FlSpot(2032, 4200),
    FlSpot(2033, 4400),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get minY {
    final all = [...populationData, ...predictedData];
    return all.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 200;
  }

  double get maxY {
    final all = [...populationData, ...predictedData];
    return all.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 200;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Example summary stats (you can replace with regression results)
    final projected2033 = predictedData.last.y.toInt();
    final growthRate =
        ((projected2033 - populationData.last.y) / populationData.last.y * 100)
            .toStringAsFixed(1);
    final avgAnnualGrowth =
        ((projected2033 - populationData.last.y) / 10 / populationData.last.y * 100)
            .toStringAsFixed(1);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('📊 Welcome, ${widget.fullname}!'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade700,
        elevation: 1,
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _animation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Barangay Census Dashboard Overview',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E1E2F),
                ),
              ),
              const SizedBox(height: 24),

              // Responsive Stat Cards (current demographics)
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    return Column(
                      children: [
                        _buildStatCard("Total Population", "2,800", Colors.blue),
                        const SizedBox(height: 12),
                        _buildStatCard("Households", "520", Colors.teal),
                        const SizedBox(height: 12),
                        _buildStatCard("Employed Residents", "1,900", Colors.amber),
                        const SizedBox(height: 12),
                        _buildStatCard("Children (Below 18)", "1,100", Colors.brown),
                      ],
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildStatCard("Total Population", "2,800", Colors.blue),
                        ),
                        Expanded(
                          child: _buildStatCard("Households", "520", Colors.teal),
                        ),
                        Expanded(
                          child: _buildStatCard("Employed Residents", "1,900", Colors.amber),
                        ),
                        Expanded(
                          child: _buildStatCard("Children (Below 18)", "1,100", Colors.brown),
                        ),
                      ],
                    );
                  }
                },
              ),

              const SizedBox(height: 40),

              Text(
                'Population Growth & Projection (2015–2033)',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E1E2F),
                ),
              ),
              const SizedBox(height: 16),

              // Chart Section: Actual + Predicted
              Expanded(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, _) {
                    final animatedActual = populationData
                        .map((e) => FlSpot(e.x, e.y * _animation.value))
                        .toList();
                    final animatedPredicted = predictedData
                        .map((e) => FlSpot(e.x, e.y * _animation.value))
                        .toList();

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: LineChart(
                        LineChartData(
                          minY: minY,
                          maxY: maxY,
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            horizontalInterval: 200,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.grey.shade300,
                              strokeWidth: 1,
                            ),
                            getDrawingVerticalLine: (value) => FlLine(
                              color: Colors.grey.shade300,
                              strokeWidth: 1,
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: (value, meta) => Text(
                                  value.toInt().toString(),
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 200,
                                reservedSize: 45,
                                getTitlesWidget: (value, meta) => Text(
                                  value.toInt().toString(),
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          lineBarsData: [
                            // Actual Data
                            LineChartBarData(
                              isCurved: true,
                              color: Colors.blue.shade600,
                              spots: animatedActual,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.blue.shade100.withOpacity(0.5),
                              ),
                            ),
                            // Predicted Data
                            LineChartBarData(
                              isCurved: true,
                              color: Colors.orange.shade600,
                              spots: animatedPredicted,
                              barWidth: 3,
                              dashArray: [6, 3],
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.orange.shade100.withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Projection Summary Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: _buildStatCard(
                          "Projected Population (2033)",
                          projected2033.toString(),
                          Colors.orange)),
                  Expanded(
                      child: _buildStatCard(
                          "10-Year Growth Rate", "$growthRate%", Colors.indigo)),
                  Expanded(
                      child: _buildStatCard(
                          "Avg Annual Growth", "$avgAnnualGrowth%", Colors.green)),
                ],
              ),

              const SizedBox(height: 24),

              // Insight Panel
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Based on linear regression analysis, the barangay population is expected "
                    "to grow from ${populationData.last.y.toInt()} in 2023 to approximately "
                    "$projected2033 by 2033, reflecting an average annual growth rate of "
                    "$avgAnnualGrowth%.",
                    style:
                        TextStyle(fontSize: 14, color: Colors.grey.shade800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable Stat Card
  Widget _buildStatCard(String title, String value, MaterialColor color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color.shade700,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}