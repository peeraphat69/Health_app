import 'package:flutter/material.dart';
import '../services/ble_service.dart';
import '../widgets/ble_status_text.dart';
import '../widgets/ble_data_box.dart';
import '../widgets/ble_connect_button.dart';

class BlePage extends StatefulWidget {
  const BlePage({super.key});

  @override
  State<BlePage> createState() => _BlePageState();
}

class _BlePageState extends State<BlePage> {
  final BleService bleService = BleService();

  @override
  void initState() {
    super.initState();
    // ถ้าต้องการให้ connect อัตโนมัติเมื่อเปิดหน้านี้ ให้เปิดบรรทัดล่าง
    // bleService.scanAndConnect(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    // ❌ ลบ Scaffold และ AppBar ออก
    // ✅ เปลี่ยนเป็น Container หรือ Column แทน
    return Container( 
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      // ใส่สีพื้นหลังหรือกรอบหน่อยจะได้รู้ว่าเป็นส่วนเชื่อมต่อ (Optional)
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300)
      ),
      child: Column(
        children: [
          const Text("การเชื่อมต่ออุปกรณ์", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          BleStatusText(status: bleService.connectionStatus),
          const SizedBox(height: 5),
          BleDataBox(data: bleService.receivedData),
          const SizedBox(height: 5),
          BleConnectButton(
            onPressed: () {
              bleService.scanAndConnect(() => setState(() {}));
            },
          ),
        ],
      ),
    );
  }
}