import 'package:flutter/material.dart';
import '../models/client.dart';

class HomepageRezervari extends StatefulWidget {
  HomepageRezervari(this.client, this.authToken);
  final Client client;
  final String authToken;

  @override
  HomepageRezervariState createState() => HomepageRezervariState();
}

class HomepageRezervariState extends State<HomepageRezervari> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Text("Hello " + widget.client.prenume + "\nHomepage Rezervari"),
      ),
    );
  }
}
