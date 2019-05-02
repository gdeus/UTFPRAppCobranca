import 'package:flutter/material.dart';
import 'package:teste_api_cobranca/api_rest/RestApi.dart';
import 'package:teste_api_cobranca/models/Usuario.dart';
import 'package:teste_api_cobranca/models/divida.dart';
import 'package:teste_api_cobranca/screens/geraReportScreen.dart';
import 'package:teste_api_cobranca/screens/loginScreen.dart';
import 'dart:async';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'dart:convert';

import 'package:teste_api_cobranca/widgets/custom_drawer.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  TextEditingController cliente = new TextEditingController();
  TextEditingController data1 = new TextEditingController();
  TextEditingController data2 = new TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<Usuario>> key = new GlobalKey();
  List<Divida> dividasRelatorio;
  static List<Usuario> listClientes = new List<Usuario>();
  RestApi rest = new RestApi();
  AutoCompleteTextField searchTextField;
  bool loading = true;

  carregaClientes() async {
    print("Entrei no carrega clientes");
    listClientes = await rest.todosOsClientes();
    if(listClientes != null){
      setState(() {
        loading = false;
      });
    }
  }


  @override
  void initState() {
    carregaClientes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: ListView(
        padding: EdgeInsets.all(15.0),
        children: <Widget>[
          loading ? CircularProgressIndicator() :
          searchTextField = AutoCompleteTextField(
            key: key,
            clearOnSubmit: true,
            suggestions: listClientes,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
              hintText: "Busque um cliente",
              hintStyle: TextStyle(color: Colors.black),
            ),
            itemFilter: (item, query) {
              return item.nome.toLowerCase().startsWith(query.toLowerCase());
            },
            itemSorter: (a, b) {
              return a.nome.compareTo(b.nome);
            },
            itemSubmitted: (item) {
              setState(() {
                searchTextField.textField.controller.text = item.nome;
              });
            },
            itemBuilder: (context, item) {
              return rowCliente(item);
            },
          ),
          SizedBox(
            height: 16.0,
          ),
          TextFormField(
            controller: data1,
            decoration: InputDecoration(hintText: "Data 1"),
            validator: (text) {
              if (text.isEmpty || text.length < 6) return "Senha inválida!!";
            },
          ),
          TextFormField(
            controller: data2,
            decoration: InputDecoration(hintText: "Data 2"),
            validator: (text) {
              if (text.isEmpty || text.length < 6) return "Senha inválida!!";
            },
          ),
          SizedBox(
            height: 15.0,
          ),
          RaisedButton(
            child: Text(
              "Gerar Relatório",
              style: TextStyle(fontSize: 18.0),
            ),
            onPressed: () {
              print("Valor do controlador : " + searchTextField.textField.controller.text);
              print("Valor do controlador : " + cliente.text);
              gerarRelatorio();
              //Navigator.pop(context);
            },
          ),
          Text(
            "Bug",
            style: TextStyle(fontSize: 20.0, color: Colors.black12),
          ),
        ],
      ),
    );
  }




  gerarRelatorio() async {
    print("entrei no gerarelatorio  ");
    dividasRelatorio =
        await rest.relatorio(cliente.text, data1.text, data2.text);
    print(dividasRelatorio.length);
    if (dividasRelatorio.length == 0) {
      _showDialog();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GeraRelatorioScreen(
                  listDividaRelatorio: dividasRelatorio,)),
      );
    }
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("ATENÇÃO"),
            content: new Text(
                "Não existem registros nos parâmetros digitados, favor verifique-os"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget rowCliente(Usuario usuario) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          usuario.nome,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          usuario.id,
        ),
      ],
    );
  }
}
