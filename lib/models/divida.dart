class Divida{
  String id;
  String id_user;
  String nome;
  String id_compra;
  String valor;
  String parcela;
  String data_vcto;
  String pago;

  Divida({this.id, this.id_user, this.nome, this.id_compra, this.valor, this.parcela, this.data_vcto, this.pago});

  factory Divida.fromJson(Map<String, dynamic> parsedJson) {
    return Divida(
        id: parsedJson["id"] as String,
        id_user: parsedJson["id_user"] as String,
        nome: parsedJson["nome"] as String,
        id_compra: parsedJson["id_compra"] as String,
        valor: parsedJson["valor"] as String,
        parcela: parsedJson["parcela"] as String,
        data_vcto: parsedJson["data_vcto"] as String,
        pago: parsedJson["pago"] as String
    );
  }


}