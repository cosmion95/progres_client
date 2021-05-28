import 'package:flutter/material.dart';
import '../models/client.dart';
import '../models/rezervare.dart';

class TrimitereAnulareRezervare extends StatefulWidget {
  TrimitereAnulareRezervare(
    this.rezervare,
    this.client,
    this.mesaj,
    this.authToken,
  );
  final Rezervare rezervare;
  final Client client;
  final String mesaj;
  final String authToken;

  @override
  TrimitereAnulareRezervareState createState() =>
      TrimitereAnulareRezervareState();
}

class TrimitereAnulareRezervareState extends State<TrimitereAnulareRezervare> {
  Future<bool> anulareRezervare2() async {
    bool result = await anulareRezervare(
        widget.rezervare, widget.client, widget.mesaj, widget.authToken);
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
            future: anulareRezervare2(),
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
                        Text("Rezervare anulata cu succes."),
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
