import 'package:flutter/material.dart';
import 'package:app_health/widgets/ContainerOutput.dart';

class BodyPage extends StatelessWidget {
  const BodyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 380,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: const Color(0xFFCCCCFF),
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text('12/08/2568', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('12:30 น.'),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SizedBox(height: 10),
                ContainerOutput(header: 'น้ำหนัก', data: '25', unit: 'kg'),
                SizedBox(width: 10),
                ContainerOutput(header: 'ส่วนสูง', data: '170', unit: 'cm'),
                SizedBox(height: 10),
              ],
            ),
            SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SizedBox(height: 10),
                ContainerOutput(header: 'BMI', data: '24.1', unit: 'kg/m²'),
                SizedBox(width: 10),
                ContainerOutput(header: 'Heart Rate', data: '120', unit: 'bpm'),
                SizedBox(height: 10),
              ],)
          ],
        ),
      ),
    );
  }
}
