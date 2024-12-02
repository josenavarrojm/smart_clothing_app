import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class ChartCard extends StatelessWidget {
  final double widthFactor;
  final double heightFactor;
  final List<double> data;

  const ChartCard({
    super.key,
    this.widthFactor = 0.95, // Factor de ancho por defecto
    this.heightFactor = 0.2, // Factor de altura por defecto
    this.data = const [1, 2, 5, 4, 12, 3], // Datos por defecto
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        width: screenWidth * widthFactor,
        height: screenHeight * heightFactor,
        alignment: Alignment.center,
        child: SfSparkLineChart(
          data: data,
          highPointColor: Colors.yellow,
          axisLineColor: Colors.blue,
        ),
      ),
    );
  }
}
