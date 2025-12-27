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
          SizedBox(
            height: double.maxFinite,
            width: double.maxFinite,
            child: Image(
              image: AssetImage(
                'assets/pexels-im_malikbasit-254414522-12554514.jpg',
              ),
              fit: BoxFit.fill,
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
                    child: Stack(
                      children: [
                        Container(
                          width: screenWidth - 20.0,
                          height: screenWidth / 2 - 10.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white10,
                          ),
                        ),
                        SizedBox(
                          width: screenWidth - 20.0,
                          height: screenWidth / 2 - 10.0,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '25°C',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  (screenWidth / 3 - 20) * 0.8,
                                            ),
                                          ),
                                          Text(
                                            'Humidity: 75%',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  (screenWidth / 8 - 7.5) * 0.5,
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: screenWidth - 20.0,
                      //height: screenWidth / 8 - 2.5,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              'Soil Moisture: 70%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: (screenWidth / 8 - 7.5) * 0.5,
                              ),
                            ),
                          ),
                          Text(
                            'Safe',
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: (screenWidth / 8 - 7.5) * 0.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
                    child: Text(
                      'Water pump',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: (screenWidth / 8 - 7.5) * 0.35,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10, left: 20),
                    child: GestureDetector(
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
