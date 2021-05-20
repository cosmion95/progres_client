import 'package:demo_login_app/models/punct_lucru.dart';
import 'package:flutter/material.dart';
import '../models/punct_lucru.dart';

class PunctListWidget extends StatefulWidget {
  PunctListWidget(this.punctLucru);
  final PunctLucru punctLucru;

  @override
  PunctListWidgetState createState() => PunctListWidgetState();
}

class PunctListWidgetState extends State<PunctListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: widget.punctLucru.domeniu!.icon,
        ),
        title: Text(
          widget.punctLucru.denumire,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: <Widget>[
            Text(widget.punctLucru.strada + " " + widget.punctLucru.nrStrada,
                style: TextStyle(color: Colors.white))
          ],
        ),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0));
  }
}
