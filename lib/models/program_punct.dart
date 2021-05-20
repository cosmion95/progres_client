import 'package:demo_login_app/models/punct_lucru.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class ProgramPunct {
  final DateTime data;
  final String oraStart;
  final String oraFinal;
  ProgramPunct(
      {required this.data, required this.oraStart, required this.oraFinal});

  factory ProgramPunct.fromJson(Map<String, dynamic> json) {
    DateTime tempDate =
        new DateFormat("dd.MM.yyyy", 'en_US').parse(json['data']);
    int counter = 0;
    String oraStartFormatat = "";
    String oraFinalFormatat = "";
    if (json['ora_start'].contains(".")) {
      for (String x in json['ora_start'].split(".")) {
        if (counter == 0) {
          if (x.length < 2) {
            oraStartFormatat = "0" + x + ":";
          } else {
            oraStartFormatat = x + ":";
          }
        }
        if (counter == 1) {
          if (x.length < 2) {
            oraStartFormatat = oraStartFormatat + x + "0";
          } else {
            oraStartFormatat = oraStartFormatat + x;
          }
        }

        counter += 1;
      }
    } else {
      if (json['ora_start'].length < 2) {
        oraStartFormatat = "0" + json['ora_start'] + ":00";
      } else {
        oraStartFormatat = json['ora_start'] + ":00";
      }
    }
    counter = 0;
    if (json['ora_final'].contains(".")) {
      for (String x in json['ora_final'].split(".")) {
        if (counter == 0) {
          if (x.length < 2) {
            oraFinalFormatat = "0" + x + ":";
          } else {
            oraFinalFormatat = x + ":";
          }
        }
        if (counter == 1) {
          if (x.length < 2) {
            oraFinalFormatat = oraFinalFormatat + x + "0";
          } else {
            oraFinalFormatat = oraFinalFormatat + x;
          }
        }

        counter += 1;
      }
    } else {
      if (json['ora_final'].length < 2) {
        oraFinalFormatat = "0" + json['ora_final'] + ":00";
      } else {
        oraFinalFormatat = json['ora_final'] + ":00";
      }
    }
    return ProgramPunct(
        data: tempDate, oraStart: oraStartFormatat, oraFinal: oraFinalFormatat);
  }
}

Future<List<ProgramPunct>> getProgramPunct(
    PunctLucru punct, String authToken) async {
  final uri = "http://10.0.2.2:8000/rest_api/terti/get_program_punct/" +
      authToken +
      "/";
  final headers = {'Content-Type': 'application/json'};

  Map<String, dynamic> body = {'punct': punct.id};

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
    List<ProgramPunct> zilePunct = [];
    for (int i = 0; i < jsonList.length; i++) {
      ProgramPunct ziPunct = ProgramPunct.fromJson(jsonList[i]);
      zilePunct.add(ziPunct);
    }
    return zilePunct;
  } else {
    throw jsonDecode(response.body)['error'];
  }
}

Future<DateTime> getUrmatoareaZiLucratoare(
    PunctLucru punct, String authToken) async {
  final uri =
      "http://10.0.2.2:8000/rest_api/terti/get_urmatoarea_zi_lucratoare/" +
          authToken +
          "/";
  final headers = {'Content-Type': 'application/json'};

  Map<String, dynamic> body = {'punct': punct.id};

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
    return new DateFormat("dd.MM.yyyy", 'en_US')
        .parse(jsonDecode(jsonString)['data']);
  } else {
    throw jsonDecode(response.body)['error'];
  }
}

Future<int> getProcentOcupare(
    PunctLucru punctLucru, DateTime data, String authToken) async {
  final uri = "http://10.0.2.2:8000/rest_api/terti/get_procent_ocupare/" +
      authToken +
      "/";
  final headers = {'Content-Type': 'application/json'};

  Map<String, dynamic> body = {
    'punct': punctLucru.id,
    'data': data.day.toString() +
        "." +
        data.month.toString() +
        "." +
        data.year.toString()
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
    return int.parse(jsonDecode(jsonString)['procent']);
  } else {
    throw jsonDecode(response.body)['error'];
  }
}
