import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'bluetooth_methods.dart';

//late BluetoothCharacteristic bluetoothCharacteristic;

void main() => runApp(MaterialApp(home: BleApp()));

class BleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ROOM"),
          centerTitle: true,
          backgroundColor: Colors.indigo[400],
        ),
        body: BleHandler());
  }
}

class BleHandler extends StatefulWidget {
  const BleHandler({Key? key}) : super(key: key);

  @override
  _BleHandlerState createState() => _BleHandlerState();
}

class _BleHandlerState extends State<BleHandler> {
  void initState() {
    super.initState();
    scan();
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Column(children: [
        Padding(padding: EdgeInsets.fromLTRB(30, 30, 30, 30)),
        LiteRollingSwitch(
          value: false,
          textOn: 'ON',
          textOff: 'OFF',
          colorOn: Colors.teal[400],
          colorOff: Colors.indigo[400],
          iconOn: Icons.lightbulb,
          iconOff: Icons.lightbulb_outlined,
          onChanged: (bool state) {
            deviceInteraction(state);
          },
        ),
      ])
    ]);
  }
}
