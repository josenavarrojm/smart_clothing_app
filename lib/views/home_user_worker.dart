import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartclothingproject/controllers/mqtt_functions.dart';
import 'package:smartclothingproject/functions/bluetooth_notifier_data.dart';
import 'package:smartclothingproject/views/bluetooth_dialog_state.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
// import 'package:smartclothingproject/controllers/BLE/bluetooth_services.dart';

final mqttService = MqttService();
String tempAlert = '';

// void mqttProcess() async {
//   await mqttService.connect(
//       '192.168.88.253', 1883, 'mqttx_App', 'pasante', '1234');
//   mqttService.subscribe('esp32/test');
//   mqttService.listenToMessages();
//   mqttService.publishMessage('esp32/test', 'Hello ESP32!');
// }

class HomeUserWorker extends StatefulWidget {
  final BlDataNotifier blDataNotifier;
  const HomeUserWorker({super.key, required this.blDataNotifier
      /*required this.isSelected,
    required this.icon,
    this.duration = const Duration(milliseconds: 200),
    this.gradientColors = const [Colors.transparent, Colors.transparent],
    this.padding = const EdgeInsets.symmetric(horizontal: 0.0, vertical: 3.0),*/
      });

  @override
  _HomeUserWorker createState() => _HomeUserWorker();
}

class _HomeUserWorker extends State<HomeUserWorker> {
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
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0.0),
          gradient: LinearGradient(
            colors: [
              Colors.pink.withOpacity(0.25),
              Colors.purple.withOpacity(0.25),
              const Color.fromARGB(255, 24, 241, 0).withOpacity(0.25),
              Colors.blue.withOpacity(0.25),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.topRight,
          ),
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
                  child: Text(widget.blDataNotifier.accelerometerXData),
                ),
              ),
              Card(
                child: Container(
                  width: screenWidth * 0.95,
                  height: screenHeight * 0.2,
                  alignment: Alignment.center,
                  child: SfSparkLineChart(
                    data: const [1, 2, 5, 4, 12, 3],
                    highPointColor: Colors.yellow,
                    axisLineColor: Colors.blue,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        elevation: 30,
                        content: TextButton(
                          onPressed: () {
                            showCustomToast(
                                widget.blDataNotifier.temperatureData);
                          },
                          child: const Text('Toast'),
                        ),
                      );
                    },
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ],
          ),
        ));
  }
}
