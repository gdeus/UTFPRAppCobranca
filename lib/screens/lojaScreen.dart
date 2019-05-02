import 'package:flutter/material.dart';
import 'package:teste_api_cobranca/api_rest/RestApi.dart';
import 'package:teste_api_cobranca/models/Usuario.dart';
import 'package:teste_api_cobranca/models/divida.dart';
import 'package:teste_api_cobranca/screens/homeScreen.dart';
import 'package:teste_api_cobranca/screens/reportScreen.dart';
import 'package:teste_api_cobranca/screens/todasAsDividasScreen.dart';
import 'package:teste_api_cobranca/widgets/custom_drawer.dart';

class LojaScreen extends StatefulWidget {
  final Usuario user;

  const LojaScreen({@required this.user});

  @override
  _LojaScreenState createState() => _LojaScreenState();
}

class _LojaScreenState extends State<LojaScreen> {
  RestApi rest = new RestApi();
  List<Divida> listDividaVencDia;
  int quantidadeClientes;
  final _pageController = PageController();
  DateTime dataVcto;
  double soma = 0.0, convert;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: <Widget>[
        Scaffold(
            appBar: AppBar(
              title: Text(
                "Bem-vindo " + widget.user.nome,
              ),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_pageController),
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
                                Text("Parcelas a receber hoje: "),
                                Expanded(
                                  child: ListView.builder(
                                      padding: EdgeInsets.only(top: 10.0),
                                      itemCount: quantidadeClientes,
                                      itemBuilder: (context, index) {
                                        listDividaVencDia[index].pago = "Vencimento hoje";
                                        dataVcto = DateTime.parse(listDividaVencDia[index].data_vcto);
                                        return Cards(listDividaVencDia[index]);
                                      }),
                                ),
                                Text("Valor total á receber hoje: " + soma.toString()),
                              ],
                            );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Listar"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: todasDividas(user: widget.user),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Gráficos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: todasDividas(user: widget.user),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Relatórios"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: ReportScreen(),
        ),
      ],
    );
  }

  carregar() async {
    int i;
    soma = 0.0;
    print("Estou no carregar");
    listDividaVencDia = await rest.vencimentoNoDia();
    quantidadeClientes = await listDividaVencDia.length;
    print(quantidadeClientes);
    if(listDividaVencDia.length != 0) {
      for (i = 0; i <= listDividaVencDia.length; i++) {
        convert = double.parse(listDividaVencDia[i].valor);
        soma = soma + convert;
        print(soma);
      }
    } else {
      print("para parar de dar erro");
    }
    print("passei pelo carregar");
  }

  Widget Cards(Divida divida) {
    return Card(
      color: Colors.yellow[800],
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
                "Vencimento: " + dataVcto.day.toString() + '/' + dataVcto.month.toString() + '/' + dataVcto.year.toString(),
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
