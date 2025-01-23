import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Widget que muestra una tarjeta con un gráfico histórico
/// basado en datos proporcionados.
class HistoricChartCard extends StatefulWidget {
  final String titleChart; // Título del gráfico.
  final String unitChart; // Unidad del eje Y.
  final double time; // Tiempo máximo en el eje X.
  final double maxY; // Valor máximo en el eje Y.
  final double minY; // Valor mínimo en el eje Y.
  final double
      widthFactor; // Factor de ancho relativo al tamaño de la pantalla.
  final double
      heightFactor; // Factor de altura relativo al tamaño de la pantalla.
  final List<double> data; // Lista de datos a graficar.

  const HistoricChartCard({
    super.key,
    this.titleChart = '',
    this.unitChart = '',
    this.time = 0.0,
    this.maxY = 0.0,
    this.minY = 0.0,
    this.widthFactor = 0.95, // Por defecto, 95% del ancho de la pantalla.
    this.heightFactor = 0.25, // Por defecto, 25% de la altura de la pantalla.
    this.data = const [], // Lista vacía por defecto.
  });

  @override
  _HistoricChartCardState createState() => _HistoricChartCardState();
}

class _HistoricChartCardState extends State<HistoricChartCard> {
  late TrackballBehavior _trackballBehavior;

  @override
  void initState() {
    super.initState();
    // Configuración del trackball (para interacciones con el gráfico).
    _trackballBehavior = TrackballBehavior(
      enable: true, // Activa el trackball.
      activationMode:
          ActivationMode.longPress, // Se activa con un toque prolongado.
      tooltipSettings: const InteractiveTooltip(
        enable: true, // Activa las tooltips.
        color: Colors.red, // Color de las tooltips.
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtiene las dimensiones de la pantalla.
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      color: Theme.of(context).scaffoldBackgroundColor, // Fondo según el tema.
      elevation: 0, // Sin sombra.
      child: Center(
        child: SizedBox(
          // Dimensiones ajustadas según los factores proporcionados.
          width: screenWidth * widget.widthFactor,
          height: screenHeight * widget.heightFactor,
          // Si no hay suficientes datos, muestra un mensaje.
          child: widget.data.length < 2
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No data available yet', // Mensaje predeterminado.
                      textAlign: TextAlign.center,
                      style: GoogleFonts.wixMadeforText(
                        fontSize: 15,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                )
              // Si hay datos, renderiza el gráfico.
              : SfCartesianChart(
                  trackballBehavior: _trackballBehavior,
                  tooltipBehavior:
                      TooltipBehavior(enable: true), // Activa tooltips.
                  title: ChartTitle(
                    text: widget.titleChart, // Título del gráfico.
                    textStyle: GoogleFonts.wixMadeforText(
                      fontSize: 15,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  primaryXAxis: NumericAxis(
                    minimum: 1,
                    maximum: widget.data.length.toDouble(),
                    labelStyle: GoogleFonts.wixMadeforText(
                      fontSize: 10,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w200,
                      color: Theme.of(context).primaryColor,
                    ),
                    edgeLabelPlacement:
                        EdgeLabelPlacement.shift, // Evita superposición.
                    majorGridLines: MajorGridLines(
                      dashArray: const [5, 5], // Líneas punteadas en el eje X.
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
                      fontSize: 10, // Tamaño de texto del eje Y.
                      color: Theme.of(context).primaryColor,
                    ),
                    title: AxisTitle(
                      text: widget.unitChart, // Unidad del eje Y.
                      textStyle: GoogleFonts.wixMadeforText(
                        fontSize: 12,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w200,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    minimum: widget.minY,
                    maximum: widget.maxY,
                    majorGridLines: MajorGridLines(
                      dashArray: const [5, 5], // Líneas punteadas en el eje Y.
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
                  series: <SplineSeries<double, int>>[
                    SplineSeries<double, int>(
                      animationDuration: 0, // Sin animación.
                      animationDelay: 0,
                      dataSource: widget.data, // Datos para la serie.
                      xValueMapper: (double value, int index) => index + 1,
                      yValueMapper: (double value, _) => value,
                      onCreateShader: (ShaderDetails details) {
                        // Gradiente en la línea del gráfico.
                        return LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.tertiary,
                            Theme.of(context).primaryColor,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(details.rect);
                      },
                      width: 1.2, // Grosor de la línea.
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
