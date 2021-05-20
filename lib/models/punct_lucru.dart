import 'package:http/http.dart';
import 'dart:convert';
import 'localitate.dart';
import 'domeniu.dart';
import 'package:flutter/material.dart';

class PunctLucru {
  final int id;
  final String denumire;
  final String telefon;
  final String strada;
  final String nrStrada;
  final int zileRezervariMax;
  final Localitate? localitate;
  final Domeniu? domeniu;

  PunctLucru(
      {required this.id,
      required this.denumire,
      required this.telefon,
      required this.strada,
      required this.nrStrada,
      required this.zileRezervariMax,
      required this.localitate,
      required this.domeniu});

  factory PunctLucru.fromJson(
      Map<String, dynamic> json, Localitate? localitate, Domeniu? domeniu) {
    return PunctLucru(
        id: json['id'],
        denumire: json['denumire'],
        telefon: json['telefon'],
        strada: json['strada'],
        nrStrada: json['nr_strada'],
        zileRezervariMax: json['zile_rezervari_max'],
        localitate: localitate,
        domeniu: domeniu);
  }
}

Future<List<PunctLucru>> getPuncteLucru(Localitate? localitate,
    Domeniu? domeniu, String cuvantCheie, String authToken) async {
  final uri =
      "http://10.0.2.2:8000/rest_api/terti/get_puncte_lucru/" + authToken + "/";
  final headers = {'Content-Type': 'application/json'};

  Map<String, dynamic> body = {
    'localitate': localitate?.id,
    'domeniu': domeniu?.id,
    'cuvinte': cuvantCheie
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
    String jsonString = response.body.substring(1, response.body.length - 1);
    jsonString = jsonString.replaceAll("\\", "");
    List<dynamic> jsonList = jsonDecode(jsonString);
    List<PunctLucru> puncte = [];
    for (int i = 0; i < jsonList.length; i++) {
      Domeniu dom = new Domeniu(
          id: jsonList[i]['dom_id'],
          denumire: jsonList[i]['dom_denumire'],
          icon: Icon(IconData(jsonList[i]['dom_icon_id'],
              fontFamily: jsonList[i]['dom_font_family'])));
      PunctLucru punct = PunctLucru.fromJson(jsonList[i], localitate, dom);
      puncte.add(punct);
    }
    return puncte;
  } else {
    throw jsonDecode(response.body)['error'];
  }
}
