import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartCard extends StatefulWidget {
  final String titleChart;
  final double time;
  final double maxY;
  final double minY;
  final double widthFactor;
  final double heightFactor;
  final List<double> data;

  const ChartCard({
    super.key,
    this.titleChart = '',
    this.time = 0.0,
    this.maxY = 0.0,
    this.minY = 0.0,
    this.widthFactor = 0.95, // Ancho
    this.heightFactor = 0.25, // Altura
    this.data = const [1, 2, 5, 4, 12, 3], // Datos de ECG
  });

  @override
  _ChartCardState createState() => _ChartCardState();
}

class _ChartCardState extends State<ChartCard> {
  late TrackballBehavior _trackballBehavior;

  @override
  void initState() {
    _trackballBehavior = TrackballBehavior(
        // Enables the trackball
        enable: true,
        activationMode: ActivationMode.longPress,
        tooltipSettings:
            const InteractiveTooltip(enable: true, color: Colors.red));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      child: Center(
        child: SizedBox(
          // padding: const EdgeInsets.all(10),
          width: screenWidth * widget.widthFactor,
          height: screenHeight * widget.heightFactor,
          child: SfCartesianChart(
            trackballBehavior: _trackballBehavior,
            tooltipBehavior: TooltipBehavior(enable: true),
            title: ChartTitle(
                text: widget.titleChart,
                textStyle: GoogleFonts.wixMadeforText(
                    fontSize: 15,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor)),
            primaryXAxis: NumericAxis(
              minimum: 0,
              maximum: widget.time,
              axisLabelFormatter: (AxisLabelRenderDetails details) {
                // Divide cada valor por 1000 y agrégale 's'
                return ChartAxisLabel(
                    '${(details.value / 1000).toStringAsFixed(0)}s',
                    GoogleFonts.wixMadeforText(
                      fontSize: 10,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w200,
                      color: Theme.of(context).primaryColor,
                    ));
              },
              labelStyle: GoogleFonts.wixMadeforText(
                  fontSize: 10,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w200,
                  color: Theme.of(context).primaryColor),
              title: AxisTitle(
                text: 'Tiempo',
                textStyle: GoogleFonts.wixMadeforText(
                    fontSize: 15,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w200,
                    color: Theme.of(context).primaryColor),
              ),
              majorGridLines: MajorGridLines(
                dashArray: const [5, 5], // Estilo punteado [longitud, espacio]
                color: Theme.of(context).primaryColorLight.withOpacity(0.4),
              ),
              axisLine: AxisLine(
                color: Theme.of(context)
                    .scaffoldBackgroundColor, // Cambia el color del eje X
                width: 1, // Cambia el grosor de la línea del eje X
              ),
              majorTickLines: MajorTickLines(
                  color: Theme.of(context).scaffoldBackgroundColor),
            ),
            primaryYAxis: NumericAxis(
                labelStyle: const TextStyle(
                  fontSize: 0, // Tamaño de fuente 0 para ocultar etiquetas
                  color: Colors
                      .transparent, // Color transparente para asegurarse de que no se muestren
                ),
                minimum: widget.minY,
                maximum: widget.maxY,
                majorGridLines: MajorGridLines(
                  dashArray: const [5, 5], // También en el eje Y
                  color: Theme.of(context).primaryColorLight.withOpacity(0.4),
                ),
                axisLine: AxisLine(
                  color: Theme.of(context)
                      .scaffoldBackgroundColor, // Cambia el color del eje X
                  width: 1, // Cambia el grosor de la línea del eje X
                ),
                majorTickLines: MajorTickLines(
                    color: Theme.of(context).scaffoldBackgroundColor)),
            series: <SplineSeries<double, int>>[
              SplineSeries<double, int>(
                animationDuration: 1000,
                animationDelay: 500,
                dataSource: widget.data, // Fuente de datos
                xValueMapper: (double value, int index) =>
                    ((index / widget.data.length) * widget.time).toInt(),
                yValueMapper: (double value, _) =>
                    value, // Valor de la lista como eje Y
                // markerSettings:
                //     const MarkerSettings(isVisible: true // Marca los puntos
                //         ),
                onCreateShader: (ShaderDetails details) {
                  return LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.tertiary,
                      Theme.of(context).primaryColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(details.rect);
                },
                // color: Theme.of(context).colorScheme.tertiary,
                width: 1.2, // Grosor de la línea
              ),
            ],
          ),
        ),
      ),
    );
  }
}
