import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../models/health_data.dart';

class BleService {
  BluetoothDevice? device;
  BluetoothCharacteristic? characteristic;
  StreamSubscription? _subscription; // ตัวจัดการ Stream (สำคัญ)

  String connectionStatus = "Disconnected";
  HealthData? healthData;
  List<String> traceLog = [];

  final Guid serviceUuid = Guid("12345678-1234-1234-1234-1234567890ab");
  final Guid charUuid = Guid("abcd1234-ab12-cd34-ef56-1234567890ab");

  void _log(String text) {
    traceLog.add(text);
    if (traceLog.length > 50) traceLog.removeAt(0);
    debugPrint("[BleService] $text");
  }

  // ฟังก์ชัน Scan และ Connect
  void scanAndConnect(VoidCallback onUpdate) async {
    connectionStatus = "Scanning...";
    _log("Scanning...");
    onUpdate();

    // เริ่มสแกน
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) async {
      for (var r in results) {
        if (r.device.name == "ESP32-Health") { // เช็คชื่อให้ตรงกับ ESP32
          _log("Found ${r.device.name}!");
          await FlutterBluePlus.stopScan();

          device = r.device;
          connectionStatus = "Connecting...";
          onUpdate();

          try {
            // เชื่อมต่อ
            await device!.connect(autoConnect: false);
            connectionStatus = "Connected";
            _log("Connected!");
            onUpdate();

            // ค้นหา Service
            await discoverServices(onUpdate);
          } catch (e) {
            connectionStatus = "Error: $e";
            _log("Connect Error: $e");
            onUpdate();
          }
          break;
        }
      }
    });
  }

  // ฟังก์ชันค้นหา Service และเปิด Notify
  Future<void> discoverServices(VoidCallback onUpdate) async {
    _log("Discovering Services...");
    List<BluetoothService> services = await device!.discoverServices();

    for (var s in services) {
      if (s.uuid == serviceUuid) {
        for (var c in s.characteristics) {
          if (c.uuid == charUuid) {
            characteristic = c;
            _log("Characteristic Found!");

            // ⚠️ 1. ยกเลิกการฟังอันเก่าก่อน (ถ้ามี)
            await _subscription?.cancel();

            // ⚠️ 2. ใช้ Stream ตัวใหม่: lastValueStream (รองรับทั้ง Read และ Notify)
            // หรือถ้าเวอร์ชั่นเก่าใช้ c.value.listen ตามเดิม แต่ lastValueStream ชัวร์กว่า
            _subscription = c.lastValueStream.listen((value) {
              if (value.isNotEmpty) {
                // แปลงข้อมูล
                String text = utf8.decode(value).trim();
                _log("Raw Data: $text");
                
                // แปลงเป็น Object
                healthData = HealthData.fromCsvString(text);
                
                // อัปเดตหน้าจอ
                onUpdate();
              }
            });

            // ⚠️ 3. เพิ่ม Delay เล็กน้อยก่อนเปิด Notify (สูตรแก้ Android เชื่อมต่อแล้วเงียบ)
            await Future.delayed(const Duration(milliseconds: 500));

            // ⚠️ 4. เปิด Notify
            try {
              await c.setNotifyValue(true);
              _log("Notify Enabled ✅");
              connectionStatus = "Receiving Data...";
            } catch (e) {
              _log("Notify Error: $e");
            }
            
            // ลองอ่านค่าครั้งแรกทันที (กระตุ้นให้ข้อมูลมา)
            try {
               await c.read();
            } catch(e) {}
            
            onUpdate();
          }
        }
      }
    }
  }

  // ฟังก์ชัน Disconnect
  Future<void> disconnect() async {
    _subscription?.cancel(); // อย่าลืมปิด Stream
    await device?.disconnect();
    connectionStatus = "Disconnected";
    device = null;
  }
}