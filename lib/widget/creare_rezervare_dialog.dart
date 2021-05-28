import 'package:demo_login_app/widget/trimitere_rezervare_dialog.dart';

import '../models/punct_lucru.dart';
import 'package:flutter/material.dart';
import '../models/client.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../models/tip_rezervare.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  bool mesajValid = false;

  TextEditingController mesajController = new TextEditingController();

  DateTime? ziModificata;
  String formatTimp(String s) {
    if (s.length < 2) {
      return "0" + s;
    } else {
      return s;
    }
  }

  bool checkMesajAndTip(String msg) {
    if (msg.length < 10 && tipRezervareAles == null) {
      mesajValid = false;
      return false;
    }
    mesajValid = true;
    return true;
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
          Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                ziValida
                    ? ""
                    : "Perioada sau tipul ales este in conflict cu programul de lucru sau cu alte rezervari.",
                style: TextStyle(color: Colors.red, fontSize: 12),
              )),
          TextFormField(
            controller: mesajController,
            autovalidateMode: AutovalidateMode.always,
            validator: (value) => checkMesajAndTip(value!)
                ? null
                : "Mesajul sau tipul este obligatoriu.",
            decoration: InputDecoration(
              hintText: "Mesaj",
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
                  msg: "Mesajul sau tipul este obligatoriu",
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
                builder: (BuildContext context) => TrimitereRezervareDialog(
                    widget.punctLucru,
                    widget.client,
                    widget.authToken,
                    ziModificata!,
                    tipRezervareAles,
                    mesajController.text),
              ).then((value) => {Navigator.pop(context, 'ok')});
            }
          },
          child: const Text('Creare'),
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
