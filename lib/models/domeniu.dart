import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/io_client.dart';

class Domeniu {
  final int id;
  final String denumire;
  final Icon icon;

  Domeniu({required this.id, required this.denumire, required this.icon});

  factory Domeniu.fromJson(Map<String, dynamic> json) {
    return Domeniu(
        id: json['id'],
        denumire: json['denumire'],
        icon: Icon(IconData(json['icon_id'], fontFamily: json['font_family'])));
  }
}

Future<List<Domeniu>> getDomenii(String authToken) async {
  HttpClient client = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
  var ioClient = new IOClient(client);

  final response = await ioClient.get(Uri.https('10.0.2.2:8000',
      '/rest_api/nomenclatoare/get_domenii/' + authToken + "/"));

  if (response.statusCode == 200) {
    String jsonString = response.body.substring(1, response.body.length - 1);
    jsonString = jsonString.replaceAll("\\", "");
    List<dynamic> jsonList = jsonDecode(jsonString);
    List<Domeniu> domenii = [];
    for (int i = 0; i < jsonList.length; i++) {
      Domeniu domeniu = Domeniu.fromJson(jsonList[i]);
      domenii.add(domeniu);
    }
    return domenii;
  } else {
    throw Exception('Eroare la incarcarea domeniilor');
  }
}
