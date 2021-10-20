import 'package:flutter_blue/flutter_blue.dart';
import 'dart:async';

late BluetoothDevice Bdevice;
late BluetoothService service;

late BluetoothCharacteristic rxCharacteristic; // recieve characteristic
late BluetoothCharacteristic txCharacteristic; //transmit characteristic

String deviceName = "";
bool ledState = false;
// ignore: cancel_subscriptions
late StreamSubscription<ScanResult> scanSubscription;
FlutterBlue flutterBlue = FlutterBlue.instance;
const ISSC_PROPRIETARY_SERVICE_UUID = "ab0828b1-198e-4351-b779-901fa0e0371e";
const CHARACTERISTIC_UUID_RX = "0972ef8c-7613-4075-ad52-756f33d4da91";
const CHARACTERISTIC_UUID_TX = "4ac8a682-9736-4e5d-932b-e9b31405049c";

void scan() {
  scanSubscription = flutterBlue.scan().listen((results) async {
    if (results.device.name == "ESP32-BLE") {
      Bdevice = results.device;

      deviceName = Bdevice.name; // asign discovered device to device name
      print(deviceName);
      flutterBlue.stopScan(); // stop scanning for bluetooth device

    }
  });
} // This method scans for services and the uses the service delivery method to save recieve and transmit characteristics

void deviceInteraction(bool state) async {
  await Bdevice.disconnect();
  await Bdevice.connect();

  List<BluetoothService> services = await Bdevice.discoverServices();
  services.forEach((svc) {
    if (svc.uuid.toString() == ISSC_PROPRIETARY_SERVICE_UUID) {
      print("Found Service");
      service = svc; // Scan for characteristics and save them
      for (BluetoothCharacteristic c in service.characteristics) {
        print(c.uuid.toString());
        if (c.uuid.toString() == CHARACTERISTIC_UUID_RX) {
          if (state) {
            print("Written");
            c.write(
                [0x4C, 0x31]); // data to be sent to esp32 for contolling LED
          } else {
            c.write([0x4C, 0x30]);
          }
        } else if (c.uuid.toString() == CHARACTERISTIC_UUID_TX) {}
      }
    }
  });
  print("disconnecting");
  await Bdevice.disconnect();
}
