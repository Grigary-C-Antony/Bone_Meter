import 'package:bmeter/essential.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class Previousdata extends StatefulWidget {
  @override
  _PreviousdataState createState() => _PreviousdataState();
}

class _PreviousdataState extends State<Previousdata> {
  double tScore = (((522.613 / frequency) - 0.856) / .1627);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
          painter: MyPainter(),
          child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: InkWell(
                    child: Container(
                      // color: Color(0xA0000000),
                      child: tScore <= -1
                          ? textDataC("OSTEOPEROSIS")
                          : textDataC("NORMAL"),
                    ),
                  )),
              Expanded(
                flex: 3,
                child: datafromapi.length > 0
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: datafromapi.length,
                        itemBuilder: (BuildContext context, int index) {
                          return cardEsr(
                              double.parse(((((522.613 /
                                              datafromapi.reversed
                                                      .toList()[index]
                                                  ["frequency"]) -
                                          0.856) /
                                      .1627))
                                  .toStringAsFixed(2)),
                              double.parse(((522.613 /
                                      datafromapi.reversed.toList()[index]
                                          ["frequency"]))
                                  .toStringAsFixed(2)));
                        })
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              )
            ],
          )),
    );
  }
}

Widget textDataA(data, value) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.fromLTRB(0, proH(8), 0, proH(5)),
        child: Text("$data",
            style: TextStyle(
                color: textColord, fontSize: proW(22), fontFamily: "Teko")),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(0, proH(4), 0, proH(5)),
        child: Text("$value",
            style: TextStyle(
                color: textColord, fontSize: proW(35), fontFamily: "Teko")),
      ),
    ],
  );
}

Widget textDataB(data) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(data,
          style: TextStyle(
              color: HexColor("fff5eb"),
              fontSize: proW(35),
              fontFamily: "Teko"))
    ],
  );
}

Widget textDataC(data) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(data,
          style: TextStyle(
              color: HexColor("5e454b"),
              fontSize: proW(60),
              fontFamily: "Teko"))
    ],
  );
}

Widget cardEsr(value1, value2) {
  return Padding(
    padding: EdgeInsets.all(proW(5)),
    child: Container(
        height: SizeConfig.screenHeight * .15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(proW(15)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(proW(15)),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: value1 <= -1
                    ? Container(
                        color: HexColor("bb371a"),
                        child: textDataB("OSTEOPEROSIS"))
                    : Container(
                        color: HexColor("2f5d62"), child: textDataB("NORMAL")),
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                    color: HexColor("d8b384"),
                    child: textDataA("T-score", "$value1"),
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    color: HexColor("ecdbba"),
                    child: textDataA("Density", "$value2"),
                  ))
            ],
          ),
        )),
  );
}
