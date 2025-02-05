import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartclothingproject/components/charts.dart';
import 'package:smartclothingproject/components/historic_chart_card.dart';
import 'package:smartclothingproject/functions/bluetooth_notifier_data.dart';

class HomeUserWorker extends StatefulWidget {
  final BlDataNotifier blDataNotifier;
  const HomeUserWorker({super.key, required this.blDataNotifier});

  @override
  _HomeUserWorker createState() => _HomeUserWorker();
}

class _HomeUserWorker extends State<HomeUserWorker> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).primaryColor,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final double tempCorpValue =
        double.tryParse(widget.blDataNotifier.temperatureCorporalData) ?? 0.0;
    final double tempAmbValue =
        double.tryParse(widget.blDataNotifier.temperatureAmbData) ?? 0.0;
    final double humidityValue =
        double.tryParse(widget.blDataNotifier.humidityData) ?? 0.0;
    final double timeData =
        double.tryParse(widget.blDataNotifier.timeData) ?? 0.0;
    final int bpmData = int.tryParse(widget.blDataNotifier.bpmData) ?? 0;
    final double anglePosition =
        double.tryParse(widget.blDataNotifier.accelerometerXData) ?? 0.0;

    // Formatea la fecha y hora (puedes personalizar el formato)
    String formattedDate = widget.blDataNotifier.dateTimeData;

    return AnimatedContainer(
        width: 500,
        duration: const Duration(milliseconds: 200), //duration,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0.0),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Card(
                  elevation: 0,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Text(
                    BlDataNotifier().deviceName != ''
                        ? 'Dispositivo conectado: ${BlDataNotifier().deviceName}'
                        : 'No hay Dispositivo conectado',
                    style: GoogleFonts.lexend(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ),
              Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Esquinas redondeadas
                  ),
                  elevation: 0,
                  child: AnimatedContainer(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        // Esquinas redondeadas
                        // border: Border.all(
                        //     color: Colors.black, width: 2), // Borde opcional
                      ),
                      duration: const Duration(milliseconds: 250),
                      // padding: const EdgeInsets.symmetric(
                      //     vertical: 15, horizontal: 35),
                      // width: screenWidth * 0.6,
                      height: screenHeight * 0.12,
                      width: screenWidth * 0.7,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            getPostureIcon(anglePosition),
                            size: 50,
                            color: getPostureIconColor(anglePosition, context),
                          ),
                          Text(
                            getPostureStatus(anglePosition),
                            style: GoogleFonts.lexend(
                                fontSize: 28,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      )),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const SectionHeader(title: 'Variables Ambientales'),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DataCard(
                        title: 'Temperatura Ambiental',
                        value: '${(tempAmbValue * 10).ceil() / 10}°C',
                        textColor: Theme.of(context).primaryColor),
                    DataCard(
                        title: 'Humedad',
                        value: '${(humidityValue * 10).ceil() / 10}%',
                        textColor: Theme.of(context).primaryColor),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SectionHeader(title: 'Variables Corporales'),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DataCard(
                        title: 'Temperatura  Corporal',
                        value: '${(tempCorpValue * 10).ceil() / 10}°C',
                        textColor: Theme.of(context).primaryColor),
                    DataCard(
                      title: 'BPM',
                      value: '$bpmData',
                      textColor: Theme.of(context).primaryColor,
                      icon: (Icons.favorite_rounded),
                      iconColor: Colors.red,
                    ),
                  ],
                ),
              ),
              DataCard(
                title: 'Inclinación',
                value: '${(anglePosition * 10).ceil() / 10}°',
                textColor: Theme.of(context).primaryColor,
                icon: (Icons.personal_injury_outlined),
                iconColor: Theme.of(context).primaryColor,
              ),
              const SizedBox(
                height: 20,
              ),
              const SectionHeader(title: 'Histórico de Variables Corporales'),
              const SizedBox(
                height: 15,
              ),
              HistoricChartCard(
                titleChart: 'Temperatura Corporal',
                minY: 20,
                maxY: 40,
                unitChart: 'Grados °C',
                time: 3,
                heightFactor: 0.35,
                data: (widget.blDataNotifier.historicoTempCorp.isNotEmpty)
                    ? widget.blDataNotifier.historicoTempCorp
                        .map((e) => e.toDouble())
                        .toList()
                    : [], // Lista por defecto si está vacía o null
              ),
              HistoricChartCard(
                titleChart: 'BPM',
                unitChart: 'Pulsaciones por minuto',
                minY: 40,
                maxY: 150,
                // time: timeData,
                heightFactor: 0.35,
                data: (widget.blDataNotifier.historicoBPM.isNotEmpty)
                    ? widget.blDataNotifier.historicoBPM
                        .map((e) => e.toDouble())
                        .toList()
                    : [], // Lista por defecto si está vacía o null
              ),
              ChartCard(
                titleChart: 'ECG',
                minY: -3,
                maxY: 3,
                time: timeData,
                heightFactor: 0.35,
                data: (widget.blDataNotifier.ecgDataApp.isNotEmpty)
                    ? widget.blDataNotifier.ecgDataApp
                        .map((e) => e.toDouble())
                        .toList()
                    : [], // Lista por defecto si está vacía o null
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  textAlign: TextAlign.center,
                  // 'lun, dic 23, 2024 - 09:04 a. m.',
                  formattedDate,
                  style: GoogleFonts.lexend(
                      fontSize: 22,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.watch_later_outlined,
                    color: Theme.of(context).primaryColor,
                    size: 18,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    'Última medición',
                    style: GoogleFonts.lexend(
                        fontSize: 18,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).primaryColor),
                  ),
                ],
              )),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                width: screenWidth * 0.7,
                alignment: Alignment.center,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        // side: const BorderSide(width: 0.0), // Borde negro
                      ),
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          'Exportar Datos',
                          style: GoogleFonts.lexend(
                              fontSize: 22,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.tertiary),
                        ),
                        Icon(
                          Icons.ios_share_outlined,
                          color: Theme.of(context).colorScheme.tertiary,
                        )
                      ],
                    )),
              )
            ],
          ),
        ));
  }
}

