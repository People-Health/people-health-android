import 'dart:convert';

import 'package:flutter/material.dart';
import '../api/locationService.dart';
import '../api/api_client.dart';
import 'package:web_socket_channel/io.dart';
import 'details_page.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> user;

  const ProfilePage(this.user, {Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _rgController = TextEditingController();
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

    if (widget.user['role'] == 'socorrista') {
      channel = IOWebSocketChannel.connect('ws://localhost:8080/flutter-app');
      while (true) {
        var locationData = await locationService.getLocation();
        channel.sink.add({
          'userId': widget.user['id'],
          'latitude': locationData.latitude,
          'longitude': locationData.longitude,
        });
        await Future.delayed(const Duration(seconds: 10));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(widget.user['nome']),
            Text(widget.user['telefone']),
            Text(widget.user['empresa']),
            TextFormField(
              controller: _rgController,
              decoration: const InputDecoration(
                labelText: 'RG do acidentado',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _searchAcidentado(context);
              },
              child: const Text('Pesquisar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _searchAcidentado(BuildContext context) async {
    APIClient().fetchAcidentadoByRG(_rgController.text);

    final acidentadoData = await APIClient().channel.stream.first;
    final acidentado = json.decode(acidentadoData);

    if (mounted) {
      if (acidentado != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsPage(acidentado)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('RG não encontrado')),
        );
      }
    }
  }
}
