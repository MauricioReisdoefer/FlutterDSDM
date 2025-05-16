import 'package:flutter/material.dart';
import 'fall_detector.dart';

void main() {
  runApp(FallDetectionApp());
}

class FallDetectionApp extends StatefulWidget {
  @override
  _FallDetectionAppState createState() => _FallDetectionAppState();
}

class _FallDetectionAppState extends State<FallDetectionApp> {
  String status = "Aguardando detecção de queda...";
  final FallDetector fallDetector = FallDetector();

  @override
  void initState() {
    super.initState();
    fallDetector.startListening(() {
      setState(() {
        status = "💥 Queda detectada!";
      });

      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            status = "Aguardando detecção de queda...";
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detector de Queda',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Detector de Queda'),
          centerTitle: true,
        ),
        body: Center(
          child: Text(
            status,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
