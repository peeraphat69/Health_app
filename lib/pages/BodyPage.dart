import 'package:app_health/widgets/ContainerOutput.dart';
import 'package:flutter/material.dart';
class BodyPage extends StatelessWidget {
  const BodyPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            const Text(
              '12/08/2568',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('12:30 น.'),
            const SizedBox(height: 20),

            /// แถวข้อมูล (responsive)
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: const [
                ContainerOutput(header: 'น้ำหนัก', data: '25', unit: 'kg'),
                ContainerOutput(header: 'ส่วนสูง', data: '170', unit: 'cm'),
                ContainerOutput(header: 'BMI', data: '24.1', unit: 'kg/m²'),
                ContainerOutput(header: 'Heart Rate', data: '120', unit: 'bpm'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
