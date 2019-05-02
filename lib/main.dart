import 'package:flutter/material.dart';
import 'package:teste_api_cobranca/screens/homeScreen.dart';
import 'package:teste_api_cobranca/screens/loginScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sistema Cobrança',
    debugShowCheckedModeBanner: false,
    home: Login()
    );
  }
}

