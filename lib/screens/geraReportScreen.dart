import 'package:flutter/material.dart';
import 'package:teste_api_cobranca/models/divida.dart';


class GeraRelatorioScreen extends StatelessWidget {
  final List<Divida> listDividaRelatorio;

  GeraRelatorioScreen({@required this.listDividaRelatorio});
  @override
  Widget build(BuildContext context) {
    double teste = total();
    return Scaffold(
      appBar: AppBar(
        title: Text("Relatório"),
      ),
      body: Column(
        children: <Widget>[
          Text(teste.toString()),
        ],

      ),
    );
  }


  double total(){
    double x, y;

    x = somatorioPagas();
    y = somatorioDevendo();

    return x - y;
  }


  double somatorioPagas(){
    int i;
    double conversor, somador = 0;
    int quantidade = listDividaRelatorio.length;
    print(quantidade);
    for(i=0; i < quantidade; i++){
      if(listDividaRelatorio[i].pago == "1") {
        conversor = double.parse(listDividaRelatorio[i].valor);
        somador = somador + conversor;
      }
    }

    print("Saindo da funcao resultado: " + somador.toString());
    return somador;

  }

  double somatorioDevendo(){
    int i;
    double conversor, somador = 0;
    for(i=0; i < listDividaRelatorio.length; i++){
      if(listDividaRelatorio[i].pago == "0") {
        conversor = double.parse(listDividaRelatorio[i].valor);
        somador = somador + conversor;
      }
    }
    print("Saindo da funcao resultado: " + somador.toString());

    return somador;
  }
}
