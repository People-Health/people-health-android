import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic> acidentado;

  const DetailsPage(this.acidentado, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Nome: ${acidentado['nome']}'),
            Text('Idade: ${acidentado['idade']}'),
          ],
        ),
      ),
    );
  }
}
