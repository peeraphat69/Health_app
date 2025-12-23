import 'package:flutter/material.dart';
import '../services/ble_service.dart';
import '../widgets/ble_status_text.dart';
import '../widgets/ble_data_box.dart';
import '../widgets/ble_connect_button.dart';

class BlePage extends StatefulWidget {
  const BlePage({super.key});

  @override
  State<BlePage> createState() => _BlePageState();
}

class _BlePageState extends State<BlePage> {
  final BleService bleService = BleService();

  @override
  void initState() {
    super.initState();
    bleService.scanAndConnect(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Self Care")),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            BleStatusText(status: bleService.connectionStatus),
            const SizedBox(height: 5),
            BleDataBox(data: bleService.receivedData),
            const SizedBox(height: 5),
            BleConnectButton(
              onPressed: () {
                bleService.scanAndConnect(() => setState(() {}));
              },
            ),
          ],
        ),
      ),
    );
  }
}
