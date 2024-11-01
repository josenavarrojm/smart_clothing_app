import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ladys_app/functions/mqtt_functions.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

final mqttService = MqttService();
String tempAlert = '';


void mqttProcess() async {
  await mqttService.connect('192.168.88.253', 1883, 'mqttx_App','pasante','1234');
  mqttService.subscribe('esp32/test');
  mqttService.listenToMessages();
  mqttService.publishMessage('esp32/test', 'Hello ESP32!');
}

/*
void mqttProcess() async {
  await mqttService.connect('192.168.88.253', 1883, 'mqttx_App','pasante','1234');
  mqttService.subscribe('esp32/test');
  mqttService.listenToMessages();
  mqttService.publishMessage('esp32/test', 'Hello ESP32!');
}
*/

class HomeUserPatient extends StatefulWidget {
  /*final bool isSelected;
  final IconData icon;
  final Duration duration;
  final List<Color> gradientColors;
  final EdgeInsets padding;*/

  const HomeUserPatient({
    super.key,
    /*required this.isSelected,
    required this.icon,
    this.duration = const Duration(milliseconds: 200),
    this.gradientColors = const [Colors.transparent, Colors.transparent],
    this.padding = const EdgeInsets.symmetric(horizontal: 0.0, vertical: 3.0),*/
  });

  @override
  _HomeUserPatient createState() => _HomeUserPatient();
}


class _HomeUserPatient extends State<HomeUserPatient> {

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
      ));
    });


    return AnimatedContainer(
      width: 500,
      duration: const Duration(milliseconds: 200), //duration,
      padding: true
          ? EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0)
          : null, //padding,
      decoration: BoxDecoration(
        borderRadius: true ? BorderRadius.circular(0.0) : BorderRadius.circular(0.0),
        gradient: true
            ? LinearGradient(
          colors: [
            Colors.pink.withOpacity(0.25),
            Colors.purple.withOpacity(0.25),
            Colors.red.withOpacity(0.25),
            Colors.orange.withOpacity(0.25),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.topRight,
        )
            : null,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              child: Container(
                width: screenWidth * 0.95,
                height: screenHeight * 0.2,
                alignment: Alignment.center,
                child: Text('Estado:'),
              ),
            ),
            Card(
              color: Colors.transparent.withOpacity(0.0),
              elevation: 0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                onPressed: () {
                  mqttProcess();
                },
                child: Text('Conectar a MQTT Broker'),
              ),
            ),
            Card(
              color: Colors.transparent.withOpacity(0.0),
              elevation: 0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                onPressed: () {
                  mqttService.publishMessage('esp32/test', 'Hola, he vuelto!');
                  print(tempAlert);
                },
                child: Text('SEND Message to MQTT Broker'),
              ),
            ),
            Card(
              child: Container(
                width: screenWidth * 0.95,
                height: screenHeight * 0.2,
                alignment: Alignment.center,
                child: SfSparkLineChart(
                  data: [1,2,5,4,12,3],
                  highPointColor: Colors.yellow,
                  axisLineColor: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}