import 'package:demo_login_app/models/program_punct.dart';
import 'package:demo_login_app/views/punct_lucru.dart';
import 'package:flutter/material.dart';
import '../models/client.dart';
import '../models/judet.dart';
import '../models/localitate.dart';
import '../models/domeniu.dart';
import '../models/punct_lucru.dart';
import '../widget/punct_list_widget.dart';

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

  int pagina = 1;
  bool isLoading = true;
  List<PunctLucru> puncteLucru = [];

  String denumireJudetAles = "Judet";
  String denumireLocalitateAleasa = "Localitate";
  String denumireDomeniuAles = "Domeniu";

  Future<List<Localitate>>? localitati;
  TextEditingController cuvinteCheieController = TextEditingController();

  Future<void> detaliiPunct(PunctLucru punctLucru) async {
    DateTime urmatoareaZiLucratoare =
        await getUrmatoareaZiLucratoare(punctLucru, widget.authToken);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PunctLucruView(punctLucru, widget.client,
            widget.authToken, urmatoareaZiLucratoare)));
  }

  Future<void> getPuncte() async {
    List<PunctLucru> puncteNoi = await getPuncteLucru(localitateAleasa,
        domeniuAles, cuvinteCheieController.text, widget.authToken, pagina);
    puncteLucru.addAll(puncteNoi);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (this.localitateAleasa == null) {
      this.localitateAleasa = widget.client.localitate;
    }
    this.getPuncte();
  }

  @override
  Widget build(BuildContext context) {
    if (judetAles == null) {
      judetAles = widget.client.localitate?.judet;
      denumireJudetAles = judetAles!.denumire;
      localitateAleasa = widget.client.localitate;
      denumireLocalitateAleasa = localitateAleasa!.denumire;
    }

    localitati = getLocalitati(judetAles);

    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: SafeArea(
            child: Column(
          children: [
            Container(
                color: Colors.blueGrey.shade100,
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: cuvinteCheieController,
                      decoration: InputDecoration(
                        hintText: "Cauta...",
                        border: OutlineInputBorder(),
                      ),
                    )),
                  ],
                )),
            Column(
              mainAxisSize: MainAxisSize.max,
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
                                            denumire: value.denumire,
                                            icon: value.icon);
                                        denumireDomeniuAles =
                                            domeniuAles!.denumire;
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
                  ElevatedButton(
                      onPressed: () {
                        pagina = 1;
                        domeniuAles = null;
                        denumireDomeniuAles = "Domeniu";
                        cuvinteCheieController.text = "";
                        setState(() {});
                      },
                      child: Icon(Icons.refresh)),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.orange.shade300),
                      onPressed: () {
                        pagina = 1;
                        puncteLucru.clear();
                        getPuncte();
                      },
                      child: Icon(Icons.search))
                ]),
              ],
            ),
            Expanded(
                child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!isLoading &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  pagina += 1;
                  this.getPuncte();
                  setState(() {
                    isLoading = true;
                  });
                }
                return false;
              },
              child: _buildListView(),
            )),
            Container(
              height: isLoading ? 50.0 : 0,
              color: Colors.white30,
              child: Center(
                child: new CircularProgressIndicator(
                  color: Colors.orange,
                ),
              ),
            ),
          ],
        )));
  }

  Widget _buildListView() {
    return ListView.builder(
        itemCount: puncteLucru.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              detaliiPunct(puncteLucru[index]);
            },
            child: PunctListWidget(puncteLucru[index]),
          );
        });
  }
}
