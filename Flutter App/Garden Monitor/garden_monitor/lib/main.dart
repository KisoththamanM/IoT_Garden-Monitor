import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

void main() {
  runApp(MaterialApp(home: GardenMonitor(), debugShowCheckedModeBanner: false));
}

class GardenMonitor extends StatefulWidget {
  const GardenMonitor({super.key});

  @override
  State<GardenMonitor> createState() => _GardenMonitorState();
}

class _GardenMonitorState extends State<GardenMonitor> {
  late MqttServerClient client;

  double temperature = 0;
  double humidity = 0;
  double soil = 0;
  bool isPumpOn = false;
  String pumpStatus = "OFF";
  double desiredMoisture = 70;

  @override
  void initState() {
    super.initState();
    connectMQTT();
  }

  Future<void> connectMQTT() async {
    client = MqttServerClient('broker.hivemq.com', 'flutter_irrigation_app');

    client.port = 1883;
    client.keepAlivePeriod = 20;
    client.onConnected = () => debugPrint("MQTT Connected");

    await client.connect();

    client.subscribe('iot/irrigation/sensor', MqttQos.atMostOnce);

    client.updates!.listen((events) {
      final recMess = events[0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(
        recMess.payload.message,
      );

      final values = payload.split(',');

      setState(() {
        temperature = double.parse(values[0]);
        humidity = double.parse(values[1]);
        soil = double.parse(values[2]);
      });
    });
  }

  void publishPumpCommand(String cmd) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(cmd);

    client.publishMessage(
      'iot/irrigation/pump',
      MqttQos.atMostOnce,
      builder.payload!,
    );

    setState(() {
      pumpStatus = cmd;
    });
  }

  void togglePump(bool value) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(value ? "ON" : "OFF");

    client.publishMessage(
      'iot/irrigation/pump',
      MqttQos.atMostOnce,
      builder.payload!,
    );

    setState(() {
      isPumpOn = value;
      pumpStatus = value ? "ON" : "OFF";
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Image(
            image: AssetImage(
              'assets/pexels-im_malikbasit-254414522-12554514.jpg',
            ),
            fit: BoxFit.fill,
            height: double.maxFinite,
            width: double.maxFinite,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              color: Colors.black12,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Garden monitor',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: (screenWidth / 8 - 7.5) * 0.8,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: screenWidth - 20.0,
                      height: screenWidth / 2 - 10.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.white54,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$temperature°C',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: (screenWidth / 3 - 20) * 0.7,
                                        height: 0.85,
                                      ),
                                    ),
                                    Text(
                                      'Humidity: $humidity%',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: (screenWidth / 8 - 7.5) * 0.5,
                                        height: 0.85,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.device_thermostat_outlined,
                            size: screenWidth / 4,
                            color: temperature <= 30.0
                                ? Colors.blue
                                : Colors.deepOrangeAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: screenWidth - 20.0,
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              'Soil Moisture: $soil%',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: (screenWidth / 8 - 7.5) * 0.5,
                                height: 0.85,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.circle,
                            color: soil > desiredMoisture
                                ? Colors.green
                                : Colors.red,
                            size: (screenWidth / 8 - 7.5) * 0.5,
                          ),
                          Text(
                            soil > desiredMoisture ? 'Safe' : 'Danger',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: (screenWidth / 8 - 7.5) * 0.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: screenWidth - 20.0,
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              'Water Pump',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: (screenWidth / 8 - 7.5) * 0.5,
                                height: 0.85,
                              ),
                            ),
                          ),
                          Switch(
                            value: isPumpOn,
                            onChanged: (value) {
                              togglePump(value);
                            },
                            activeThumbColor: Colors.green,
                            inactiveThumbColor: Colors.black87,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
