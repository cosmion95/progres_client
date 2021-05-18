import 'package:flutter/material.dart';
import '../models/client.dart';
import '../models/judet.dart';
import '../models/localitate.dart';
import '../models/domeniu.dart';
import '../models/punct_lucru.dart';

class HomepageCauta extends StatefulWidget {
  HomepageCauta(this.client, this.authToken);
  final Client client;
  final String authToken;

  @override
  HomepageCautaState createState() => HomepageCautaState();
}

class HomepageCautaState extends State<HomepageCauta> {
  Judet? judetAles;
  Localitate? localitateAleasa;
  Domeniu? domeniuAles;

  String denumireJudetAles = "Judet";
  String denumireLocalitateAleasa = "Localitate";
  String denumireDomeniuAles = "Domeniu";

  Future<List<Localitate>>? localitati;
  TextEditingController cuvinteCheieController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    judetAles = widget.client.localitate?.judet;
    localitateAleasa = widget.client.localitate;
    localitati = getLocalitati(judetAles);

    denumireJudetAles = judetAles!.denumire;
    denumireLocalitateAleasa = localitateAleasa!.denumire;

    return Scaffold(
        backgroundColor: Colors.lime,
        body: SafeArea(
            child: Column(
          children: [
            Container(
                color: Colors.amber,
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: cuvinteCheieController,
                      decoration: InputDecoration(
                        hintText: "Cauta",
                        border: OutlineInputBorder(),
                      ),
                    )),
                  ],
                )),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: FutureBuilder<List<Judet>>(
                      future: getJudete(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return Text("Eroare la incarcarea judetelor.");
                        }
                        return snapshot.hasData
                            ? Padding(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 5),
                                child: Container(
                                  child: DropdownButton<Judet>(
                                    isExpanded: true,
                                    hint: Text(denumireJudetAles),
                                    items: snapshot.data
                                        ?.map<DropdownMenuItem<Judet>>((item) {
                                      return DropdownMenuItem<Judet>(
                                        value: item,
                                        child: Text(item.denumire),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null) {
                                          judetAles = new Judet(
                                              id: value.id,
                                              denumire: value.denumire,
                                              prescurtare: value.prescurtare);
                                          denumireJudetAles = value.denumire;
                                          localitati = getLocalitati(judetAles);
                                          localitateAleasa = null;
                                          denumireLocalitateAleasa =
                                              "Localitate";
                                        }
                                      });
                                    },
                                  ),
                                ))
                            : Padding(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, bottom: 5),
                                child: Container(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ));
                      },
                    )),
                    Expanded(
                        child: FutureBuilder<List<Localitate>>(
                      future: localitati,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Padding(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 5),
                              child: Container(
                                child: DropdownButton<Localitate>(
                                  isExpanded: true,
                                  hint: Text(denumireLocalitateAleasa),
                                  items: snapshot.data
                                      ?.map<DropdownMenuItem<Localitate>>(
                                          (item) {
                                    return DropdownMenuItem<Localitate>(
                                      value: item,
                                      child: Text(item.denumire),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value != null) {
                                        localitateAleasa = new Localitate(
                                            id: value.id,
                                            denumire: value.denumire,
                                            judet: value.judet);
                                        denumireLocalitateAleasa =
                                            value.denumire;
                                      }
                                    });
                                  },
                                ),
                              ));
                        } else if (snapshot.hasError) {
                          print(snapshot.error);
                          return Text("Eroare la incarcarea localitatilor.");
                        } else {
                          return Container();
                        }
                      },
                    )),
                  ],
                ),
                Row(children: [
                  Expanded(
                      child: FutureBuilder<List<Domeniu>>(
                    future: getDomenii(widget.authToken),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Text("Eroare la incarcarea domeniilor.");
                      }
                      return snapshot.hasData
                          ? Padding(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 5),
                              child: Container(
                                child: DropdownButton<Domeniu>(
                                  isExpanded: true,
                                  hint: Text(denumireDomeniuAles),
                                  items: snapshot.data
                                      ?.map<DropdownMenuItem<Domeniu>>((item) {
                                    return DropdownMenuItem<Domeniu>(
                                      value: item,
                                      child: Text(item.denumire),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value != null) {
                                        domeniuAles = new Domeniu(
                                            id: value.id,
                                            denumire: value.denumire);
                                      }
                                      print(denumireDomeniuAles);
                                    });
                                  },
                                ),
                              ))
                          : Padding(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, bottom: 5),
                              child: Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ));
                    },
                  )),
                  ElevatedButton(onPressed: null, child: Icon(Icons.search))
                ]),
                FutureBuilder<List<PunctLucru>>(
                  future: getPuncteLucru(localitateAleasa, domeniuAles,
                      cuvinteCheieController.text, widget.authToken),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Text(snapshot.error.toString());
                    }
                    return snapshot.hasData
                        ? Padding(
                            padding:
                                EdgeInsets.only(left: 20, right: 20, bottom: 5),
                            child: Container(
                                child: ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Text(
                                          '${snapshot.data![index].denumire}');
                                    })))
                        : Padding(
                            padding:
                                EdgeInsets.only(left: 15, right: 15, bottom: 5),
                            child: Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ));
                  },
                ),
              ],
            )
          ],
        )));
  }
}
