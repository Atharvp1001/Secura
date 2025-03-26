// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const Color primaryColor = Color(0xFF06303E); // Text Color
  static const Color backgroundColor = Color(0xFFCAE6D3); // Background
  static const Color accentColor = Color(0xFFFF4136); // Icon & Accent

  late final List<BarChartGroupData> barGroups = _createBarGroups();

  List<BarChartGroupData> _createBarGroups() {
    return [
      _createBarGroup(0, 2, Colors.red),
      _createBarGroup(1, 5, Colors.orange),
      _createBarGroup(2, 8, Colors.yellow),
      _createBarGroup(3, 12, Colors.green),
    ];
  }

  BarChartGroupData _createBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 25,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  static const List<String> chartTitles = ['Critical', 'High', 'Medium', 'Low'];

  Widget _buildTitle(double value, TitleMeta meta) {
    return Text(
      chartTitles[value.toInt()],
      style: const TextStyle(color: primaryColor, fontSize: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildSecurityScoreCard(),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Quick Actions'),
                  const SizedBox(height: 12),
                  _buildQuickActionsGrid(),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Vulnerability Breakdown'),
                  const SizedBox(height: 12),
                  _buildVulnerabilityChart(),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Recent Alerts'),
                  const SizedBox(height: 12),
                  _buildAlertsList(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Last scan: 2 hours ago',
                style: TextStyle(
                  color: primaryColor.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          CircleAvatar(
            backgroundColor: accentColor,
            child: IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityScoreCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Security Score',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.info_outline, color: primaryColor),
              ],
            ),
            const SizedBox(height: 20),
            CircularPercentIndicator(
              radius: 80.0,
              lineWidth: 12.0,
              animation: true,
              percent: 0.75,
              center: const Text(
                "75%",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: accentColor,
              backgroundColor: Colors.grey[300]!,
            ),
            const SizedBox(height: 20),
            const Text(
              'Good',
              style: TextStyle(
                color: primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '3 issues need your attention',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: primaryColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.5,
      children: [
        _buildQuickActionCard('Start Scan', Icons.security, () {}),
        _buildQuickActionCard('View Report', Icons.assessment, () {}),
        _buildQuickActionCard('Settings', Icons.settings, () {}),
        _buildQuickActionCard('Help', Icons.help_outline, () {}),
      ],
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      color: accentColor.withOpacity(0.2),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: accentColor, size: 28),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVulnerabilityChart() {
    return SizedBox(
      height: 200,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 20,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: _buildTitle,
                  ),
                ),
              ),
              barGroups: barGroups,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlertsList() {
    return Column(
      children: [
        _buildAlertCard('Critical', 'Outdated system security patch', '2 hours ago', Colors.red),
        _buildAlertCard('High', 'Insecure WiFi network detected', '3 hours ago', Colors.orange),
      ],
    );
  }

  Widget _buildAlertCard(String severity, String message, String time, Color severityColor) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: severityColor),
        title: Text(
          message,
          style: const TextStyle(color: primaryColor, fontSize: 14),
        ),
        subtitle: Text(
          time,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }
}
