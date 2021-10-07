import 'package:flutter_blue/flutter_blue.dart';
import 'dart:async';

late BluetoothDevice device;
late BluetoothService service;

late BluetoothCharacteristic rxCharacteristic; // recieve characteristic
late BluetoothCharacteristic txCharacteristic; //transmit characteristic

String deviceName = "";
bool ledState = false;
// ignore: cancel_subscriptions
late StreamSubscription<ScanResult> scanSubscription;
FlutterBlue flutterBlue = FlutterBlue.instance;
const ISSC_PROPRIETARY_SERVICE_UUID = "ab0828b1-198e-4351-b779-901fa0e0371e";
const CHARACTERISTIC_UUID_RX = "4ac8a682-9736-4e5d-932b-e9b31405049c";
const CHARACTERISTIC_UUID_TX = "0972EF8C-7613-4075-AD52-756F33D4DA91";

void scan() {
  scanSubscription = flutterBlue.scan().listen((results) async {
    if (results.device.name == "ESP32-BLE") {
      device = results.device;

      deviceName = device.name; // asign discovered device to device name
      print(deviceName);
      flutterBlue.stopScan(); // stop scanning for bluetooth device
      await device.connect(); //connect to bluetooth device
      serviceDelivery();
    }
  });
} // This method scans for services and the uses the service delivery method to save recieve and transmit characteristics

void serviceDelivery() async {
  List<BluetoothService> services = await device.discoverServices();
  services.forEach((svc) {
    if (svc.uuid.toString() == ISSC_PROPRIETARY_SERVICE_UUID) {
      service = svc;
      // Scan for characteristics and save them
      for (BluetoothCharacteristic c in service.characteristics) {
        if (c.uuid.toString() == CHARACTERISTIC_UUID_RX) {
          rxCharacteristic = c;
        } else if (c.uuid.toString() == CHARACTERISTIC_UUID_TX) {
          txCharacteristic = c;
        }
      }
    }
  });
}
