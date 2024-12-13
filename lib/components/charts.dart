import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class ChartCard extends StatelessWidget {
  final double widthFactor;
  final double heightFactor;
  final List<double> data;

  const ChartCard({
    super.key,
    this.widthFactor = 0.95, // Factor de ancho por defecto
    this.heightFactor = 0.25, // Factor de altura por defecto
    this.data = const [1, 2, 5, 4, 12, 3], // Datos por defecto
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double maxValue = data.reduce((a, b) => a > b ? a : b);
    double minValue = data.reduce((a, b) => a < b ? a : b);

    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        width: screenWidth * widthFactor,
        height: screenHeight * heightFactor,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  // Etiquetas del eje Y
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      5, // Número de divisiones en el eje Y
                      (index) => Text(
                        '${(((((-maxValue + minValue) / 2) * (index) + maxValue + 0.665) * 100).ceil() / 100)}', // Ejemplo de valores del eje Y
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Gráfico SparkLine
                  Expanded(
                    child: SfSparkLineChart(
                      data: data,
                      axisLineColor: Colors.grey,
                      color: Colors.black,
                      axisLineDashArray: [5, 5], // Línea discontinua
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Etiquetas del eje X
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                5, // Etiquetas dinámicas basadas en la longitud de los datos
                (index) => Text(
                  '$index S', // Ejemplo de etiquetas del eje X
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// return Card(
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         width: screenWidth * widthFactor,
//         height: screenHeight * heightFactor,
//         alignment: Alignment.center,
//         child: SfSparkLineChart(
//           data: data,
//           axisLineColor: Colors.grey,
//           color: Colors.black,
//         ),
//       ),
//     );
