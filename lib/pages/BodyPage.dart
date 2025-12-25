import 'package:app_health/widgets/ContainerOutput.dart';
import 'package:flutter/material.dart';
import '../models/health_data.dart'; // อย่าลืม import model

class BodyPage extends StatelessWidget {
  // 1. เพิ่มตัวแปรรับค่าข้อมูล
  final HealthData? healthData; 
  final String connectionStatus;

  const BodyPage({
    super.key, 
    this.healthData, 
    this.connectionStatus = "Disconnected"
  });

  @override
  Widget build(BuildContext context) {
    // เตรียมข้อมูลที่จะแสดง (ถ้ายังไม่มีข้อมูล ให้แสดง --)
    String weight = healthData?.weight.toStringAsFixed(1) ?? '--';
    String height = healthData?.height.toStringAsFixed(0) ?? '--';
    String bmi = healthData?.bmi.toStringAsFixed(1) ?? '--';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFFCCCCFF),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // แสดงสถานะ Bluetooth แทนวันที่ (หรือจะใส่วันที่เหมือนเดิมก็ได้)
            Text(
              'Status: $connectionStatus',
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                color: connectionStatus == "Connected" ? Colors.green : Colors.red
              ),
            ),
            const SizedBox(height: 20),

            /// แถวข้อมูล (responsive)
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                // ส่งค่าตัวแปรเข้าไปแทนค่าคงที่
                ContainerOutput(header: 'น้ำหนัก', value: weight, unit: 'kg'),
                ContainerOutput(header: 'ส่วนสูง', value: height, unit: 'cm'),
                ContainerOutput(header: 'BMI', value: bmi, unit: 'kg/m²'),
                // Heart Rate ถ้ายังไม่มีข้อมูลจริง ปล่อย hardcode ไว้ก่อน หรือลบออก
                const ContainerOutput(header: 'Heart Rate', value: '--', unit: 'bpm'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}