class DataCard extends StatelessWidget {
  final String title;
  final String value;
  final Color textColor;
  final IconData? icon; // Ícono opcional
  final Color? iconColor; // Color del ícono opcional

  const DataCard({
    super.key,
    required this.title,
    required this.value,
    required this.textColor,
    this.icon, // Icono opcional
    this.iconColor, // Color del ícono opcional
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.lexend(
                fontSize: MediaQuery.of(context).size.width * 0.046,
                fontWeight: FontWeight.w300,
                color: textColor,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: GoogleFonts.lexend(
                    fontSize: MediaQuery.of(context).size.width * 0.11,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                if (icon != null) // Mostrar el ícono solo si no es nulo
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      icon,
                      size: 32, // Tamaño del ícono
                      color: iconColor ??
                          textColor, // Usar `iconColor` o `textColor` por defecto
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String getPostureStatus(double? angle) {
  if (angle == null) return 'Postura Desconocida';
  return (angle >= 0 && angle <= 45.0) ? 'Buena Postura' : 'Mala Postura';
}

IconData getPostureIcon(double? angle) {
  if (angle == null) return Icons.question_mark;
  return (angle >= 0 && angle <= 45.0)
      ? Icons.check_circle_outline
      : Icons.warning_rounded;
}

Color getPostureIconColor(double? angle, BuildContext context) {
  if (angle == null) return Theme.of(context).primaryColor;
  return (angle >= 0 && angle <= 45.0)
      ? Colors.green
      : Theme.of(context).colorScheme.tertiary;
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.wixMadeforText(
            color: Theme.of(context).primaryColorLight,
            fontSize: MediaQuery.of(context).size.width * 0.065,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible,
          softWrap: true,
        ),
        Divider(
          color: Theme.of(context).primaryColorLight,
          thickness: 0.35,
          indent: 80.0,
          endIndent: 80.0,
        ),
      ],
    );
  }
}
