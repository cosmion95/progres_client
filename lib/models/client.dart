import 'package:demo_login_app/models/judet.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'localitate.dart';
import 'dart:io';
import 'package:http/io_client.dart';

class Client {
  final int id;
  final String nume;
  final String prenume;
  final String email;
  final String telefon;
  final Localitate? localitate;
  final int rataPrezenta;

  Client(
      {required this.id,
      required this.nume,
      required this.prenume,
      required this.email,
      required this.telefon,
      required this.localitate,
      required this.rataPrezenta});

  factory Client.fromJson(Map<String, dynamic> json, Localitate localitate) {
    return Client(
        id: json['id'],
        nume: json['nume'],
        prenume: json['prenume'],
        email: json['email'],
        telefon: json['telefon'],
        rataPrezenta: json['rataPrezenta'],
        localitate: localitate);
  }
}

Future<Map<String, dynamic>> registerClient(
    String nume,
    String prenume,
    String email,
    String parola,
    String salt,
    String telefon,
    Localitate? localitate) async {
  HttpClient client = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
  var ioClient = new IOClient(client);

  final uri = 'https://10.0.2.2:8000/rest_api/client/register_client/';
  final headers = {'Content-Type': 'application/json'};

  Map<String, dynamic> body = {
    'nume': nume,
    'prenume': prenume,
    'email': email,
    'parola': parola,
    'salt': salt,
    'telefon': telefon,
    'localitate': localitate?.id
  };

  String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await ioClient.post(
    Uri.parse(uri),
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  );

  if (response.statusCode == 201) {
    return jsonDecode(response.body);
  } else {
    throw jsonDecode(response.body)['error'];
  }
}

Future<void> verificaCodInregistrare(
    String clientEmail, String codInregistrare, String authToken) async {
  final uri = 'https://10.0.2.2:8000/rest_api/client/validare_cont_client/' +
      authToken +
      '/';
  final headers = {'Content-Type': 'application/json'};

  Map<String, dynamic> body = {
    'client_email': clientEmail,
    'token': codInregistrare
  };

  String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  HttpClient client = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
  var ioClient = new IOClient(client);

  Response response = await ioClient.post(
    Uri.parse(uri),
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  );

  if (response.statusCode != 200) {
    throw jsonDecode(response.body)['error'];
  }
}

Future<void> retrimiteCodInregistrare(
    String clientEmail, String authToken) async {
  final uri =
      'https://10.0.2.2:8000/rest_api/client/generare_cod_inregistrare/' +
          authToken +
          '/';
  final headers = {'Content-Type': 'application/json'};

  Map<String, dynamic> body = {'email': clientEmail};

  String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  HttpClient client = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
  var ioClient = new IOClient(client);

  Response response = await ioClient.post(
    Uri.parse(uri),
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  );

  if (response.statusCode != 201) {
    throw jsonDecode(response.body)['error'];
  }
}

Future<Map<String, dynamic>> login(String email, String pass) async {
  HttpClient client = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
  var ioClient = new IOClient(client);

  final uri = 'https://10.0.2.2:8000/rest_api/client/login/';
  final headers = {'Content-Type': 'application/json'};

  Map<String, dynamic> body = {'email': email, 'pass': pass};

  String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await ioClient.post(
    Uri.parse(uri),
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw jsonDecode(response.body)['error'];
  }
}

Future<void> verificaCodLogin(
    String clientEmail, String codInregistrare, String authToken) async {
  final uri =
      'https://10.0.2.2:8000/rest_api/client/validare_login/' + authToken + '/';
  final headers = {'Content-Type': 'application/json'};

  Map<String, dynamic> body = {
    'client_email': clientEmail,
    'token': codInregistrare
  };

  String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  HttpClient client = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
  var ioClient = new IOClient(client);

  Response response = await ioClient.post(
    Uri.parse(uri),
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  );

  if (response.statusCode != 200) {
    throw jsonDecode(response.body)['error'];
  }
}

Future<void> retrimiteCodLogin(String clientEmail, String authToken) async {
  final uri = 'https://10.0.2.2:8000/rest_api/client/generare_cod_login/' +
      authToken +
      '/';
  final headers = {'Content-Type': 'application/json'};

  Map<String, dynamic> body = {'email': clientEmail};

  String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  HttpClient client = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
  var ioClient = new IOClient(client);

  Response response = await ioClient.post(
    Uri.parse(uri),
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  );

  if (response.statusCode != 201) {
    throw jsonDecode(response.body)['error'];
  }
}

Future<Client> getClientFromEmail(String email, String authToken) async {
  final uri = 'https://10.0.2.2:8000/rest_api/client/get_client_from_email/' +
      authToken +
      '/';
  final headers = {'Content-Type': 'application/json'};

  Map<String, dynamic> body = {'email': email};

  String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  HttpClient client = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
  var ioClient = new IOClient(client);

  Response response = await ioClient.post(
    Uri.parse(uri),
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  );

  if (response.statusCode != 200) {
    throw jsonDecode(response.body)['error'];
  }

  String jsonString = response.body.substring(1, response.body.length - 1);
  jsonString = jsonString.replaceAll("\\", "");
  print(jsonString);

  Map<String, dynamic> clientMap = jsonDecode(jsonString);

  Judet judet = new Judet(
      id: clientMap["jud_id"],
      denumire: clientMap["jud_denumire"],
      prescurtare: clientMap["jud_prescurtare"]);

  Localitate localitate = new Localitate(
      id: clientMap["loc_id"],
      denumire: clientMap["loc_denumire"],
      judet: judet);

  Client c = new Client(
      id: clientMap["id"],
      nume: clientMap["nume"],
      prenume: clientMap["prenume"],
      email: email,
      telefon: clientMap["telefon"],
      localitate: localitate,
      rataPrezenta: clientMap["rata_prezenta"]);

  return c;
}

Future<String> getSalt(String email) async {
  HttpClient client = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
  var ioClient = new IOClient(client);

  final uri = "https://10.0.2.2:8000/rest_api/client/get_salt/";
  final headers = {'Content-Type': 'application/json'};

  Map<String, dynamic> body = {'email': email};

  String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await ioClient.post(Uri.parse(uri),
      body: jsonBody, encoding: encoding, headers: headers);

  if (response.statusCode == 200) {
    String jsonString = response.body.substring(1, response.body.length - 1);
    jsonString = jsonString.replaceAll("\\", "");
    return jsonDecode(jsonString)['salt'];
  } else {
    throw jsonDecode(response.body)['error'];
  }
}
