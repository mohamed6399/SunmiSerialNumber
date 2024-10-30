import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Numéro de série d\'un TPE Sunmi',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 247, 110, 68)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "Nunmero de serie TPE SUNMI"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _serialNumber;
  final SerialNumber _serialNumberService = SerialNumber();

  @override
  void initState() {
    super.initState();
    _fetchSerialNumber();
  }

  Future<void> _fetchSerialNumber() async {
    final serial = await _serialNumberService.getSerialNumber();
    setState(() {
      _serialNumber = serial ?? 'Numéro de série non disponible';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              'Numéro de série du TPE  : $_serialNumber',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class SerialNumber {
  static const platform = MethodChannel('com.example.yourapp/serial');

  Future<String?> getSerialNumber() async {
    try {
      final String serial = await platform.invokeMethod('getSerialNumber');
      return serial;
    } on PlatformException catch (e) {
      print("Failed to get serial number: '${e.message}'.");
      return null;
    }
  }
}
