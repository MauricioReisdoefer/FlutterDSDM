import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';

class FallDetector {
  static const double threshold = 50.0; 
  
  void startListening(void Function() onFallDetected) {
    accelerometerEvents.listen((AccelerometerEvent event) {
      double acceleration = sqrt(
        pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2),
      );

      if (acceleration > threshold) {
        onFallDetected();
      }
    });
  }
}
