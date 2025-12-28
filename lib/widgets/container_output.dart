import 'package:flutter/material.dart';

class ContainerOutput extends StatelessWidget {
  final String header;
  final String value; // ← รับค่าที่แสดงผลโดยตรง
  final String unit;

  const ContainerOutput({
    super.key,
    required this.header,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          header,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: 120,
          height: 40,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xFFFFFFFF),
          ),
          child: Center(
            child: Text(
              '$value $unit',
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}
