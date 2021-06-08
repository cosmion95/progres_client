import 'package:http/http.dart';
import 'dart:convert';
import 'judet.dart';
import 'dart:io';
import 'package:http/io_client.dart';

class Localitate {
  final int id;
  final String denumire;
  final Judet judet;

  Localitate({required this.id, required this.denumire, required this.judet});

  factory Localitate.fromJson(Map<String, dynamic> json, Judet judet) {
    return Localitate(
      id: json['id'],
      denumire: json['denumire'],
      judet: judet,
    );
  }
}

Future<List<Localitate>> getLocalitati(Judet? judet) async {
  if (judet == null) {
    return [];
  }

  final uri = 'https://10.0.2.2:8000/rest_api/nomenclatoare/get_localitati/';
  final headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> body = {'judet': judet.id};
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

  if (response.statusCode == 200) {
    String jsonString = response.body.substring(1, response.body.length - 1);
    jsonString = jsonString.replaceAll("\\", "");
    List<dynamic> jsonList = jsonDecode(jsonString);
    List<Localitate> localitati = [];
    for (int i = 0; i < jsonList.length; i++) {
      Localitate loc = Localitate.fromJson(jsonList[i], judet);
      localitati.add(loc);
    }
    return localitati;
  } else {
    print(response.body);
    throw Exception('Eroare la incarcarea localitatilor');
  }
}
