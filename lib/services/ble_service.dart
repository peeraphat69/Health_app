import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../models/health_data.dart';

class BleService {
  BluetoothDevice? device;
  BluetoothCharacteristic? characteristic;

  String connectionStatus = "Disconnected";
  HealthData? healthData;

  /// ✅ สำหรับ debug log (แก้ error traceLog)
  List<String> traceLog = [];

  final Guid serviceUuid =
      Guid("12345678-1234-1234-1234-1234567890ab");
  final Guid charUuid =
      Guid("abcd1234-ab12-cd34-ef56-1234567890ab");

  /// 🔧 helper log
  void _log(String text) {
    traceLog.add(text);
    if (traceLog.length > 100) {
      traceLog.removeAt(0);
    }
    debugPrint(text);
  }

  /// 🔍 Scan และ connect
  void scanAndConnect(VoidCallback onUpdate) async {
    connectionStatus = "Scanning...";
    _log("Scanning BLE devices...");
    onUpdate();

    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 5),
    );

    FlutterBluePlus.scanResults.listen((results) async {
      for (var r in results) {
        if (r.device.name == "ESP32-Health") {
          _log("Found device: ESP32-Health");

          connectionStatus = "Connecting...";
          onUpdate();

          device = r.device;
          await FlutterBluePlus.stopScan();

          await device!.connect(autoConnect: false);
          connectionStatus = "Connected";
          _log("Connected to ESP32");
          onUpdate();

          await discoverServices(onUpdate);
          break;
        }
      }
    });
  }

  /// 🔎 Discover service + subscribe notify
  Future<void> discoverServices(VoidCallback onUpdate) async {
    _log("Discovering services...");
    final services = await device!.discoverServices();

    for (var s in services) {
      if (s.uuid == serviceUuid) {
        _log("Service found");

        for (var c in s.characteristics) {
          if (c.uuid == charUuid) {
            _log("Characteristic found");
            characteristic = c;

            // 🔥 สำคัญ (Android BLE)
            await device!.requestMtu(247);

            // 🔔 เปิด notify
            await c.setNotifyValue(true);

            connectionStatus = "Receiving data...";
            onUpdate();

            // ✅ รับค่าจาก ESP32
            c.value.listen((value) {
              if (value.isEmpty) return;

              final text = utf8.decode(value).trim();
              _log("BLE RAW: $text");

              try {
                healthData = HealthData.fromJsonString(text);
              } catch (e) {
                _log("JSON parse error: $e");
              }

              onUpdate();
            });
          }
        }
      }
    }
  }

  /// ❌ Disconnect
  Future<void> disconnect(VoidCallback onUpdate) async {
    if (device != null) {
      await device!.disconnect();
      connectionStatus = "Disconnected";
      _log("Disconnected");
      onUpdate();
    }
  }
}
