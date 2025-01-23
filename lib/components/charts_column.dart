import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartCardColumn extends StatefulWidget {
  final double widthFactor;
  final double heightFactor;
  final List<double> data;

  const ChartCardColumn({
    super.key,
    this.widthFactor = 0.95,
    this.heightFactor = 0.25,
    this.data = const [1, 2, 5, 4, 12, 3, 7],
  });

  @override
  _ChartCardColumnState createState() => _ChartCardColumnState();
}

class _ChartCardColumnState extends State<ChartCardColumn> {
  late TrackballBehavior _trackballBehavior;

  final List<String> _daysOfWeek = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  @override
  void initState() {
    super.initState();
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.longPress,
      tooltipSettings:
          const InteractiveTooltip(enable: true, color: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Configuración compartida para estilos de texto
    final textStyle = GoogleFonts.wixMadeforText(
      fontSize: 10,
      letterSpacing: 2,
      fontWeight: FontWeight.w200,
      color: theme.primaryColor,
    );

    // Configuración compartida para las líneas del eje
    final gridLines = MajorGridLines(
      dashArray: const [5, 5],
      color: theme.scaffoldBackgroundColor,
    );

    final axisLine = AxisLine(
      color: theme.scaffoldBackgroundColor,
      width: 1,
    );

    final majorTickLines = MajorTickLines(color: theme.scaffoldBackgroundColor);

    return Card(
      color: theme.scaffoldBackgroundColor,
      elevation: 0,
      child: Center(
        child: SizedBox(
          width: screenWidth * widget.widthFactor,
          height: screenHeight * widget.heightFactor,
          child: SfCartesianChart(
            trackballBehavior: _trackballBehavior,
            tooltipBehavior: TooltipBehavior(enable: true),
            title: ChartTitle(
              text: 'Temperatura Promedio',
              textStyle: GoogleFonts.wixMadeforText(
                fontSize: 15,
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
                color: theme.primaryColor,
              ),
            ),
            primaryXAxis: CategoryAxis(
              labelStyle: textStyle,
              title: AxisTitle(text: 'Día', textStyle: textStyle),
              majorGridLines: gridLines,
              axisLine: axisLine,
              majorTickLines: majorTickLines,
            ),
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: 50,
              labelStyle: const TextStyle(fontSize: 10, color: Colors.black),
              majorGridLines: gridLines,
              axisLine: axisLine,
              majorTickLines: majorTickLines,
            ),
            series: <ColumnSeries<double, String>>[
              ColumnSeries<double, String>(
                animationDuration: 250,
                dataSource: widget.data,
                xValueMapper: (double value, int index) => _daysOfWeek[index],
                yValueMapper: (double value, _) => value,
                gradient: LinearGradient(
                  colors: [
                    theme.primaryColor,
                    theme.colorScheme.tertiary.withOpacity(0.8),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  textStyle: GoogleFonts.lexend(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: theme.primaryColorDark,
                  ),
                  labelAlignment: ChartDataLabelAlignment.outer,
                ),
                width: 0.6,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
