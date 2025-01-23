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
      enable: true,
      activationMode: ActivationMode.longPress,
      tooltipSettings:
          const InteractiveTooltip(enable: true, color: Colors.red),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Estilos reutilizables
    final defaultTextStyle = GoogleFonts.wixMadeforText(
      fontSize: 15,
      letterSpacing: 2,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).primaryColor,
    );

    final axisLabelTextStyle = GoogleFonts.wixMadeforText(
      fontSize: 10,
      letterSpacing: 2,
      fontWeight: FontWeight.w200,
      color: Theme.of(context).primaryColor,
    );

    final gridLineColor = Theme.of(context).primaryColorLight.withOpacity(0.4);
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Card(
      color: backgroundColor,
      elevation: 0,
      child: Center(
        child: SizedBox(
          width: screenWidth * widget.widthFactor,
          height: screenHeight * widget.heightFactor,
          child: widget.data.isEmpty
              ? Center(
                  child: Text(
                    'No data available yet',
                    textAlign: TextAlign.center,
                    style: defaultTextStyle,
                  ),
                )
              : SfCartesianChart(
                  trackballBehavior: _trackballBehavior,
                  tooltipBehavior: TooltipBehavior(enable: true),
                  title: ChartTitle(
                    text: widget.titleChart,
                    textStyle: defaultTextStyle,
                  ),
                  primaryXAxis: NumericAxis(
                    minimum: 0,
                    maximum: widget.time,
                    axisLabelFormatter: (details) {
                      return ChartAxisLabel(
                        '${(details.value / 1000).toStringAsFixed(0)}s',
                        axisLabelTextStyle,
                      );
                    },
                    labelStyle: axisLabelTextStyle,
                    title: AxisTitle(
                      text: 'Tiempo',
                      textStyle: axisLabelTextStyle,
                    ),
                    majorGridLines: MajorGridLines(
                      dashArray: const [5, 5],
                      color: gridLineColor,
                    ),
                    axisLine: AxisLine(
                      color: backgroundColor,
                      width: 1,
                    ),
                    majorTickLines: MajorTickLines(
                      color: backgroundColor,
                    ),
                  ),
                  primaryYAxis: NumericAxis(
                    minimum: widget.minY,
                    maximum: widget.maxY,
                    labelStyle: const TextStyle(
                      fontSize: 0,
                      color: Colors.transparent,
                    ),
                    majorGridLines: MajorGridLines(
                      dashArray: const [5, 5],
                      color: gridLineColor,
                    ),
                    axisLine: AxisLine(
                      color: backgroundColor,
                      width: 1,
                    ),
                    majorTickLines: MajorTickLines(
                      color: backgroundColor,
                    ),
                  ),
                  series: <SplineSeries<double, int>>[
                    SplineSeries<double, int>(
                      animationDuration: 0,
                      animationDelay: 0,
                      dataSource: widget.data,
                      xValueMapper: (value, index) =>
                          ((index / widget.data.length) * widget.time).toInt(),
                      yValueMapper: (value, _) => value,
                      onCreateShader: (details) {
                        return LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.tertiary,
                            Theme.of(context).primaryColor,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(details.rect);
                      },
                      width: 1.2,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
