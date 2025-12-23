import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class BleService {
  BluetoothDevice? device;
  BluetoothCharacteristic? characteristic;

  String connectionStatus = "Disconnected";
  String receivedData = "No data";

  final String deviceName = "ESP32-Health";
  final String serviceUUID = "12345678-1234-1234-1234-1234567890ab";
  final String charUUID = "abcd1234-ab12-cd34-ef56-1234567890ab";

  void scanAndConnect(VoidCallback onUpdate) async {
    connectionStatus = "Scanning...";
    onUpdate();

    // เริ่ม scan
    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 4),
    );

    FlutterBluePlus.scanResults.listen((results) async {
      for (var r in results) {
        if (r.device.platformName == deviceName) {
          connectionStatus = "Connecting...";
          onUpdate();

          device = r.device;

          // หยุด scan ก่อน connect
          await FlutterBluePlus.stopScan();

          await device!.connect();

          connectionStatus = "Connected";
          onUpdate();

          discoverServices(onUpdate);
          return; // เจอแล้ว ออกเลย
        }
      }
    });
  }

  void discoverServices(VoidCallback onUpdate) async {
    if (device == null) return;

    final services = await device!.discoverServices();

    for (var s in services) {
      if (s.uuid.toString() == serviceUUID) {
        for (var c in s.characteristics) {
          if (c.uuid.toString() == charUUID) {
            characteristic = c;

            await c.setNotifyValue(true);

            c.lastValueStream.listen((value) {
              receivedData = utf8.decode(value);
              onUpdate();
            });

            return;
          }
        }
      }
    }
  }

  // (แนะนำ) disconnect ไว้ใช้ภายหลัง
  Future<void> disconnect(VoidCallback onUpdate) async {
    if (device != null) {
      await device!.disconnect();
      connectionStatus = "Disconnected";
      onUpdate();
    }
  }
}
