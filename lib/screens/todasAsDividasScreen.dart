import 'package:flutter/material.dart';
import 'package:teste_api_cobranca/api_rest/RestApi.dart';
import 'package:teste_api_cobranca/models/Usuario.dart';
import 'package:teste_api_cobranca/models/divida.dart';
import 'package:teste_api_cobranca/screens/homeScreen.dart';
import 'package:teste_api_cobranca/screens/reportScreen.dart';
import 'package:teste_api_cobranca/widgets/custom_drawer.dart';

class todasDividas extends StatefulWidget {
  final Usuario user;

  const todasDividas({@required this.user});

  @override
  _todasDividasState createState() => _todasDividasState();
}

class _todasDividasState extends State<todasDividas> {
  RestApi rest = new RestApi();
  List<Divida> todasAsDividas;
  int quantidadeClientes;
  DateTime dataVcto;
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: FutureBuilder(
                      future: carregar(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          default:
                            return Column(
                              children: <Widget>[
                                Expanded(
                                  child: ListView.builder(
                                      padding: EdgeInsets.only(top: 10.0),
                                      itemCount: quantidadeClientes,
                                      itemBuilder: (context, index) {
                                        dataVcto = DateTime.parse(
                                            todasAsDividas[index].data_vcto);
                                        if (todasAsDividas[index].pago == "0") {
                                          todasAsDividas[index].pago =
                                              "Em atraso";
                                          return CardsVencido(
                                              todasAsDividas[index]);
                                        } else if (dataVcto ==
                                            new DateTime.now()) {
                                          todasAsDividas[index].pago =
                                              "Vencimento hoje";
                                          return CardsVctoDia(
                                              todasAsDividas[index]);
                                        } else {
                                          todasAsDividas[index].pago = "Pago";
                                          return CardsPago(
                                              todasAsDividas[index]);
                                        }
                                      }),
                                )
                              ],
                            );
                        }
                      },
                    ),
                  ),
                ),
              ],
            )
        );
  }

  carregar() async {
    todasAsDividas = await rest.todasAsDividas();
    quantidadeClientes = await todasAsDividas.length;
  }

  Widget CardsVencido(Divida divida) {
    return Card(
      color: Colors.redAccent,
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "RS: " + divida.valor,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "Vencimento: " +
                    dataVcto.day.toString() +
                    "/" +
                    dataVcto.month.toString() +
                    "/" +
                    dataVcto.year.toString(),
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "Status: " + divida.pago,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "Parcela: " + divida.parcela,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "Cliente: " + divida.nome,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget CardsVctoDia(Divida divida) {
    return Card(
      color: Colors.yellow[900],
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "RS: " + divida.valor,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "Vencimento: " +
                    dataVcto.day.toString() +
                    "/" +
                    dataVcto.month.toString() +
                    "/" +
                    dataVcto.year.toString(),
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "Status: " + divida.pago,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "Parcela: " + divida.parcela,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget CardsPago(Divida divida) {
    return Card(
      color: Colors.green[600],
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "RS: " + divida.valor,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "Vencimento: " +
                    dataVcto.day.toString() +
                    "/" +
                    dataVcto.month.toString() +
                    "/" +
                    dataVcto.year.toString(),
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "Status: " + divida.pago,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "Parcela: " + divida.parcela,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}
