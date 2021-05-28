import 'package:demo_login_app/widget/trimitere_anulare_rezervare.dart';
import 'package:flutter/material.dart';
import '../models/client.dart';
import '../models/tip_rezervare.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/rezervare.dart';

class AnulareRezervareDialog extends StatefulWidget {
  AnulareRezervareDialog(this.rezervare, this.client, this.authToken);
  final Rezervare rezervare;
  final Client client;
  final String authToken;

  @override
  AnulareRezervareDialogState createState() => AnulareRezervareDialogState();
}

class AnulareRezervareDialogState extends State<AnulareRezervareDialog> {
  String mesaj = "";
  bool mesajValid = false;

  TextEditingController mesajController = new TextEditingController();

  bool checkMesaj(String msg) {
    if (msg.length < 10) {
      mesajValid = false;
      return false;
    }
    mesajValid = true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Anulare rezervare'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: mesajController,
            autovalidateMode: AutovalidateMode.always,
            validator: (value) =>
                checkMesaj(value!) ? null : "Motivul este obligatoriu.",
            decoration: InputDecoration(
              hintText: "Motiv anulare",
              border: OutlineInputBorder(),
            ),
            inputFormatters: [
              new LengthLimitingTextInputFormatter(256),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'cancel'),
          child: const Text('Renunta'),
        ),
        TextButton(
          onPressed: () {
            if (!mesajValid) {
              Fluttertoast.showToast(
                  msg: "Mesajul este obligatoriu",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              showDialog<String>(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => TrimitereAnulareRezervare(
                    widget.rezervare,
                    widget.client,
                    mesajController.text,
                    widget.authToken),
              ).then((value) => {Navigator.pop(context, 'ok')});
            }
          },
          child: const Text('Anulare'),
        ),
      ],
    );
  }
}

Widget _customDropDownExample(
    BuildContext context, TipRezervare? item, String itemDesignation) {
  if (item == null) {
    return Container(
      child: Text("Neselectat"),
    );
  }
  return Container(
    child: ListTile(
      title: Text(item.denumire),
    ),
  );
}

Widget _customPopupItemBuilderExample2(
    BuildContext context, TipRezervare item, bool isSelected) {
  return Container(
    child: ListTile(
      selected: isSelected,
      title:
          Text(item.denumire + " - durata: " + item.durata.toString() + " min"),
    ),
  );
}
