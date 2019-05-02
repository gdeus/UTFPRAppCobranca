import 'package:flutter/material.dart';
import 'package:teste_api_cobranca/api_rest/RestApi.dart';
import 'package:teste_api_cobranca/models/Usuario.dart';
import 'package:teste_api_cobranca/models/divida.dart';

class HomeScreen extends StatefulWidget {
  final Usuario user;

  const HomeScreen({@required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RestApi rest = new RestApi();
  List<Divida> listDividaAtrasadas;
  int quantidadeClientes;
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: <Widget>[
        Scaffold(
            appBar: AppBar(
              title: Text("App Cobrança"),
            ),
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
                                        if (listDividaAtrasadas[index]
                                                .id_user ==
                                            widget.user.id) {
                                          listDividaAtrasadas[index].pago =
                                              "Atrasado";
                                          return Cards(
                                              listDividaAtrasadas[index]);
                                        } else {
                                          print("saiu do IF");
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
        ),
      ],
    );
  }

  carregar() async {
    listDividaAtrasadas = await rest.dividasAtrasadas();
    quantidadeClientes = await listDividaAtrasadas.length;
  }

  Widget Cards(Divida divida) {
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
                "Vencimento: " + divida.data_vcto,
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
