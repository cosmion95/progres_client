import '../models/punct_lucru.dart';
import 'package:flutter/material.dart';
import '../models/client.dart';
import '../models/tip_rezervare.dart';

class TrimitereRezervareDialog extends StatefulWidget {
  TrimitereRezervareDialog(this.punctLucru, this.client, this.authToken,
      this.ziAleasa, this.tipRezervare, this.mesaj);
  final PunctLucru punctLucru;
  final Client client;
  final String authToken;
  final DateTime ziAleasa;
  final TipRezervare? tipRezervare;
  final String mesaj;

  @override
  TrimitereRezervareDialogState createState() =>
      TrimitereRezervareDialogState();
}

class TrimitereRezervareDialogState extends State<TrimitereRezervareDialog> {
  Future<bool> inregistrareRezervare() async {
    bool result = await inregistrareCerereRezervare(
        widget.client,
        widget.punctLucru,
        widget.ziAleasa,
        widget.tipRezervare,
        widget.mesaj,
        widget.authToken);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Procesare...'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder<void>(
            future: inregistrareRezervare(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return Column(children: [
                  Text(
                    snapshot.error.toString(),
                    style: TextStyle(color: Colors.red),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'ok'),
                    child: const Text('OK'),
                  ),
                ]);
              }
              return snapshot.hasData
                  ? Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
                      child: Column(children: [
                        Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 50,
                          ),
                        ),
                        Text("Cererea de rezervare a fost creata cu succes."),
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'ok'),
                          child: const Text('OK'),
                        ),
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
    );
  }
}
