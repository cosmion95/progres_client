import 'package:http/http.dart';
import 'dart:convert';

class Judet {
  final int id;
  final String denumire;
  final String prescurtare;

  Judet({required this.id, required this.denumire, required this.prescurtare});

  factory Judet.fromJson(Map<String, dynamic> json) {
    return Judet(
      id: json['id'],
      denumire: json['denumire'],
      prescurtare: json['prescurtare'],
    );
  }
}

Future<List<Judet>> getJudete() async {
  final response = await get(
      Uri.http('10.0.2.2:8000', '/rest_api/nomenclatoare/get_judete'));

  if (response.statusCode == 200) {
    String jsonString = response.body.substring(1, response.body.length - 1);
    jsonString = jsonString.replaceAll("\\", "");
    List<dynamic> jsonList = jsonDecode(jsonString);
    List<Judet> judete = [];
    for (int i = 0; i < jsonList.length; i++) {
      Judet judet = Judet.fromJson(jsonList[i]);
      judete.add(judet);
    }
    return judete;
  } else {
    throw Exception('Eroare la incarcarea judetelor');
  }
}
