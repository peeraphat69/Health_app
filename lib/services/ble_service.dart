import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../models/health_data.dart';

class BleService {
  BluetoothDevice? device;
  BluetoothCharacteristic? characteristic;
  
  String connectionStatus = "Disconnected";
  String traceLog = "Waiting for data..."; // 🔥 ตัวแปรช่วยดูข้อมูลดิบ
  HealthData? healthData;

  final String serviceUUID = "12345678-1234-1234-1234-1234567890ab";
  final String charUUID = "abcd1234-ab12-cd34-ef56-1234567890ab";

  void scanAndConnect(VoidCallback onUpdate) async {
    if (connectionStatus == "Connected") return;

    connectionStatus = "Scanning...";
    onUpdate();

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) async {
      for (var r in results) {
        if (r.device.platformName == "ESP32-Health" || r.device.name == "ESP32-Health") {
          await FlutterBluePlus.stopScan();
          device = r.device;

          connectionStatus = "Connecting...";
          onUpdate();

          try {
            await device!.connect();
            connectionStatus = "Connected";
            traceLog = "Connected! Discovering services...";
            onUpdate();

            await _discoverServices(onUpdate);
          } catch (e) {
            connectionStatus = "Error";
            traceLog = "Connect Error: $e";
            onUpdate();
          }
        }
      }
    });
  }

  Future<void> _discoverServices(VoidCallback onUpdate) async {
    if (device == null) return;
    try {
      List<BluetoothService> services = await device!.discoverServices();
      for (var s in services) {
        if (s.uuid.toString() == serviceUUID) {
          for (var c in s.characteristics) {
            if (c.uuid.toString() == charUUID) {
              characteristic = c;
              await c.setNotifyValue(true);

              // รับข้อมูล
              c.lastValueStream.listen((value) {
                try {
                  String text = utf8.decode(value).trim();
                  traceLog = "Raw: $text"; // โชว์ข้อมูลดิบที่หน้าจอ

                  // 🔥 วิธีแกะข้อมูลแบบ CSV (น้ำหนัก,ส่วนสูง,BMI)
                  List<String> parts = text.split(',');
                  if (parts.length >= 3) {
                    healthData = HealthData(
                      weight: double.tryParse(parts[0]) ?? 0.0,
                      height: double.tryParse(parts[1]) ?? 0.0,
                      bmi: double.tryParse(parts[2]) ?? 0.0,
                    );
                  }
                  onUpdate();
                } catch (e) {
                  traceLog = "Error parsing: $e";
                  onUpdate();
                }
              });
            }
          }
        }
      }
    } catch (e) {
      traceLog = "Service Error: $e";
      onUpdate();
    }
  }
}