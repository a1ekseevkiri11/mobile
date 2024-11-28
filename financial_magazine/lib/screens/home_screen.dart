import 'package:flutter/material.dart';
import 'support_widget/footer_navigation_bar.dart';
import 'diagrams/circular_diagram.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Statistics')),
      ),
      body: Container(
        child: ListView(
          children: const [
            SizedBox(
              height: 550,
              child: CirculChart(
                type: true,
              ),
            ),
            SizedBox(
              height: 550,
              child: CirculChart(
                type: false,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FooterNavigationBar(
        currIndex: 1,
      ),
    );
  }
}
