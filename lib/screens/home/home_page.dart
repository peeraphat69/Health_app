import 'dart:io'; // สำหรับเช็ค Platform
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; // อย่าลืมลง package นี้

// Import ไฟล์ในโปรเจกต์ของคุณ
import 'package:app_health/screens/home/body_page.dart';
import 'package:app_health/screens/home/topbar_page.dart';
import 'package:app_health/widgets/menu_button.dart';
import '../../services/ble_service.dart';

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
      appBar: AppBar(title: const Text('Self Care')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const topbar(),
            const SizedBox(height: 10),
            const MenuButtons(),
            const SizedBox(height: 5),
            
            // 🔥 จุดที่ต้องแก้ครับ! ต้องเพิ่มบรรทัด traceLog เข้าไป
            BodyPage(
              healthData: bleService.healthData,
              connectionStatus: bleService.connectionStatus,
              traceLog: bleService.traceLog, // <--- บรรทัดนี้สำคัญมาก!
            ),
            
          ],
        ),
      ),
    );
  }
}