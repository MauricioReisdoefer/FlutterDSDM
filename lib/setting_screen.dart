import 'package:flutter/material.dart';
import 'fall_detector.dart';

class SettingsScreen extends StatefulWidget {
  final FallDetector fallDetector;

  const SettingsScreen({super.key, required this.fallDetector});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double threshold = 20.0;

  @override
  void initState() {
    super.initState();
    threshold = widget.fallDetector.decelerationThreshold;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configurações')),
      body: Column(
          children: [
            Text(
              'Sensibilidade (Threshold): ${threshold.toStringAsFixed(1)}',
              style: TextStyle(fontSize: 18),
            ),
            Slider(
              value: threshold,
              min: 5.0,
              max: 100.0,
              divisions: 95,
              label: threshold.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  threshold = value;
                  widget.fallDetector.updateThreshold(value);
                });
              },
            ),
            Text("Número do SMS", style: TextStyle(fontSize: 18)),
          ],
        ),
      );
  }
}
