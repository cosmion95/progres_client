import 'package:flutter/material.dart';
import '../models/client.dart';

class HomepageCont extends StatefulWidget {
  HomepageCont(this.client, this.authToken);
  final Client client;
  final String authToken;

  @override
  HomepageContState createState() => HomepageContState();
}

class HomepageContState extends State<HomepageCont> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Center(
        child: Text("Hello " + widget.client.prenume + "\nHomepage Cont"),
      ),
    );
  }
}
