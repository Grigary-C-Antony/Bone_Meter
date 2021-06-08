import 'package:bmeter/previousdata.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'essential.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

Color colorGiven = Colors.white;
double valueGiven = 50.5;

///////////////////////////////////////////////////////////////////////

double xOffset = 0;
double yOffset = 0;
double scaleFactor = 1;
double valuer = 30;
// bool blconnected = false;
bool isDrawerOpen = false;
List datafromapi = [];
dynamic frequency = 0;
dynamic voltage = 0;
Color textColord = HexColor("583d72");
Color textcolorc = HexColor("9f5f80");
Color textColorb = HexColor("583d72");
Color textColora = HexColor("ffffff");

class _HomepageState extends State<Homepage> {
  getCountries() async {
    var response = await Dio().get(
        'https://script.google.com/macros/s/AKfycbxOk266Z9T-_e20FEdpvuQ_4hRCbO4hXnDAxxK8EZA3rnHLsCUh9CuZwYXsk7NaFLxI9Q/exec');
    return response.data;
  }

  @override
  void initState() {
    getCountries().then((data) {
      setState(() {
        datafromapi = data;
        frequency = datafromapi.reversed.toList()[0]["frequency"];
        // frequency = 500;
        voltage = datafromapi.reversed.toList()[0]["voltage"];
        // voltage = 1.8;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: (((522.613 / frequency) - 0.856) / .1627) >= -1
          ? HexColor("8e9775")
          : HexColor("ff8474"),
      appBar: AppBar(
          backgroundColor: (((522.613 / frequency) - 0.856) / .1627) >= -1
              ? HexColor("8e9775")
              : HexColor("ff8474"),
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.timelapse, size: proH(30)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Previousdata()),
                );
              }),
          actions: [
            IconButton(
                icon: Icon(Icons.refresh_outlined, size: proH(30)),
                onPressed: () {
                  getCountries().then((data) {
                    setState(() {
                      datafromapi = data;
                      frequency = datafromapi.reversed.toList()[0]["frequency"];
                      // frequency = 500;
                      voltage = datafromapi.reversed.toList()[0]["voltage"];
                      // voltage = 1.8;
                    });
                  });
                })
          ]),
      body: CustomPaint(
          painter: CurvePainter(),
          child: Column(children: [
            // Expanded(
            //     flex: 10,
            //     child: Container(color: Colors.white

            //         )),
            Expanded(
              flex: 22,
              child: Container(
                  // height: SizeConfig.screenHeight * .40,
                  child: Column(children: [
                Padding(
                    padding: new EdgeInsets.fromLTRB(
                        proH(40), proH(10), proH(40), 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        datafromapi.length >= 0
                            ? (((522.613 / frequency) - 0.856) / .1627) >= -1
                                ? Text(
                                    // "${double.parse((valueGiven).toStringAsFixed(2))}",
                                    "NORMAL",
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: colorGiven,
                                        fontSize: proW(50),
                                        letterSpacing: proW(5),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Teko"))
                                : Text(
                                    // "${double.parse((valueGiven).toStringAsFixed(2))}",
                                    "OSTEOPORESIS",
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: colorGiven,
                                        fontSize: proW(50),
                                        letterSpacing: proW(5),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Teko"))
                            : Text(
                                // "${double.parse((valueGiven).toStringAsFixed(2))}",
                                "-.-",
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: colorGiven,
                                    fontSize: proW(150),
                                    fontFamily: "Teko")),
                      ],
                    )),
              ])),
            ),
            Expanded(
              flex: 50,
              child: Container(
                alignment: Alignment.topCenter,
                child: ListView(physics: BouncingScrollPhysics(), children: [
                  cardEs(Icons.spa, "T-Score",
                      (((522.613 / frequency) - 0.856) / .1627), ""),
                  cardEs(Icons.fitness_center, "BONE DENSITY",
                      522.613 / frequency, ""),
                  cardEs(CupertinoIcons.waveform_path, "FREQUENCY", frequency,
                      "kHZ"),
                ]),
              ),
            )
          ])),
    );
  }
}

Widget cardEs(icones, textes, valueses, unites) {
  return Padding(
    padding: EdgeInsets.all(proW(16)),
    child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        height: proH(170),
        child: Column(children: [
          SizedBox(height: proH(20)),
          CircleAvatar(
            backgroundColor: textColorb,
            radius: 20,
            child: Icon(icones, color: textColora),
          ),
          SizedBox(height: proH(5)),
          Text(textes,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  color: textcolorc,
                  fontSize: proW(25),
                  fontFamily: "Teko")),
          SizedBox(height: proH(5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${double.parse((valueses).toStringAsFixed(2))}",
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: textColord,
                      height: 0.9,
                      fontSize: proW(50),
                      fontFamily: "Teko")),
              Padding(
                padding: new EdgeInsets.fromLTRB(0, proH(15), 0, 0),
                child: Text(unites,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: textColord,
                        fontSize: proW(20),
                        fontFamily: "Teko")),
              ),
            ],
          ),
        ])),
  );
}
