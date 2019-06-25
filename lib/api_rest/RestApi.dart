import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:teste_api_cobranca/models/Usuario.dart';
import 'package:teste_api_cobranca/models/divida.dart';

class RestApi {
  static final BASE_URL = "http://10.0.2.2/getdata.php";
  static final GET_ATRASADA = "http://10.0.2.2/getdataatrasada.php";
  static final GET_DODIA = "http://10.0.2.2/getdatavctodia.php";
  static final GET_CLIENTES= "http://10.0.2.2/getUsuarios.php";


  Future<List<Divida>> todasAsDividas() async {
    List<Divida> listDivida = [];
    try {
      http.Response response = await http.get(BASE_URL);
      var jsonData = json.decode(response.body);
      print(jsonData.toString());

      for (var u in jsonData) {
        listDivida.add(new Divida.fromJson(u));
      }

      print("TODAS AS DIVIDAS");
      print(listDivida.toString());
      return listDivida;
    } on Exception catch (_) {}
  }

  Future<List<Divida>> todasAsDividasAtrasadas() async {
    List<Divida> listDivida = [];
    try {
      http.Response response = await http.get('http://10.0.2.2/getatrasadas.php');
      var jsonData = json.decode(response.body);
      print(jsonData.toString());

      for (var u in jsonData) {
        listDivida.add(new Divida.fromJson(u));
      }

      print("TODAS AS DIVIDAS ATRASADAS");
      print(listDivida.toString());
      return listDivida;
    } on Exception catch (_) {}
  }

  Future<List<Divida>> todasAsDividasPagas() async {
    List<Divida> listDivida = [];
    try {
      http.Response response = await http.get('http://10.0.2.2/getPagas.php');
      var jsonData = json.decode(response.body);
      print(jsonData.toString());

      for (var u in jsonData) {
        listDivida.add(new Divida.fromJson(u));
      }

      print("TODAS AS DIVIDAS ATRASADAS");
      print(listDivida.toString());
      return listDivida;
    } on Exception catch (_) {}
  }

  Future<List<Usuario>> todosOsClientes() async {
    List<Usuario> todosOsClientes = [];
    try {
      http.Response response = await http.get(GET_CLIENTES);
      var jsonData = json.decode(response.body);
      print(jsonData.toString());

      for (var u in jsonData) {
        todosOsClientes.add(new Usuario.fromJson(u));
      }

      print(todosOsClientes.toString());
      return todosOsClientes;
    } on Exception catch (_) {}
  }

  Future<List<Divida>> dividasAtrasadas(String user) async {
    List<Divida> listDividaAtrasadas = [];
    http.Response response = await http.post(
        'http://10.0.2.2/getdataatrasada.php', body: {
        "user": user,
    });

    var jsonData = json.decode(response.body);
    print(jsonData.toString());

    for (var u in jsonData) {
      listDividaAtrasadas.add(new Divida.fromJson(u));
    }

    print(jsonData.toString());

    if(jsonData.length==0){
      print("Relatórios mil grau");
    } else {
      print("Parabéns relatórios funidonando");
    }

    return listDividaAtrasadas;
  }

  Future<List<Divida>> vencimentoNoDia() async {
    List<Divida> vencimentoNoDia = [];
    try {
      http.Response response = await http.get(GET_DODIA);
      var jsonData = json.decode(response.body);
      print(jsonData.toString());

      for (var u in jsonData) {
        vencimentoNoDia.add(new Divida.fromJson(u));
      }

      print("Vencimento no dia");
      return vencimentoNoDia;

    } on Exception catch (_) {}
  }

  Future<List<Usuario>> login(String user, String senha) async {
    List<Usuario> usuarioLogado = [];
    http.Response response = await http.post('http://10.0.2.2/login.php', body: {
      "user": user,
      "senha": senha,
    });

    var jsonData = json.decode(response.body);
    print(jsonData.toString());

    for (var u in jsonData) {
      usuarioLogado.add(new Usuario.fromJson(u));
    }

    print(jsonData.toString());

    if(jsonData.length==0){
      print("Login errado");
    } else {
      print("login ok");
    }

    return usuarioLogado;
  }


  Future<List<Divida>> getAllCliente(String user) async {
    List<Divida> dividasUsuario = [];
      print("entrei nesse if locasso");
      http.Response response = await http.post(
          'http://10.0.2.2/getAllCliente.php', body: {
        "user": user,
      });
      var jsonData = json.decode(response.body);
      print(jsonData.toString());

      for (var u in jsonData) {
        dividasUsuario.add(new Divida.fromJson(u));
      }

      print(jsonData.toString());

      if (jsonData.length == 0) {
        print("Relatórios mil grau");
      } else {
        print("Parabéns relatórios funidonando");
      }

      return dividasUsuario;
    }

  Future<List<Divida>> relatorio(String user, String data1, String data2) async {
    List<Divida> usuarioLogado = [];
    print("USUARIO DENTRO DAAPI: " + user);
    if(user != "") {
      print("entrei nesse if locasso");
      http.Response response = await http.post(
          'http://10.0.2.2/relatorio.php', body: {
        "user": user,
        "data1": data1,
        "data2": data2,
      });
      var jsonData = json.decode(response.body);
      print(jsonData.toString());

      for (var u in jsonData) {
        usuarioLogado.add(new Divida.fromJson(u));
      }

      print(jsonData.toString());

      if(jsonData.length==0){
        print("Relatórios mil grau");
      } else {
        print("Parabéns relatórios funidonando");
      }

      return usuarioLogado;
    } else {
      http.Response response = await http.post(
          'http://10.0.2.2/relatorioSemCliente.php', body: {
        "data1": data1,
        "data2": data2,
      });
      var jsonData = json.decode(response.body);
      print(jsonData.toString());

      for (var u in jsonData) {
        usuarioLogado.add(new Divida.fromJson(u));
      }

      print(jsonData.toString());

      if(jsonData.length==0){
        print("Relatórios mil grau");
      } else {
        print("Parabéns relatórios funidonando");
      }

      return usuarioLogado;
    }


  }
}