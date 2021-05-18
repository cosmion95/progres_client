import 'package:flutter/material.dart';
import '../models/client.dart';
import 'homepage.dart';

class RegisterToken extends StatefulWidget {
  RegisterToken(this.client, this.authToken);
  final Client client;
  final String authToken;

  @override
  RegisterTokenState createState() => RegisterTokenState();
}

class RegisterTokenState extends State<RegisterToken> {
  String? errorMsg;

  TextEditingController tokenController = TextEditingController();

  Future<void> checkRegister() async {
    try {
      await checkRegisterToken(
          widget.client, tokenController.text, widget.authToken);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Homepage(widget.client, widget.authToken)));
    } catch (e) {
      errorMsg = e.toString();
      setState(() {});
    }
  }

  Future<void> resend() async {
    try {
      await resendRegisterToken(widget.client, widget.authToken);
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
