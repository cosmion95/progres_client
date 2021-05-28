import 'package:demo_login_app/widget/anulare_rezervare_dialog.dart';

import '../models/punct_lucru.dart';
import 'package:flutter/material.dart';
import '../models/client.dart';
import '../models/rezervare.dart';

class DetaliiRezervareDialog extends StatefulWidget {
  DetaliiRezervareDialog(this.punctLucru, this.client, this.rezervareId,
      this.backgroundColor, this.authToken);
  final PunctLucru punctLucru;
  final Client client;
  final String authToken;
  final int rezervareId;
  final Color backgroundColor;

  @override
  DetaliiRezervareDialogState createState() => DetaliiRezervareDialogState();
}

class DetaliiRezervareDialogState extends State<DetaliiRezervareDialog> {
  Future<Rezervare> getDetalii() async {
    Rezervare result =
        await getDetaliiRezervare(widget.rezervareId, widget.authToken);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(230, widget.backgroundColor.red,
          widget.backgroundColor.green, widget.backgroundColor.blue),
      title: Text('Detalii rezervare'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder<Rezervare>(
            future: getDetalii(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return Column(children: [
                  Text(
                    "Eroare: " + snapshot.error.toString(),
                    style: TextStyle(color: Colors.red),
                  ),
                ]);
              }
              return snapshot.hasData
                  ? Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
                      child: Column(children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Data: " +
                                snapshot.data!.dataOra.day.toString() +
                                "." +
                                snapshot.data!.dataOra.month.toString() +
                                '.' +
                                snapshot.data!.dataOra.year.toString())),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Ora: " +
                                snapshot.data!.dataOra.hour.toString() +
                                ":" +
                                snapshot.data!.dataOra.minute.toString())),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Mesaj: " + snapshot.data!.mesaj!)),
                        snapshot.data!.tip != null
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    "Tip: " + snapshot.data!.tip!.denumire))
                            : SizedBox.shrink(),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Durata: " +
                                snapshot.data!.durata!.toString() +
                                " min")),
                        snapshot.data!.validata
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Validata: " + "da"))
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Validata: " + "nu")),
                        snapshot.data!.validata
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Validata la: " +
                                    snapshot.data!.validataLa!.day.toString() +
                                    "." +
                                    snapshot.data!.validataLa!.month
                                        .toString() +
                                    '.' +
                                    snapshot.data!.validataLa!.year.toString() +
                                    ' ' +
                                    snapshot.data!.validataLa!.hour.toString() +
                                    ':' +
                                    snapshot.data!.validataLa!.minute
                                        .toString()))
                            : SizedBox.shrink(),
                        snapshot.data!.anulata
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Anulata: " + "da"))
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Anulata: " + "nu")),
                        snapshot.data!.anulata
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Motiv anulare: " +
                                    snapshot.data!.motivAnulare!))
                            : SizedBox.shrink(),
                        snapshot.data!.anulata
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Anulata la: " +
                                    snapshot.data!.anulataLa!.day.toString() +
                                    "." +
                                    snapshot.data!.anulataLa!.month.toString() +
                                    '.' +
                                    snapshot.data!.anulataLa!.year.toString() +
                                    ' ' +
                                    snapshot.data!.anulataLa!.hour.toString() +
                                    ':' +
                                    snapshot.data!.anulataLa!.minute
                                        .toString()))
                            : SizedBox.shrink(),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Creata la: " +
                                snapshot.data!.creataLa.day.toString() +
                                "." +
                                snapshot.data!.creataLa.month.toString() +
                                '.' +
                                snapshot.data!.creataLa.year.toString() +
                                ' ' +
                                snapshot.data!.creataLa.hour.toString() +
                                ':' +
                                snapshot.data!.creataLa.minute.toString())),
                        !snapshot.data!.anulata &&
                                snapshot.data!.dataOra.isAfter(DateTime.now())
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red),
                                  onPressed: () {
                                    showDialog<String>(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AnulareRezervareDialog(snapshot.data!,
                                              widget.client, widget.authToken),
                                    );
                                    // .then((value) =>
                                    //     {Navigator.pop(context, 'ok')});
                                  },
                                  child: Text('Anulare'),
                                ),
                              )
                            : SizedBox.shrink(),
                      ]))
                  : Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
                      child: Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ));
            },
          )
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context, 'ok'),
          child: const Text('OK'),
        )
      ],
    );
  }
}
