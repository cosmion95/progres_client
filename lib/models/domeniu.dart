import 'package:http/http.dart';
import 'dart:convert';

class Domeniu {
  final int id;
  final String denumire;

  Domeniu({required this.id, required this.denumire});

  factory Domeniu.fromJson(Map<String, dynamic> json) {
    return Domeniu(id: json['id'], denumire: json['denumire']);
  }
}

Future<List<Domeniu>> getDomenii(String authToken) async {
  final response = await get(Uri.http('10.0.2.2:8000',
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
