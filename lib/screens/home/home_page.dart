import 'dart:io'; 
import 'package:app_health/screens/home/body_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../services/ble_service.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BleService bleService = BleService();

  @override
  void initState() {
    super.initState();
    _initBle();
  }

  Future<void> _initBle() async {
    // ... (โค้ดขอ Permission เดิมของคุณ) ...
    if (Platform.isAndroid) {
      await [
        Permission.location,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
      ].request();
    }
    
    bleService.scanAndConnect(() {
      if (mounted) setState(() {});
    });
  }

  // ✅ ฟังก์ชันสำหรับปุ่ม Refresh (ทำงานเหมือน Test Read)
  Future<void> _refreshData() async {
    if (bleService.connectionStatus != "Connected") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ยังไม่ได้เชื่อมต่ออุปกรณ์')),
      );
      return;
    }

    try {
      if (bleService.characteristic != null) {
        // สั่งอ่านค่าจากอุปกรณ์ทันที
        await bleService.characteristic!.read();
        
        // แจ้งเตือนผู้ใช้ว่าอัพเดทแล้ว
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('รีเฟรชข้อมูลเรียบร้อย!'),
            duration: Duration(milliseconds: 800), // โชว์แป๊บเดียวพอ
          ),
        );
      }
    } catch (e) {
      print("Refresh Error: $e");
    }
  }

  void _saveData() {
    // ... (โค้ดบันทึกเดิม) ...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Self Care'),
        backgroundColor: const Color(0xFFB19CD8),
        
        // 🔥 เพิ่มปุ่ม Refresh ตรงนี้ครับ (มุมขวาบน)
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'รีเฟรชข้อมูล',
            onPressed: _refreshData, // กดแล้วเรียกฟังก์ชันอ่านค่า
          ),
          const SizedBox(width: 10), // เว้นระยะขวานิดนึง
        ],
      ),
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            
            BodyPage(
              healthData: bleService.healthData,
              connectionStatus: bleService.connectionStatus,
              traceLog: bleService.traceLog,
              onSave: _saveData,
              // onTestRead: _refreshData, // ถ้าอยากให้ปุ่มส้มในหน้าจอทำงานด้วย ก็ใส่ฟังก์ชันเดียวกันได้เลย
            ),
          ],
        ),
      ),
    );
  }
}