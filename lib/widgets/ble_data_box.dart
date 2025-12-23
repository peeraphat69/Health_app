import 'package:flutter/material.dart';

class BleDataBox extends StatelessWidget {
  final String data;
  const BleDataBox({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(data, style: const TextStyle(fontSize: 16)),
    );
  }
}
