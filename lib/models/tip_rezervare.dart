import 'package:http/http.dart';
import 'dart:convert';
import '../models/punct_lucru.dart';

class TipRezervare {
  final int id;
  final String denumire;
  final int durata;

  TipRezervare(
      {required this.id, required this.denumire, required this.durata});

  factory TipRezervare.fromJson(Map<String, dynamic> json) {
    return TipRezervare(
        id: json['id'], denumire: json['denumire'], durata: json['durata']);
  }
}

Future<List<TipRezervare>> getTipuriRezervare(
    PunctLucru punctLucru, String authToken) async {
  final uri = "http://10.0.2.2:8000/rest_api/tert/get_tipuri_rezervare/" +
      authToken +
      "/";
  final headers = {'Content-Type': 'application/json'};

  Map<String, dynamic> body = {'punct': punctLucru.id};

  String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await post(
    Uri.parse(uri),
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  );

  if (response.statusCode == 200) {
    String jsonString = response.body.substring(1, response.body.length - 1);
    jsonString = jsonString.replaceAll("\\", "");
    List<dynamic> jsonList = jsonDecode(jsonString);
    List<TipRezervare> tipuriRezervare = [];
    for (int i = 0; i < jsonList.length; i++) {
      TipRezervare tipRezervare = TipRezervare.fromJson(jsonList[i]);
      tipuriRezervare.add(tipRezervare);
    }
    return tipuriRezervare;
  } else {
    throw Exception('Eroare la incarcarea tipurilor de rezervare');
  }
}
