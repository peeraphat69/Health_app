import 'package:app_health/widgets/container_output.dart';
import 'package:flutter/material.dart';
import '../../models/health_data.dart';

class BodyPage extends StatelessWidget {
  final HealthData? healthData;
  final String connectionStatus;
   final List<String> traceLog;
  const BodyPage({
    super.key,
    this.healthData,
    this.connectionStatus = "Disconnected",
    required this.traceLog,
  });

  @override
  Widget build(BuildContext context) {
    // เตรียมข้อมูลแสดงผล (ถ้าไม่มีค่าให้โชว์ --)
    String weight = healthData?.weight.toStringAsFixed(1) ?? '--';
    String height = healthData?.height.toStringAsFixed(0) ?? '--';
    String bmi = healthData?.bmi.toStringAsFixed(1) ?? '--';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        // 🔥 ส่วนนี้คือกู้คืนกล่องสีม่วงครับ
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), // ขอบมนสวยๆ
          color: const Color(0xFFCCCCFF), // สีม่วงอ่อน (ตามรูปแรก)
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            
            // 🔥 ส่วนแสดงสถานะ (Status) ตัวใหญ่ สีเขียว
            Text(
              'Status: $connectionStatus',
              style: TextStyle(
                fontSize: 20, // ตัวใหญ่ชัดเจน
                fontWeight: FontWeight.bold,
                color: connectionStatus == "Connected" 
                    ? Colors.green[700]  // ถ้าต่อติดเป็นสีเขียวเข้ม
                    : Colors.red,        // ถ้าหลุดเป็นสีแดง
              ),
            ),
            
            const SizedBox(height: 5),

            // 🔥 ส่วนแสดงข้อมูลดิบ (Raw Data) ตัวเล็กๆ สีเทา
            // ถ้า traceLog ยังไม่มา ให้ขึ้นว่า "Waiting..."
            Text(
              "Raw: ${traceLog ?? 'Waiting...'}", 
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),

            const SizedBox(height: 20),

            // ตารางแสดงข้อมูล (เหมือนเดิม)
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                ContainerOutput(header: 'น้ำหนัก', value: weight, unit: 'kg'),
                ContainerOutput(header: 'ส่วนสูง', value: height, unit: 'cm'),
                ContainerOutput(header: 'BMI', value: bmi, unit: 'kg/m²'),
                ContainerOutput(header: 'Heart Rate', value: '--', unit: 'bpm'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}