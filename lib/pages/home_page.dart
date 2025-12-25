import 'dart:io'; // สำหรับเช็ค Platform
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; // อย่าลืมลง package นี้

// Import ไฟล์ในโปรเจกต์ของคุณ
import 'package:app_health/pages/BodyPage.dart';
import 'package:app_health/pages/topbar.dart';
import 'package:app_health/widgets/button.dart';
import '../services/ble_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // สร้าง Instance ของ Service
  final BleService bleService = BleService();

  @override
  void initState() {
    super.initState();
    // เรียกฟังก์ชันตั้งค่าเริ่มต้น (ขอสิทธิ์ + สแกน)
    _initBle();
  }

  Future<void> _initBle() async {
    // 1. ขออนุญาต (Permissions) สำหรับ Android
    if (Platform.isAndroid) {
      // ขอสิทธิ์ Location และ Bluetooth 
      // (สำคัญมากสำหรับ Android 12+ และเวอร์ชั่นเก่า)
      await [
        Permission.location,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise, // เผื่อไว้
      ].request();
    }

    // 2. สั่งเริ่มสแกนและเชื่อมต่อ
    bleService.scanAndConnect(() {
      // เมื่อมีข้อมูลใหม่ หรือสถานะเปลี่ยน ให้รีเฟรชหน้าจอ
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Self Care'),
        backgroundColor: const Color(0xFFCCCCFF), // ปรับสีให้เข้าธีม
      ),
      body: SingleChildScrollView( // ใส่ ScrollView กันหน้าจอล้น
        child: Column(
          children: [
            const topbar(),
            const SizedBox(height: 10),
            const MenuButtons(),
            const SizedBox(height: 5),
            
            // ส่งข้อมูลจริง และสถานะ ไปยัง BodyPage ที่แก้ใหม่แล้ว
            BodyPage(
              healthData: bleService.healthData,
              connectionStatus: bleService.connectionStatus,
            ),
            
            // ลบ BlePage() ออก เพื่อไม่ให้หน้าจอซ้อนกัน
          ],
        ),
      ),
    );
  }
}