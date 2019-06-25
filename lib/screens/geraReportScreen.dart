import 'package:flutter/material.dart';
import 'package:teste_api_cobranca/models/divida.dart';
import 'package:teste_api_cobranca/screens/grahpsScreen.dart';


class GeraRelatorioScreen extends StatelessWidget {
  final List<Divida> listDividaRelatorio;
  final String cliente, data1, data2;
  int contadorPago = 0, contadorDevendo = 0;
  double somadorPago = 0, somadorDevendo = 0;
  DateTime dataVcto;

  GeraRelatorioScreen(this.listDividaRelatorio, this.cliente, this.data1, this.data2);

  @override
  Widget build(BuildContext context) {
    double teste = somatorio();
    return Scaffold(
      appBar: AppBar(
        title: Text("Relatório"),
      ),
      body: Column(
        children: <Widget>[
          Text("Parametros utilizados: ", style: TextStyle(fontWeight: FontWeight.bold),),
          Text("Cliente: " + cliente, style: TextStyle(fontWeight: FontWeight.bold),),
          Text("Data 1: " + data1 , style: TextStyle(fontWeight: FontWeight.bold),),
          Text("Data 2: " + data2 , style: TextStyle(fontWeight: FontWeight.bold),),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: listDividaRelatorio.length,
                itemBuilder: (context, index) {
                  dataVcto = DateTime.parse(listDividaRelatorio[index].data_vcto);
                  if (listDividaRelatorio[index].pago == "0" && dataVcto.isBefore(DateTime.now())) {
                    listDividaRelatorio[index].pago = "Em atraso";
                    return CardsVencido(listDividaRelatorio[index]);
                  } else if (listDividaRelatorio[index].pago == "1"){
                    listDividaRelatorio[index].pago = "Pago";
                    return CardsPago(listDividaRelatorio[index]);
                  } else if (listDividaRelatorio[index].pago == "0" && dataVcto.isAfter(DateTime.now())){
                    listDividaRelatorio[index].pago = "Há vencer";
                    return CardsVctoDia(listDividaRelatorio[index]);
                  }

                }),
          ),
          Text("Número de parcelas pagas: " + contadorPago.toString(), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
          Text("Número de parcelas devendo: " + contadorDevendo.toString(), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
          Text("Em dívida: " + somadorDevendo.toString(), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
          Text("Score: " + score(), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
          RaisedButton(
            onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => GraphScreen(contadorPago, contadorDevendo, somadorPago, somadorDevendo)),
            )
            },
            child: Text('Gerar Gráficos'),
          ),
        ],

      ),
    );
  }


  double somatorio(){
    int i;
    double conversor;
    int quantidade = listDividaRelatorio.length;
    DateTime data2;
    for(i=0; i < quantidade; i++){
      data2 = DateTime.parse(listDividaRelatorio[i].data_vcto);
      listDividaRelatorio[i].data_vcto;
      if(listDividaRelatorio[i].pago == "1") {
        conversor = double.parse(listDividaRelatorio[i].valor);
        somadorPago = somadorPago + conversor;
        contadorPago++;
      }
      if(listDividaRelatorio[i].pago == "0" && data2.isBefore(DateTime.now())) {
        conversor = double.parse(listDividaRelatorio[i].valor);
        somadorDevendo = somadorDevendo + conversor;
        contadorDevendo++;
      }
    }


    return somadorPago - somadorDevendo;

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

  String score(){
    String score;
    if(contadorDevendo > 3){
      score = "Baixo";
    } else if(somadorDevendo > 300.0){
      score = "Baixo";
    } else if(contadorDevendo == 0){
      score = "Ótimo";
    } else {
      score = "Bom";
    }

    return score;

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
}
