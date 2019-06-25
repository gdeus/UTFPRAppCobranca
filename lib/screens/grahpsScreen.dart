import 'package:charts_common/common.dart' as common;
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GraphScreen extends StatelessWidget {
  int Pagas;
  int naoPagas;
  double somaPagas;
  double somaNaoPagas;

  GraphScreen(this.Pagas, this.naoPagas, this.somaPagas, this.somaNaoPagas);
  @override
  Widget build(BuildContext context) {
    var data=[
      Dividas(Pagas, 'Paga',common.Color(r: 34, g: 129, b: 53)),
      Dividas(naoPagas, "Não pagas", common.Color(r: 176, g: 45, b: 45))
    ];

    var dataValores=[
      DividasValores(somaPagas ,'Pago', common.Color(r: 34, g: 129, b: 53)),
      DividasValores(somaNaoPagas ,'Não pago', common.Color(r: 176, g: 45, b: 45))
    ];


    var series=[
      charts.Series(
        domainFn: (Dividas dividas,_)=>dividas.tipo,
        measureFn: (Dividas dividas,_)=>dividas.quantidade,
        colorFn: (Dividas dividas,_)=>dividas.color,
        id: "Dividas",
        data: data,
        labelAccessorFn: (Dividas dividas,_)=> '${dividas.tipo} : ${dividas.quantidade.toString()}',
      )
    ];

    var seriesDividas=[
      charts.Series(
        domainFn: (DividasValores dividasValores,_)=> dividasValores.tipo,
        measureFn: (DividasValores dividasValores,_)=>dividasValores.valor,
        colorFn: (DividasValores dividasValores,_)=>dividasValores.color,
        id: "Dividas",
        data: dataValores,
        labelAccessorFn: (DividasValores dividasValores,_)=> '${dividasValores.tipo} : ${dividasValores.valor.toString()}'
      )
    ];



    var chart = charts.BarChart(
      series,

    );

    var chart2 = charts.PieChart(
      seriesDividas,
      defaultRenderer: charts.ArcRendererConfig(
        arcRendererDecorators: [charts.ArcLabelDecorator()]
      ),
      animate: true,
    );



    return Scaffold(
      appBar: AppBar(title: Text("Gráficos", textAlign: TextAlign.center,),),
      body: Column(
        children: <Widget>[
          SizedBox(height: 200, child: chart,),
          SizedBox(height: 200, child: chart2,),
          Text("Valor total: " + (somaPagas + somaNaoPagas).toString(), style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold),),
          Text("Pago: " + somaPagas.toString(),style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold, color: Colors.lightGreen[700])),
          Text("Inadimplente: "+ somaNaoPagas.toString(),style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold, color: Colors.redAccent[700]))
        ],
      )
    );
  }
}

class Dividas {
  final String tipo;
  final int quantidade;
  common.Color color;

  Dividas(this.quantidade, this.tipo, this.color);

}

class DividasValores{
  final String tipo;
  final double valor;
  common.Color color;

  DividasValores(this.valor ,this.tipo, this.color);
}


