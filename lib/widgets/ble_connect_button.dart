import 'package:flutter/material.dart';

class BleConnectButton extends StatelessWidget {
  final VoidCallback onPressed;
  const BleConnectButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text("Reconnect"),
    );
  }
}
