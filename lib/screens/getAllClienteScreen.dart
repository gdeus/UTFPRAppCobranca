import 'package:flutter/material.dart';
import 'package:teste_api_cobranca/api_rest/RestApi.dart';
import 'package:teste_api_cobranca/models/Usuario.dart';
import 'package:teste_api_cobranca/models/divida.dart';

class getAllCliente extends StatefulWidget {
  @override
  final Usuario user;

  const getAllCliente(this.user);

  _getAllClienteState createState() => _getAllClienteState();
}

class _getAllClienteState extends State<getAllCliente> {
  RestApi rest = new RestApi();
  List<Divida> todasAsDividasCliente;
  List<Usuario> todosOsClientes;
  int quantidadeClientes;
  DateTime dataVcto;

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
                                    dataVcto = DateTime.parse(todasAsDividasCliente[index].data_vcto);
                                    if (todasAsDividasCliente[index].pago == "0" && dataVcto.isBefore(DateTime.now())) {
                                      todasAsDividasCliente[index].pago = "Em atraso";
                                      return CardsVencido(todasAsDividasCliente[index]);
                                    }
                                    if (todasAsDividasCliente[index].pago == "1"){
                                      todasAsDividasCliente[index].pago = "Pago";
                                      return CardsPago(todasAsDividasCliente[index]);
                                    }
                                    if (todasAsDividasCliente[index].pago == "0" && dataVcto.isAfter(DateTime.now())){
                                      todasAsDividasCliente[index].pago = "Há vencer";
                                      return CardsVctoDia(todasAsDividasCliente[index]);
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
    todasAsDividasCliente = await rest.getAllCliente(widget.user.id);
    quantidadeClientes = await todasAsDividasCliente.length;

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

