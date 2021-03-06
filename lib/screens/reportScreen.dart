import 'package:flutter/material.dart';
import 'package:teste_api_cobranca/api_rest/RestApi.dart';
import 'package:teste_api_cobranca/models/Usuario.dart';
import 'package:teste_api_cobranca/models/divida.dart';
import 'package:teste_api_cobranca/screens/geraReportScreen.dart';
import 'package:teste_api_cobranca/screens/loginScreen.dart';
import 'dart:async';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:teste_api_cobranca/widgets/custom_drawer.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  AutoCompleteTextField searchTextField;
  TextEditingController cliente = new TextEditingController();
  TextEditingController data1 = new TextEditingController();
  TextEditingController data2 = new TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<Usuario>> key = new GlobalKey();
  List<Divida> dividasRelatorio;
  DateTime selectedDate = DateTime.now();
  static List<Usuario> listClientes = new List<Usuario>();
  RestApi rest = new RestApi();
  bool loading = true;
  String data = "Data 1 não inserida";
  String sdata2 = "Data 2 não inserida";
  String eDate1 = "Data 1 não inserida";
  String eDate2 = "Data 2 não inserida";

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        data = DateFormat("yyyy-MM-dd").format(selectedDate).toString();
        eDate1 = selectedDate.day.toString() + "/" + selectedDate.month.toString() + "/" + selectedDate.year.toString();
      });
  }

  Future<Null> _selectDate2(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        sdata2 = DateFormat("yyyy-MM-dd").format(selectedDate).toString();
        eDate2 = selectedDate.day.toString() + "/" + selectedDate.month.toString() + "/" + selectedDate.year.toString();
      });
  }

  carregaClientes() async {
    print("Entrei no carrega clientes");
    listClientes = await rest.todosOsClientes();
    if(listClientes != null){
      setState(() {
        loading = false;
      });
    } else {
      print("erro ao carregar lista de usuários");
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
          searchTextField = AutoCompleteTextField<Usuario>(
            key: key,
            clearOnSubmit: false,
            suggestions: listClientes,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
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
                searchTextField.textField.controller.text = item.nome + " - " + item.id;
                cliente.text = item.id;
              });
            },
            itemBuilder: (context, item) {
              return rowCliente(item);
            },
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(eDate1, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          RaisedButton(
            onPressed: () => _selectDate(context),
            child: Text('Selecionar Data 1'),
          ),
          Text(eDate2, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          RaisedButton(
            onPressed: () => _selectDate2(context),
            child: Text('Selecionar Data 2'),
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
        ],
      ),
    );
  }




  gerarRelatorio() async {
    print("entrei no gerarelatorio  ");
    dividasRelatorio = await rest.relatorio(cliente.text, data, sdata2);
    if (dividasRelatorio.length == 0) {
      _showDialog();
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => GeraRelatorioScreen(dividasRelatorio, "Teste", eDate1, eDate2)),);
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
