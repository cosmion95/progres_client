import 'package:flutter/material.dart';
import '../models/client.dart';
import 'homepage.dart';

class RegisterToken extends StatefulWidget {
  RegisterToken(this.clientEmail, this.authToken);
  final String clientEmail;
  final String authToken;

  @override
  RegisterTokenState createState() => RegisterTokenState();
}

class RegisterTokenState extends State<RegisterToken> {
  String? errorMsg;

  TextEditingController tokenController = TextEditingController();

  Future<void> checkRegister() async {
    try {
      await verificaCodInregistrare(
          widget.clientEmail, tokenController.text, widget.authToken);
      Client client =
          await getClientFromEmail(widget.clientEmail, widget.authToken);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Homepage(client, widget.authToken)));
    } catch (e) {
      errorMsg = e.toString();
      setState(() {});
    }
  }

  Future<void> resend() async {
    try {
      await retrimiteCodInregistrare(widget.clientEmail, widget.authToken);
    } catch (e) {
      errorMsg = e.toString();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                "Inregistrare facuta cu succes. Am trimis un cod de activare la adresa de email specificata."),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
              child: TextFormField(
                controller: tokenController,
                decoration: InputDecoration(
                  hintText: "Cod",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Text(
              errorMsg ?? '',
              style: TextStyle(color: Colors.red),
            ),
            ElevatedButton(
              onPressed: checkRegister,
              child: Container(
                child: Text("Verifica"),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.blue),
            ),
            ElevatedButton(
              onPressed: resend,
              child: Container(
                child: Text("Retrimite cod"),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.amber),
            ),
          ],
        ),
      ),
    );
  }
}
