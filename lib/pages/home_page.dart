import 'package:app_health/pages/BodyPage.dart';
import 'package:app_health/pages/ble_page.dart';
import 'package:app_health/pages/topbar.dart';
import 'package:app_health/widgets/button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Self Care')),
      body: Column(
        children: const [
          topbar(),
          SizedBox(height: 10),
          MenuButtons(),
          SizedBox(height: 5),
          BodyPage(),
          BlePage(),
        ],
      ),
    );
  }
}
