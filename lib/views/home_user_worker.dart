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
    double variablesTextSize = screenWidth * 0.046;
    double dataTextSize = screenWidth * 0.11;
    double subtitleSize = screenWidth * 0.065;

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
                          !(double.tryParse(
                                      BlDataNotifier().accelerometerXData) ==
                                  null)
                              ? (double.tryParse(BlDataNotifier()
                                              .accelerometerXData)! <=
                                          45.0 &&
                                      double.tryParse(BlDataNotifier()
                                              .accelerometerXData)! >=
                                          0.0)
                                  ? const Icon(
                                      Icons.check_circle_outline,
                                      size: 50,
                                      color: Colors.green,
                                    )
                                  : Icon(
                                      Icons.warning_rounded,
                                      size: 50,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    )
                              : Icon(
                                  Icons.question_mark,
                                  size: 50,
                                  color: Theme.of(context).primaryColor,
                                ),
                          Text(
                            !(double.tryParse(
                                        BlDataNotifier().accelerometerXData) ==
                                    null)
                                ? (double.tryParse(BlDataNotifier()
                                                .accelerometerXData)! <=
                                            45.0 &&
                                        double.tryParse(BlDataNotifier()
                                                .accelerometerXData)! >=
                                            0.0)
                                    ? 'Buena Postura'
                                    : 'Mala Postura'
                                : 'Postura Desconocida',
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
              Center(
                child: Text(
                  'Variables Ambientales',
                  style: GoogleFonts.wixMadeforText(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: subtitleSize,
                      fontWeight: FontWeight.w400,
                      wordSpacing: 0),
                ),
              ),
              Divider(
                color: Theme.of(context).primaryColorLight, // Color de la línea
                thickness: 0.35, // Grosor de la línea
                indent: 80.0, // Espaciado desde el lado izquierdo
                endIndent: 80.0, // Espaciado desde el lado derecho
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
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
                          // width: screenWidth * 0.4,
                          height: screenHeight * 0.1,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                'Temperatura Ambiental',
                                style: GoogleFonts.lexend(
                                    fontSize: variablesTextSize,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w300,
                                    color: Theme.of(context).primaryColor),
                              ),
                              Text(
                                '${(tempAmbValue * 10).ceil() / 10}°C',
                                style: GoogleFonts.lexend(
                                    fontSize: dataTextSize,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          )),
                    ),
                    Card(
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
                          // width: screenWidth * 0.45,
                          height: screenHeight * 0.15,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                'Humedad',
                                style: GoogleFonts.lexend(
                                    fontSize: variablesTextSize,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w300,
                                    color: Theme.of(context).primaryColor),
                              ),
                              Text(
                                '${(humidityValue * 10).ceil() / 10}%',
                                style: GoogleFonts.lexend(
                                    fontSize: dataTextSize,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Text(
                  'Variables Corporales',
                  style: GoogleFonts.wixMadeforText(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: subtitleSize,
                      fontWeight: FontWeight.w400,
                      wordSpacing: 0),
                ),
              ),
              Divider(
                color: Theme.of(context).primaryColorLight, // Color de la línea
                thickness: 0.35, // Grosor de la línea
                indent: 80.0, // Espaciado desde el lado izquierdo
                endIndent: 80.0, // Espaciado desde el lado derecho
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
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
                          // width: screenWidth * 0.4,
                          height: screenHeight * 0.1,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                'Temperatura  Corporal',
                                style: GoogleFonts.lexend(
                                    fontSize: variablesTextSize,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w300,
                                    color: Theme.of(context).primaryColor),
                              ),
                              Text(
                                '${(tempCorpValue * 10).ceil() / 10}°C',
                                style: GoogleFonts.lexend(
                                    fontSize: dataTextSize,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          )),
                    ),
                    Card(
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
                          // width: screenWidth * 0.45,
                          height: screenHeight * 0.15,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'BPM',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lexend(
                                    fontSize: variablesTextSize,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w300,
                                    color: Theme.of(context).primaryColor),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '$bpmData',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lexend(
                                        fontSize: dataTextSize,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  const Icon(
                                    Icons.favorite_rounded,
                                    color: Colors.red,
                                    size: 35,
                                  )
                                ],
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              ),
              Card(
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
                    // width: screenWidth * 0.4,
                    height: screenHeight * 0.1,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          'Inclinación',
                          style: GoogleFonts.lexend(
                              fontSize: variablesTextSize,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w300,
                              color: Theme.of(context).primaryColor),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${(anglePosition * 10).ceil() / 10}°',
                              style: GoogleFonts.lexend(
                                  fontSize: dataTextSize,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).primaryColor),
                            ),
                            Icon(Icons.personal_injury_outlined,
                                color: Theme.of(context).primaryColor, size: 35)
                          ],
                        )
                      ],
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              // ChartCard(
              //   titleChart: 'Etiquetas',
              //   minY: 0,
              //   maxY: 3000,
              //   time: widget.blDataNotifier.ecgDataIDApp.length.toDouble(),
              //   heightFactor: 0.35,
              //   data: (widget.blDataNotifier.ecgDataIDApp.isNotEmpty)
              //       ? widget.blDataNotifier.ecgDataIDApp
              //           .map((e) => e.toDouble())
              //           .toList()
              //       : asd, // Lista por defecto si está vacía o null
              // ),

              // ChartCardColumn(
              //   // widthFactor: 0.4,
              //   heightFactor: 0.35,
              //   // data: List<double>.from(widget.blDataNotifier.ecgDataApp),
              //   data: asdTem,
              // ),
              Center(
                child: Text(
                  'Histórico de Variables Corporales',
                  style: GoogleFonts.wixMadeforText(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: subtitleSize,
                      fontWeight: FontWeight.w400,
                      wordSpacing: 0),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ),
              Divider(
                color: Theme.of(context).primaryColorLight, // Color de la línea
                thickness: 0.35, // Grosor de la línea
                indent: 80.0, // Espaciado desde el lado izquierdo
                endIndent: 80.0, // Espaciado desde el lado derecho
              ),
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
