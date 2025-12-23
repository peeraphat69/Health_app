import 'package:flutter/material.dart';

class BleStatusText extends StatelessWidget {
  final String status;
  const BleStatusText({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Status: $status",
      style: const TextStyle(fontSize: 18),
    );
  }
}
