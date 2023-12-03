import 'dart:convert';

import 'package:flutter/material.dart';
import '../api/api_client.dart';
import 'profile_page.dart';
import '../assets/animation/LogoApp.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  late final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  Future<void> _authenticateUser(BuildContext context) async {
    var apiClient = APIClient();
    final userData = await apiClient.authenticateUser(
      _usernameController.text,
      _passwordController.text,
    );

    if (mounted) {
      if (userData != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(userData)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário ou senha inválidos')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      key: _scaffoldKey,
      appBar: AppBar(
          backgroundColor: Colors.blue[50],
          title: const Row(
            children: <Widget>[
              LogoApp(),
              Text('People Health'),
            ],
          )),
      body: SingleChildScrollView(
        child: SizedBox(
          height:
          MediaQuery.of(context).size.height * 0.6, //negocico do demonio
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      labelText: 'Usuário',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite seu usuário';
                      }
                      return null;
                    },
                  ),
                  SizedBox.fromSize(size: const Size(0, 12)), // senha
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      labelText: 'Senha',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite sua senha';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _authenticateUser(context);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      shadowColor: MaterialStateProperty.all(Colors.transparent),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    child: Container(
                      width: 160,
                      height: 45,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue[300]!, Colors.blue[700]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 1),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Center(
                        child: Text(
                          'Entrar',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
