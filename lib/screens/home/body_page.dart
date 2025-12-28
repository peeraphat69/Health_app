import 'package:app_health/widgets/container_output.dart';
import 'package:flutter/material.dart';
import '../../models/health_data.dart';

class BodyPage extends StatelessWidget {
  final HealthData? healthData;
  final String connectionStatus;
  final List<String> traceLog;
  final VoidCallback? onSave;     // รับฟังก์ชันบันทึก
  final VoidCallback? onTestRead; // รับฟังก์ชันอ่านค่าสด (Debug)

  const BodyPage({
    super.key,
    this.healthData,
    this.connectionStatus = "Disconnected",
    required this.traceLog,
    this.onSave,
    this.onTestRead,
  });

  @override
  Widget build(BuildContext context) {
    // 1. เตรียมข้อมูลแสดงผล (ถ้าไม่มีค่าให้โชว์ --)
    String weight = healthData?.weight.toStringAsFixed(1) ?? '--';
    String height = healthData?.height.toStringAsFixed(0) ?? '--';
    String bmi = healthData?.bmi.toStringAsFixed(1) ?? '--';
    
    // ดึง Log บรรทัดสุดท้ายมาโชว์ (จะได้รู้สถานะล่าสุด)
    String lastLog = traceLog.isNotEmpty ? traceLog.last : "Waiting for log...";

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFFCCCCFF), // สีม่วงอ่อนธีมเดิม
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            
            // --- ส่วนแสดงสถานะ (Status) ---
            Text(
              'Status: $connectionStatus',
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: connectionStatus == "Connected" 
                    ? Colors.green[700]  
                    : Colors.red,
              ),
            ),
            
            const SizedBox(height: 5),

            // // --- ส่วนแสดง Debug Log (โชว์แค่บรรทัดล่าสุด) ---
            // Container(
            //   padding: const EdgeInsets.all(8),
            //   decoration: BoxDecoration(
            //     color: Colors.white54,
            //     borderRadius: BorderRadius.circular(8)
            //   ),
            //   child: Text(
            //     "Last Log: $lastLog", 
            //     style: const TextStyle(fontSize: 12, color: Colors.black87),
            //     textAlign: TextAlign.center,
            //   ),
            // ),

            // const SizedBox(height: 20),

            // --- ตารางแสดงข้อมูล ---
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

            const SizedBox(height: 20),

            // --- ปุ่มควบคุม (Action Buttons) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ปุ่ม Test Read (ใช้แก้ปัญหาค่าไม่ขึ้น)
                // if (connectionStatus == "Connected" || connectionStatus == "Receiving data...")
                //   ElevatedButton.icon(
                //     onPressed: onTestRead,
                //     icon: const Icon(Icons.refresh),
                //     label: const Text("Test Read"),
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.orange,
                //       foregroundColor: Colors.white,
                //     ),
                //   ),
                

                const SizedBox(width: 10),

                // ปุ่ม Save (โชว์เฉพาะตอนมีข้อมูล)
                if (healthData != null && healthData!.weight > 0)
                  ElevatedButton.icon(
                    onPressed: onSave,
                    icon: const Icon(Icons.save),
                    label: const Text("บันทึก"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}