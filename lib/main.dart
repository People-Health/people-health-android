import 'package:flutter/material.dart';
import 'api_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicativo para Hospital',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Usuário',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite seu usuário';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite sua senha';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final user = await APIClient.authenticateUser(
                      _usernameController.text,
                      _passwordController.text,
                    );
                    if (user != null) {
                      print('Usuário encontrado no servidor Java: $user');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(user)));
                    } else {
                      print('Usuário não encontrado no servidor Java');
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuário ou senha inválidos')));
                    }
                  }
                },
                child: const Text('Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> user;

  const ProfilePage(this.user, {super.key});

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
            CircleAvatar(
              backgroundImage: NetworkImage(widget.user['foto']),
              radius: 50.0,
            ),
            Text(widget.user['nome']),
            Text(widget.user['telefone']),
            Text(widget.user['empresa']),
            TextFormField(
              controller: _rgController,
              decoration: const InputDecoration(
                labelText: 'RG do acidentado',
              ),
            ),
            // preciso do servidor java
            // ElevatedButton(
            //   onPressed: () async {
            //     var acidentado = await APIClient.fetchAcidentadoByRG(_rgController.text);
            //     if (acidentado != null) {
            //       Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPage(acidentado)));
            //     } else {
            //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('RG não encontrado')));
            //     }
            //   },
            //   child: Text('Pesquisar'),
            // ),
          ],
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic> acidentado;

  const DetailsPage(this.acidentado, {super.key});

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
              Text('Tipo de acidente: ${acidentado['tipo']}'),
              Text('Data do acidente: ${acidentado['data']}'),
              Text('Local do acidente: ${acidentado['local']}'),
              Text('Gravidade do acidente: ${acidentado['gravidade']}'),
              Text('Tratamento recomendado: ${acidentado['tratamento']}'),
          ],
        ),
      ),
    );
  }
}
