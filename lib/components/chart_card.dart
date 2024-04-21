import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../utils/chart_data.dart';
import 'custom_card.dart';

class ChartCard extends StatefulWidget {
  final List<ChartData> chartData;
  const ChartCard({
    super.key,
    required this.chartData,
  });

  @override
  State<ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends State<ChartCard> {
  late List<ChartData> _chartData;
  @override
  void initState() {
    _chartData = widget.chartData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Center(
        child: SfCircularChart(
            legend: Legend(isVisible: true, position: LegendPosition.right),
            series: <CircularSeries>[
              // Renders doughnut chart
              DoughnutSeries<ChartData, String>(
                  dataSource: _chartData,
                  //pointColorMapper: (ChartData data, _) => data.color,
                  xValueMapper: (ChartData data, _) => data.label,
                  yValueMapper: (ChartData data, _) => data.value,
                  strokeColor: Colors.white,
                  dataLabelMapper: (datum, index) => '${datum.percentage}%',
                  dataLabelSettings: const DataLabelSettings(
                      textStyle: TextStyle(fontSize: 12), isVisible: true)),
            ]),
      ),
    );
  }
}
