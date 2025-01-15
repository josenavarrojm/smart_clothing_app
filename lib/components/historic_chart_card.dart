import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HistoricChartCard extends StatefulWidget {
  final String titleChart;
  final String unitChart;
  final double time;
  final double maxY;
  final double minY;
  final double widthFactor;
  final double heightFactor;
  final List<double> data;

  const HistoricChartCard({
    super.key,
    this.titleChart = '',
    this.unitChart = '',
    this.time = 0.0,
    this.maxY = 0.0,
    this.minY = 0.0,
    this.widthFactor = 0.95, // Ancho
    this.heightFactor = 0.25, // Altura
    this.data = const [], // Datos de ECG
  });

  @override
  _HistoricChartCardState createState() => _HistoricChartCardState();
}

class _HistoricChartCardState extends State<HistoricChartCard> {
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
          child: widget.data.length < 2
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      Text('No data avalaible yet',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.wixMadeforText(
                              fontSize: 15,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor))
                    ])
              : SfCartesianChart(
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
                    minimum: 1,
                    maximum: widget.data.length.toDouble(),
                    labelStyle: GoogleFonts.wixMadeforText(
                        fontSize: 10,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w200,
                        color: Theme.of(context).primaryColor),
                    title: AxisTitle(
                      textStyle: GoogleFonts.wixMadeforText(
                          fontSize: 15,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w200,
                          color: Theme.of(context).primaryColor),
                    ),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    majorGridLines: MajorGridLines(
                      dashArray: const [5, 5],
                      color:
                          Theme.of(context).primaryColorLight.withOpacity(0.4),
                    ),
                    axisLine: AxisLine(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 1,
                    ),
                    majorTickLines: MajorTickLines(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                  primaryYAxis: NumericAxis(
                    labelStyle: TextStyle(
                      fontSize: 10, // Tamaño de fuente 0 para ocultar etiquetas
                      color: Theme.of(context)
                          .primaryColor, // Color transparente para asegurarse de que no se muestren
                    ),
                    title: AxisTitle(
                      text: widget.unitChart,
                      textStyle: GoogleFonts.wixMadeforText(
                          fontSize: 12,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w200,
                          color: Theme.of(context).primaryColor),
                    ),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    minimum: widget.minY,
                    maximum: widget.maxY,
                    majorGridLines: MajorGridLines(
                      dashArray: const [5, 5], // También en el eje Y
                      color:
                          Theme.of(context).primaryColorLight.withOpacity(0.4),
                    ),
                    axisLine: AxisLine(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor, // Cambia el color del eje X
                      width: 1, // Cambia el grosor de la línea del eje X
                    ),
                    majorTickLines: MajorTickLines(
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                  series: <SplineSeries<double, int>>[
                    SplineSeries<double, int>(
                      animationDuration: 1000,
                      animationDelay: 500,
                      dataSource: widget.data, // Fuente de datos
                      xValueMapper: (double value, int index) => index + 1,
                      yValueMapper: (double value, _) => value,

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
