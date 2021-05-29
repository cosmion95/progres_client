import 'package:demo_login_app/models/punct_lucru.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'client.dart' as clientAplicatie;

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
  final uri =
      "http://10.0.2.2:8000/rest_api/tert/get_program_punct/" + authToken + "/";
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
      "http://10.0.2.2:8000/rest_api/tert/get_urmatoarea_zi_lucratoare/" +
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
  final uri = "http://10.0.2.2:8000/rest_api/tert/get_procent_ocupare/" +
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

Future<List<Appointment>> getProgramNeeligibil(
    clientAplicatie.Client client, PunctLucru punct, String authToken) async {
  final uri = "http://10.0.2.2:8000/rest_api/tert/get_program_neeligibil/" +
      authToken +
      "/";
  final headers = {'Content-Type': 'application/json'};

  Map<String, dynamic> body = {'punct': punct.id, 'client': client.id};

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
    List<Appointment> appointments = [];
    for (int i = 0; i < jsonList.length; i++) {
      Map<String, dynamic> jsonMap = jsonList[i];
      DateTime tempDate =
          new DateFormat("dd.MM.yyyy", 'en_US').parse(jsonMap['data']);

      dynamic ora = jsonMap['ora_start'];
      dynamic min = (jsonMap['ora_start'] - ora.floor()) * 100;

      //nu ii place ora 00:00:00
      if (min.toInt() == 0) {
        min = 1;
      }

      DateTime start = DateTime(tempDate.year, tempDate.month, tempDate.day,
          ora.toInt(), min.toInt(), 0);

      ora = jsonMap['ora_final'];
      min = (jsonMap['ora_final'] - ora.floor()) * 100;

      DateTime end = DateTime(tempDate.year, tempDate.month, tempDate.day,
          ora.toInt(), min.toInt(), 0);

      Color color = Colors.blue;
      String? notes;

      switch (jsonMap['tip']) {
        case "pauza_out":
          color = Colors.grey;
          break;
        case "zi_nelucratoare":
          color = Colors.grey;
          break;
        case "pauza_in":
          color = Colors.blueGrey;
          break;
        case "proprie_trimisa":
          color = Colors.yellow;
          notes = jsonMap['rezervare_id'].toString();
          break;
        case "proprie_anulata":
          color = Colors.red;
          notes = jsonMap['rezervare_id'].toString();
          break;
        case "proprie_validata":
          color = Colors.green;
          notes = jsonMap['rezervare_id'].toString();
          break;
      }

      Appointment appointment = new Appointment(
          startTime: start,
          endTime: end,
          color: color,
          notes: notes,
          subject: jsonMap['subiect']);
      appointments.add(appointment);
    }
    return appointments;
  } else {
    throw jsonDecode(response.body)['error'];
  }
}
