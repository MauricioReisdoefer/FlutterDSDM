import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:telephony/telephony.dart';

typedef FallCallback = void Function();

class FallDetector {
  double decelerationThreshold;
  double? _previousAcceleration;
  final Telephony _telephony = Telephony.instance;

  FallCallback? onFallDetected;

  bool _fallDetected = false; // Flag para cooldown

  FallDetector({this.decelerationThreshold = 20.0});

  void startListening() {
    accelerometerEvents.listen((AccelerometerEvent event) async {
      double currentAcceleration = sqrt(
        pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2),
      );

      if (_previousAcceleration != null) {
        double delta = _previousAcceleration! - currentAcceleration;

        if (delta > decelerationThreshold) {
          // Se já detectou queda e está no cooldown, ignora
          if (_fallDetected) return;

          // Marca como queda detectada
          _fallDetected = true;

          // Chama callback externo (se existir)
          if (onFallDetected != null) {
            onFallDetected!();
          }
          await _handleFallDetected();

          // Após o cooldown, libera para novas detecções
          Future.delayed(Duration(seconds: 5), () {
            _fallDetected = false;
          });
        }
      }

      _previousAcceleration = currentAcceleration;
    });
  }

  Future<void> _handleFallDetected() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();
    print("QUEDA DETECTADA");
    if (!serviceEnabled ||
        permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print("Permissão de localização negada");
        return;
      }
    }

    Position position =
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("MENSAGEM SENDO ENVIADA");
    String mensagem___ = "POSSÍVEL ACIDENTE DETECTADO | LATITUDE: ${position.latitude} | LONGITUDE${position.longitude}";
    try {
      await _telephony.sendSms(
        to: "5549988166646",
        message: mensagem___,
        isMultipart: false,
      );
      print("SMS enviado com sucesso");
    } catch (e) {
      print("Erro ao enviar SMS: $e");
    }

  }

  void updateThreshold(double newThreshold) {
    decelerationThreshold = newThreshold;
  }
}
