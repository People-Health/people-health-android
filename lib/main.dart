/*import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'People health',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}*/




import 'package:flutter/material.dart';
import '../api/locationService.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late LocationService locationService;
  late IOWebSocketChannel channel;


  @override
  void initState() {
    super.initState();
    initLocationService();
  }

  Future<void> initLocationService() async {
    locationService = LocationService();
    await locationService.init();

    channel = IOWebSocketChannel.connect('ws://10.0.2.2:8080/flutter-app');
    var locationData = await locationService.getLocation();
     var lat = locationData.latitude!;
     var long = locationData.longitude!;

    while (true) {
      lat += 0.002;
      long += 0.002;
      String locationString = '$lat, $long';
      channel.sink.add(locationString);
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const  Center(
        child: Text('Obtendo localização ..'),
      ),
    );
  }
}