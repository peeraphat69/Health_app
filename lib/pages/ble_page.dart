import 'package:flutter/material.dart';
import '../services/ble_service.dart';
import '../widgets/health_dashboard.dart';

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
    bleService.scanAndConnect(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Self Care")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Status: ${bleService.connectionStatus}",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            // 🔥 ตรงนี้คือข้อ 5️⃣ ที่คุณถาม
            if (bleService.healthData != null)
              HealthDashboard(data: bleService.healthData!)
            else
              const Text("Waiting for data..."),
          ],
        ),
      ),
    );
  }
}
