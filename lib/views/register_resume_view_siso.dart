import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smartclothingproject/components/charts.dart';
// import 'package:smartclothingproject/components/historic_chart_card.dart';
import 'package:smartclothingproject/functions/bluetooth_notifier_data.dart';
import 'package:smartclothingproject/functions/update_notifiers_sensor_data.dart';
import 'package:smartclothingproject/handlers/mongo_database.dart';
import 'package:smartclothingproject/views/home_user_worker.dart';

class RegisterResumeView extends StatefulWidget {
  final Map<String, dynamic> register;
  const RegisterResumeView({
    super.key,
    required this.register,
  });

  get blDataNotifier => null;

  @override
  _RegisterResumeViewState createState() => _RegisterResumeViewState();
}

class _RegisterResumeViewState extends State<RegisterResumeView> {
  late Map<String, dynamic> register;

  @override
  void initState() {
    super.initState();
    register = widget.register;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        formattedDataNew();
      });
    });
  }

  void getUserData(Map<String, dynamic> user) async {
    final mongoService = Provider.of<MongoService>(context, listen: false);
    await mongoService.connect();
  }

  void formattedDataNew() {
    if (register["timestamp"] != null) {
      register["timestamp"] = register["timestamp"].toInt();
    } else {
      register["timestamp"] = 0; // O un valor predeterminado adecuado
    }

    DateTime fecha =
        DateTime.fromMillisecondsSinceEpoch((register["timestamp"]));

    register.remove('timestamp');
    register["created_at"] =
        DateFormat('EEE, MMM d, yyyy - hh:mm a').format(fecha);
    updateNotifiersSensorData(register);
    print(register['ecg']);
  }

  @override
  Widget build(BuildContext context) {
    final double tempCorpValue =
        double.tryParse(BlDataNotifier().temperatureCorporalData) ?? 0.0;
    final double tempAmbValue =
        double.tryParse(BlDataNotifier().temperatureAmbData) ?? 0.0;
    // final double humidityValue =
    //     double.tryParse(BlDataNotifier().humidityData) ?? 0.0;
    final double timeData = double.tryParse(BlDataNotifier().timeData) ?? 0.0;
    final int bpmData = int.tryParse(BlDataNotifier().bpmData) ?? 0;
    final double anglePosition =
        double.tryParse(BlDataNotifier().accelerometerXData) ?? 0.0;

    // Formatea la fecha y hora (puedes personalizar el formato)
    String formattedDate = BlDataNotifier().dateTimeData;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          child: AnimatedContainer(
            width: 500,
            duration: const Duration(milliseconds: 200), //duration,
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0),
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
                              Icon(
                                getPostureIcon(anglePosition),
                                size: 50,
                                color:
                                    getPostureIconColor(anglePosition, context),
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
                  // const SectionHeader(title: 'Variables Ambientales'),
                  const SectionHeader(title: 'Variables de monitoreo'),

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
                            title: 'Temperatura  Corporal',
                            value: '${(tempCorpValue * 10).ceil() / 10}°C',
                            textColor: Theme.of(context).primaryColor),
                        // DataCard(
                        //     title: 'Humedad',
                        //     value: '${(humidityValue * 10).ceil() / 10}%',
                        //     textColor: Theme.of(context).primaryColor),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // const SectionHeader(title: 'Variables Corporales'),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DataCard(
                          title: 'BPM',
                          value: '$bpmData',
                          textColor: Theme.of(context).primaryColor,
                          icon: (Icons.favorite_rounded),
                          iconColor: Colors.red,
                        ),
                        DataCard(
                          title: 'Inclinación',
                          value: '${(anglePosition * 10).ceil() / 10}°',
                          textColor: Theme.of(context).primaryColor,
                          icon: (Icons.personal_injury_outlined),
                          iconColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SectionHeader(
                      title: 'Histórico de Variables Corporales'),
                  const SizedBox(
                    height: 15,
                  ),
                  // HistoricChartCard(
                  //   titleChart: 'Temperatura Corporal',
                  //   minY: 20,
                  //   maxY: 40,
                  //   unitChart: 'Grados °C',
                  //   time: 3,
                  //   heightFactor: 0.35,
                  //   data: (widget.blDataNo)
                  //       ? BlDataNotifier().historicoTempCorp
                  //           .map((e) => e.toDouble())
                  //           .toList()
                  //       : [], // Lista por defecto si está vacía o null
                  // ),
                  // HistoricChartCard(
                  //   titleChart: 'BPM',
                  //   unitChart: 'Pulsaciones por minuto',
                  //   minY: 40,
                  //   maxY: 150,
                  //   // time: timeData,
                  //   heightFactor: 0.35,
                  //   data: (BlDataNotifier().historicoBPM.isNotEmpty)
                  //       ? BlDataNotifier().historicoBPM
                  //           .map((e) => e.toDouble())
                  //           .toList()
                  //       : [], // Lista por defecto si está vacía o null
                  // ),
                  ChartCard(
                    titleChart: 'ECG',
                    minY: -2,
                    maxY: 2,
                    time: timeData,
                    heightFactor: 0.35,
                    data: (BlDataNotifier().ecgDataApp.isNotEmpty)
                        ? BlDataNotifier()
                            .ecgDataApp
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
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
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
            ),
          ),
        ),
      ),
    );
  }
}
