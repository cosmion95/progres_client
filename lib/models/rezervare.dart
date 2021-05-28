import 'tip_rezervare.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart';
import 'dart:convert';
import '../models/client.dart' as clientAplicatie;

class Rezervare {
  final int id;
  final TipRezervare? tip;
  final DateTime dataOra;
  final bool validata;
  final bool anulata;
  final String? mesaj;
  final int? durata;
  final String? motivAnulare;
  final String? rezervareLa;

  final DateTime creataLa;
  final DateTime? validataLa;
  final DateTime? anulataLa;

  Rezervare(
      {required this.id,
      required this.tip,
      required this.dataOra,
      required this.validata,
      required this.anulata,
      required this.mesaj,
      required this.durata,
      required this.motivAnulare,
      required this.rezervareLa,
      required this.creataLa,
      required this.validataLa,
      required this.anulataLa});

  factory Rezervare.fromJson(Map<String, dynamic> json) {
    TipRezervare? tip;
    if (json['tip_id'].length > 0) {
      tip = new TipRezervare(
          id: int.parse(json['tip_id']),
          denumire: json['tip_denumire'],
          durata: int.parse(json['tip_durata']));
    }
    return Rezervare(
      id: json['id'],
      tip: tip,
      dataOra:
          new DateFormat("dd.MM.yyyy HH:mm", 'en_US').parse(json['data_ora']),
      validata: json['validata'] == 'D' ? true : false,
      anulata: json['anulata'] == 'D' ? true : false,
      mesaj: json['mesaj'],
      durata: int.parse(json['durata']),
      motivAnulare: json['motiv_anulare'],
      rezervareLa: json['rezervare_la'],
      creataLa:
          new DateFormat("dd.MM.yyyy HH:mm", 'en_US').parse(json['creata_la']),
      validataLa: json['validata'] == 'D'
          ? new DateFormat("dd.MM.yyyy HH:mm", 'en_US')
              .parse(json['validata_la'])
          : null,
      anulataLa: json['anulata'] == 'N'
          ? null
          : new DateFormat("dd.MM.yyyy HH:mm", 'en_US')
              .parse(json['anulata_la']),
    );
  }
}

Future<Rezervare> getDetaliiRezervare(int rezervareId, String authToken) async {
  final uri = "http://10.0.2.2:8000/rest_api/rezervare/get_detalii_rezervare/" +
      authToken +
      "/";
  final headers = {'Content-Type': 'application/json'};

  Map<String, dynamic> body = {'rezervare': rezervareId};

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
    return Rezervare.fromJson(jsonDecode(jsonString));
  } else {
    throw jsonDecode(response.body)['error'];
  }
}

Future<bool> anulareRezervare(Rezervare rezervare,
    clientAplicatie.Client client, String mesaj, String authToken) async {
  final uri =
      "http://10.0.2.2:8000/rest_api/rezervare/anulare_rezervare_client/" +
          authToken +
          "/";
  final headers = {'Content-Type': 'application/json'};

  Map<String, dynamic> body = {
    'rezervare': rezervare.id,
    'client': client.id,
    'mesaj': mesaj,
  };

  String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await post(
    Uri.parse(uri),
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    throw jsonDecode(response.body)['error'];
  }
}
