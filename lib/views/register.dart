import 'package:flutter/material.dart';
import '../models/judet.dart';
import '../models/localitate.dart';
import '../models/client.dart';
import 'package:email_validator/email_validator.dart';
import 'register_token.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //variabile pentru erori
  String? errorMsg;

  //variabile pentru combo-urile de judet si localitate
  Future<List<Localitate>>? localitati;
  late Judet judetAles;
  Localitate? localitateAleasa;
  String denumireJudetAles = "Judet";
  String denumireLocalitateAleasa = "Localitate";

  //variabile pentru campurile de email si parola
  bool _validEmail = false;
  bool _hidePass = true;
  bool _loginResult = true;

  TextEditingController numeController = TextEditingController();
  TextEditingController prenumeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefonController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool checkEmailField(String email) {
    if (email.length == 0) {
      return true;
    }
    bool checkEmail = EmailValidator.validate(email);
    if (checkEmail) {
      _validEmail = true;
    } else {
      _validEmail = false;
    }
    return checkEmail;
  }

  Future<void> register() async {
    try {
      Map<String, dynamic> clientMap = await registerClient(
          numeController.text,
          prenumeController.text,
          emailController.text,
          passController.text,
          telefonController.text,
          localitateAleasa);
      Client client = new Client(
          id: int.parse(clientMap["id"]),
          nume: numeController.text,
          prenume: prenumeController.text,
          email: emailController.text,
          telefon: telefonController.text,
          localitate: localitateAleasa,
          rataPrezenta: 100);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              RegisterToken(client, clientMap["auth_token"])));
    } catch (e) {
      errorMsg = e.toString();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
            child: TextFormField(
              controller: numeController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                hintText: "Nume",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
            child: TextFormField(
              controller: prenumeController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                hintText: "Prenume",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
            child: TextFormField(
              controller: emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => checkEmailField(value!)
                  ? null
                  : "Introduceti o adresa de email valida.",
              decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: TextFormField(
              controller: passController,
              obscureText: _hidePass,
              decoration: InputDecoration(
                hintText: "Parola",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _hidePass = !_hidePass;
                    });
                  },
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: _hidePass ? Colors.grey : Colors.red,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
            child: TextFormField(
              controller: telefonController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                hintText: "Telefon",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          FutureBuilder<List<Judet>>(
            future: getJudete(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return Text("Eroare la incarcarea judetelor.");
              }
              return snapshot.hasData
                  ? Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
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
                                denumireLocalitateAleasa = "Localitate";
                              }
                            });
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
          FutureBuilder<List<Localitate>>(
            future: localitati,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                    child: Container(
                      child: DropdownButton<Localitate>(
                        isExpanded: true,
                        hint: Text(denumireLocalitateAleasa),
                        items: snapshot.data
                            ?.map<DropdownMenuItem<Localitate>>((item) {
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
                              denumireLocalitateAleasa = value.denumire;
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
          ),
          ElevatedButton(
            onPressed: () {
              register();
            },
            child: Container(
              child: Text("Inregistrare"),
            ),
          ),
          Text(
            errorMsg ?? '',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    ));
  }
}
