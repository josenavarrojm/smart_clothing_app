import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartCardColumn extends StatefulWidget {
  final double widthFactor;
  final double heightFactor;
  final List<double> data;

  const ChartCardColumn({
    super.key,
    this.widthFactor = 0.95, // Factor de ancho por defecto
    this.heightFactor = 0.25, // Factor de altura por defecto
    this.data = const [1, 2, 5, 4, 12, 3, 7], // Datos por defecto
  });

  @override
  _ChartCardColumnState createState() => _ChartCardColumnState();
}

class _ChartCardColumnState extends State<ChartCardColumn> {
  late TrackballBehavior _trackballBehavior;

  final List<String> daysOfWeek = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  @override
  void initState() {
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.longPress,
      tooltipSettings: InteractiveTooltip(enable: true, color: Colors.red),
    );

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
        child: Container(
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
                color: Theme.of(context).primaryColor,
              ),
            ),
            primaryXAxis: CategoryAxis(
              labelStyle: GoogleFonts.wixMadeforText(
                fontSize: 10,
                letterSpacing: 2,
                fontWeight: FontWeight.w200,
                color: Theme.of(context).primaryColor,
              ),
              title: AxisTitle(
                text: 'Día',
                textStyle: GoogleFonts.wixMadeforText(
                  fontSize: 10,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w200,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              majorGridLines: MajorGridLines(
                dashArray: const [5, 5],
                color: Theme.of(context).scaffoldBackgroundColor,
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
              minimum: 0,
              maximum: 50,
              labelStyle: const TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
              majorGridLines: MajorGridLines(
                dashArray: const [5, 5],
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              axisLine: AxisLine(
                color: Theme.of(context).scaffoldBackgroundColor,
                width: 1,
              ),
              majorTickLines: MajorTickLines(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            series: <ColumnSeries<double, String>>[
              ColumnSeries<double, String>(
                animationDuration: 250,
                dataSource: widget.data,
                xValueMapper: (double value, int index) => daysOfWeek[index],
                yValueMapper: (double value, _) => value,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).colorScheme.tertiary.withOpacity(0.8),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  textStyle: GoogleFonts.lexend(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).primaryColorDark,
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
