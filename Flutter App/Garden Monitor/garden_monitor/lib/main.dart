import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

void main() {
  runApp(MaterialApp(home: GardenMonitor(), debugShowCheckedModeBanner: false));
}

class GardenMonitor extends StatelessWidget {
  const GardenMonitor({super.key});

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
                                      '25°C',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: (screenWidth / 3 - 20) * 0.8,
                                        height: 0.85,
                                      ),
                                    ),
                                    Text(
                                      'Humidity: 75%',
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
                            size: screenWidth / 3,
                            color: Colors.blue,
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
                              'Soil Moisture: 70%',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: (screenWidth / 8 - 7.5) * 0.5,
                                height: 0.85,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.circle,
                            color: Colors.green,
                            size: (screenWidth / 8 - 7.5) * 0.5,
                          ),
                          Text(
                            'Safe',
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
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Water pump',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: (screenWidth / 8 - 7.5) * 0.35,
                            ),
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Turned off',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
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
