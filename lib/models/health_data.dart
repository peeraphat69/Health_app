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

  factory HealthData.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);

    return HealthData(
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      bmi: (json['bmi'] as num).toDouble(),
    );
  }
}
