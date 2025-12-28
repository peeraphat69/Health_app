import 'package:app_health/widgets/container_output.dart';
import 'package:flutter/material.dart';
import '../models/health_data.dart';

class HealthDashboard extends StatelessWidget {
  final HealthData data;
  const HealthDashboard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            ContainerOutput(
              header: 'น้ำหนัก',
              value: data.weight.toStringAsFixed(1),
              unit: 'kg',
            ),
            const SizedBox(height: 10),
            ContainerOutput(
              header: 'BMI',
              value: data.bmi.toStringAsFixed(1),
              unit: '',
            ),
          ],
        ),
        Column(
          children: [
            ContainerOutput(
              header: 'ส่วนสูง',
              value: data.height.toStringAsFixed(0),
              unit: 'cm',
            ),
          ],
        ),
      ],
    );
  }
}
