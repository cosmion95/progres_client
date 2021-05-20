import 'package:demo_login_app/models/punct_lucru.dart';
import 'package:flutter/material.dart';
import '../models/punct_lucru.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PunctListWidget extends StatefulWidget {
  PunctListWidget(this.punctLucru);
  final PunctLucru punctLucru;

  @override
  PunctListWidgetState createState() => PunctListWidgetState();
}

class PunctListWidgetState extends State<PunctListWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          padding: EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10.0),
                Icon(
                  widget.punctLucru.domeniu!.icon.icon,
                  color: Colors.white,
                  size: 40.0,
                ),
                Container(
                  width: 90.0,
                  child: new Divider(color: Colors.green),
                ),
                SizedBox(height: 5.0),
                Text(
                  widget.punctLucru.denumire,
                  style: TextStyle(color: Colors.white, fontSize: 24.0),
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        flex: 6,
                        child: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Row(children: [
                              Icon(
                                Icons.home,
                                color: Colors.white,
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    " " +
                                        widget.punctLucru.strada +
                                        " " +
                                        widget.punctLucru.nrStrada,
                                    style: TextStyle(color: Colors.white),
                                  ))
                            ]))),
                    Expanded(
                        flex: 1,
                        child: Container(
                            padding: const EdgeInsets.all(7.0),
                            child: FloatingActionButton(
                              onPressed: () {
                                Fluttertoast.showToast(
                                    msg: "Calling " +
                                        widget.punctLucru.telefon +
                                        "...",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              },
                              child: Icon(Icons.phone, color: Colors.white),
                            )))
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
