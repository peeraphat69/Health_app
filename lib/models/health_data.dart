import 'dart:convert';

class HealthData {
  final double weight;
  final double height;
  final double bmi;

  HealthData({
    required this.weight,
    required this.height,
    required this.bmi,
  });

  // ❌ ลบอันเดิม (fromJsonString) ออก
  // ✅ ใช้อันใหม่นี้แทน (รับค่าแบบ "65.5,170,22.6")
  factory HealthData.fromCsvString(String data) {
    // แยกข้อความด้วยเครื่องหมายคอมม่า
    final parts = data.split(','); 

    // ป้องกัน Error กรณีข้อมูลมาไม่ครบ
    if (parts.length < 3) {
      return HealthData(weight: 0, height: 0, bmi: 0);
    }

    return HealthData(
      weight: double.tryParse(parts[0]) ?? 0.0, // ตัวที่ 1: น้ำหนัก
      height: double.tryParse(parts[1]) ?? 0.0, // ตัวที่ 2: ส่วนสูง
      bmi: double.tryParse(parts[2]) ?? 0.0,    // ตัวที่ 3: BMI
    );
  }
}