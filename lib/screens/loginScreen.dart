import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:teste_api_cobranca/api_rest/RestApi.dart';
import 'package:teste_api_cobranca/models/Usuario.dart';
import 'package:teste_api_cobranca/screens/homeScreen.dart';
import 'package:teste_api_cobranca/screens/lojaScreen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

Usuario usuarioLogado;


class _LoginState extends State<Login> {

  TextEditingController usuario = new TextEditingController();
  TextEditingController senha = new TextEditingController();
  RestApi rest = new RestApi();
  List<Usuario> usuarioLogado;
  int i;

  String msg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login Loja"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Criar Conta",
                style: TextStyle(fontSize: 15.0),
              ),
              textColor: Colors.white,
              onPressed: () {
                /*Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context)=>CriarContaTela())
                );*/
              },
            )
          ],
        ),
        body: Form(
          child: ListView(
            padding: EdgeInsets.all(15.0),
            children: <Widget>[
              TextFormField(
                controller: usuario,
                decoration: InputDecoration(hintText: "Usuario"),
                validator: (text){
                  if(text.isEmpty) return "Usuário inválido!!!";
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: senha,
                decoration: InputDecoration(hintText: "Senha"),
                obscureText: true,
                validator: (text){
                  if (text.isEmpty || text.length < 6) return "Senha inválida!!";
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  onPressed: () {},
                  child: Text(
                    "Esqueci minha senha",
                    textAlign: TextAlign.right,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
              SizedBox(height: 15.0,),
              RaisedButton(
                child: Text("Login",
                  style: TextStyle(fontSize: 18.0),
                ),
                onPressed: (){
                  carregalogin();
                  //Navigator.pop(context);
                },
              ),
              Text(msg,style: TextStyle(fontSize: 20.0,color: Colors.black12),),
            ],
          ),
        )

    );
  }

  carregalogin() async{
    print("entrei no carregalogin  ");
    usuarioLogado = await rest.login(usuario.text, senha.text);
    if(usuarioLogado[0] != null){
      if(usuarioLogado[0].tipo =="cliente") {
        print("----- ATENÇÃO LOGANDO COMO CLIENTE");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(user: usuarioLogado[0],)),
        );
      } else {
        print("----- ATENÇÃO LOGANDO COMO LOJA");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LojaScreen(user: usuarioLogado[0],)),
        );
      }
    } else {
      msg = "Usuário e senha incorretos!!!";
    }
  }
}

