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
  List<Usuario> todosOsClientes;
  int quantidadeClientes;
  DateTime dataVcto;
  int indicador = 0;
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: Column(
              children: <Widget>[
                Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                  RaisedButton(

                    child: Text(
                      "Pagas",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    onPressed: () {
                      carregar();
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      "Atrasadas",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    onPressed: () {
                      indicador = 1;
                      carregar();
                    },
                  ),
                ],
                ),
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
                                        dataVcto = DateTime.parse(todasAsDividas[index].data_vcto);
                                        if (todasAsDividas[index].pago == "0" && dataVcto.isBefore(DateTime.now())) {
                                          todasAsDividas[index].pago = "Em atraso";
                                          return CardsVencido(todasAsDividas[index]);
                                        }
                                        if (todasAsDividas[index].pago == "1"){
                                          todasAsDividas[index].pago = "Pago";
                                          return CardsPago(todasAsDividas[index]);
                                        }
                                        if (todasAsDividas[index].pago == "0" && dataVcto.isAfter(DateTime.now())){
                                          todasAsDividas[index].pago = "Há vencer";
                                          return CardsVctoDia(todasAsDividas[index]);
                                        }
                                      }),
                                ),
                                Text("Total Inadimplente: R\$" + somaDevendo().toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                                Text("Total Pago: R\$" + somaPagas().toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                                Text("Saldo : R\$" + (somaPagas() - somaDevendo()).toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0))
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
    if(indicador == 0){
      todasAsDividas = await rest.todasAsDividas();
      quantidadeClientes = await todasAsDividas.length;
    }
    if (indicador == 1){
      setState(() {

      });
      todasAsDividas = await rest.todasAsDividasAtrasadas();
      quantidadeClientes = await todasAsDividas.length;
    }


    if (indicador == 2){
      setState(() {

      });
      todasAsDividas = await rest.todasAsDividasAtrasadas();
      quantidadeClientes = await todasAsDividas.length;
    }

  }
  double somaDevendo(){

    double conversor, somador = 0.0;
    int i;

    for(i=0;i<todasAsDividas.length;i++){
      dataVcto = DateTime.parse(todasAsDividas[i].data_vcto);
      if(todasAsDividas[i].pago == '0' && dataVcto.isBefore(DateTime.now())){
        conversor = double.parse(todasAsDividas[i].valor);
        somador = somador + conversor;
      }
    }
    return somador;
  }

  double somaPagas(){
    double conversor, somador = 0.0;
    int i;

    for(i=0;i<todasAsDividas.length;i++){
      if(todasAsDividas[i].pago == '1'){
        conversor = double.parse(todasAsDividas[i].valor);
        somador = somador + conversor;
      }
    }

    return somador;
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
                "Cliente: " + divida.nome,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "ID da dívida: " + divida.id,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
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
                "Cliente: " + divida.nome ,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "ID da dívida: " + divida.id,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
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
                "Cliente: " + divida.nome ,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "ID da dívida: " + divida.id,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}
