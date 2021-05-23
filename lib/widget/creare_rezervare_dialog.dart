import 'package:demo_login_app/models/punct_lucru.dart';
import 'package:flutter/material.dart';
import '../models/punct_lucru.dart';
import '../models/client.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../models/tip_rezervare.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';

class CreareRezervareDialog extends StatefulWidget {
  CreareRezervareDialog(
      this.punctLucru, this.client, this.authToken, this.ziAleasa);
  final PunctLucru punctLucru;
  final Client client;
  final String authToken;
  final DateTime ziAleasa;

  @override
  CreareRezervareDialogState createState() => CreareRezervareDialogState();
}

class CreareRezervareDialogState extends State<CreareRezervareDialog> {
  TipRezervare? tipRezervareAles;
  bool ziValida = true;
  String mesaj = "";

  TextEditingController mesajController = new TextEditingController();

  DateTime? ziModificata;
  String formatTimp(String s) {
    if (s.length < 2) {
      return "0" + s;
    } else {
      return s;
    }
  }

  void resetZi() {
    ziModificata = widget.ziAleasa;
  }

  Future<void> verificaTimp() async {
    Map<String, dynamic> result = await verificareTimpAles(
        widget.punctLucru, ziModificata!, tipRezervareAles, widget.authToken);
    ziValida = result['accepted'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (ziModificata == null) {
      ziModificata = widget.ziAleasa;
    }
    String dataAsText = formatTimp(ziModificata!.day.toString()) +
        "." +
        formatTimp(ziModificata!.month.toString()) +
        "." +
        ziModificata!.year.toString();
    return AlertDialog(
      title: Text('Creare rezervare in data ' + dataAsText),
      content: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text("Ora: " +
                      formatTimp(ziModificata!.hour.toString()) +
                      ":" +
                      formatTimp(ziModificata!.minute.toString()))),
              TextButton(
                  onPressed: () {
                    DatePicker.showTimePicker(context,
                        showTitleActions: true,
                        showSecondsColumn: false, onConfirm: (date) {
                      ziModificata = date;
                      verificaTimp();
                    }, currentTime: ziModificata);
                  },
                  child: Icon(Icons.edit))
            ],
          ),
          FutureBuilder<List<TipRezervare>>(
            future: getTipuriRezervare(widget.punctLucru, widget.authToken),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return Text("Eroare la incarcarea tipurilor de rezervare.");
              }
              return snapshot.hasData
                  ? Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                      child: Container(
                        child: DropdownSearch<TipRezervare>(
                          mode: Mode.DIALOG,
                          //showSelectedItem: true,
                          items: snapshot.data,
                          label: "Tip rezervare",
                          showClearButton: true,
                          dropdownBuilder: _customDropDownExample,
                          popupItemBuilder: _customPopupItemBuilderExample2,
                          onChanged: (TipRezervare? tip) {
                            if (tip == null) {
                              tipRezervareAles = null;
                            } else {
                              tipRezervareAles = tip;
                            }
                            verificaTimp();
                          },
                        ),
                      ))
                  : Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
                      child: Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ));
            },
          ),
          Text(
            ziValida
                ? ""
                : "Ora aleasa este invalida pentru acest tip de rezervare. Alegeti alta ora sau schimbati tipul rezervarii.",
            style: TextStyle(color: Colors.red),
          ),
          TextFormField(
            controller: mesajController,
            decoration: InputDecoration(
              hintText: "Mesaj",
              border: OutlineInputBorder(),
            ),
            inputFormatters: [
              new LengthLimitingTextInputFormatter(256),
            ],
          ),
          Text(
            tipRezervareAles == null || mesaj.length < 1
                ? "Inainte de trimitere completati mesajul sau alegeti un tip de rezervare."
                : "",
            style: TextStyle(color: Colors.amber),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
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
