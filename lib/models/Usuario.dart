class Usuario{
  String id;
  String nome;
  String user;
  String senha;
  String tipo;


  Usuario({this.id, this.nome, this.user, this.senha, this.tipo});

  factory Usuario.fromJson(Map<String, dynamic> parsedJson) {
    return Usuario(
        id: parsedJson["id"] as String,
        nome: parsedJson["nome"] as String,
        user: parsedJson["user"] as String,
        senha: parsedJson["senha"] as String,
        tipo: parsedJson["tipo"] as String
    );
  }


}