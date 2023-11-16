import 'package:flutter/material.dart';
import '../api/api_client.dart';
import 'details_page.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> user;

  const ProfilePage(this.user, {Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _rgController = TextEditingController();

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
    var acidentado = await APIClient.fetchAcidentadoByRG(_rgController.text);

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
