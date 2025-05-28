import 'package:flutter/material.dart';
import 'fall_detector.dart';
import 'setting_screen.dart';

void main() {
  runApp(FallDetectionApp());
}

class FallDetectionApp extends StatefulWidget {
  const FallDetectionApp({super.key});

  @override
  _FallDetectionAppState createState() => _FallDetectionAppState();
}

class _FallDetectionAppState extends State<FallDetectionApp> {
  String status = "Aguardando detecção de queda...";
  final FallDetector fallDetector = FallDetector();

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    // Configura o callback para detectar queda
    fallDetector.onFallDetected = () {
      onFallDetected();
    };

    // Inicia a escuta dos eventos do acelerômetro
    fallDetector.startListening();
  }

  void onFallDetected() {
    setState(() {
      status = "Queda detectada!";
    });

    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('Queda detectada!'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detector de Queda',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Detector de Queda'),
          centerTitle: true,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          SettingsScreen(fallDetector: fallDetector),
                    ),
                  );
                },
              ),
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  status,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                title: Text(
                  "Sobre o aplicativo",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      "Este aplicativo detecta quedas usando os sensores do dispositivo. "
                      "Quando uma queda é detectada, ele envia um SMS com a localização atual para o número configurado.\n\n"
                      "Você pode ajustar a sensibilidade da detecção (intensidade do impacto) acessando o menu de configurações no ícone de engrenagem acima.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
