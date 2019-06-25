import 'package:flutter/material.dart';
import 'package:teste_api_cobranca/api_rest/RestApi.dart';
import 'package:teste_api_cobranca/models/Usuario.dart';
import 'package:teste_api_cobranca/models/divida.dart';
import 'package:teste_api_cobranca/screens/getAllClienteScreen.dart';
import 'package:teste_api_cobranca/screens/reportClienteScreen.dart';
import 'package:teste_api_cobranca/widgets/custom_drawer.dart';
import 'package:teste_api_cobranca/widgets/custom_drawer_cliente.dart';

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
  DateTime dataVcto;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: <Widget>[
        Scaffold(
            appBar: AppBar(
              title: Text("App Cobrança"),
            ),
            drawer: CustomDrawer(_pageController),
            body: Column(
              children: <Widget>[
                Text("Atenção " + widget.user.nome + " suas contas abaixo estão em atraso: ", textAlign: TextAlign.center,style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold ),),
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
                                      itemCount: listDividaAtrasadas.length,
                                      itemBuilder: (context, index) {
                                          dataVcto = DateTime.parse(listDividaAtrasadas[index].data_vcto);
                                          if(dataVcto.isBefore(DateTime.now())) {
                                            return Cards(
                                                listDividaAtrasadas[index]);
                                          }
                                      }),
                                ),
                                Text("Total em atraso: R\$" + somador().toString(), style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),)
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
        Scaffold(
          appBar: AppBar(
            title: Text("Listar"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: getAllCliente(widget.user),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Relatórios"),
            centerTitle: true,
          ),
          drawer: CustomDrawerCliente(_pageController),
          body: ReportClienteScreen(user: widget.user,),
        ),
      ],
    );
  }

  carregar() async {
    listDividaAtrasadas = await rest.dividasAtrasadas(widget.user.id);
    quantidadeClientes = await listDividaAtrasadas.length;
  }

  double somador(){
    int i =0;
    double somador = 0;
    DateTime data;
    for(i=0;i < listDividaAtrasadas.length;i++){
      data = DateTime.parse(listDividaAtrasadas[i].data_vcto);
      if(data.isBefore(DateTime.now())){
        print("Entrei no IF DA SOMA");
        somador = somador + double.parse(listDividaAtrasadas[i].valor);
      }
    }

    return somador;
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
                "R\$ " + divida.valor,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "Vencimento: " + dataVcto.day.toString() + "/" + dataVcto.month.toString() + "/" + dataVcto.year.toString(),
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "Status: Atrasado" ,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "Cliente: " + widget.user.nome ,
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
