import 'package:flutter/material.dart';
import '../models/client.dart';
import 'homepage_cont.dart';
import 'homepage_cauta.dart';
import 'homepage_rezervari.dart';

class Homepage extends StatefulWidget {
  Homepage(this.client, this.authToken);
  final Client client;
  final String authToken;

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  static late List<Widget> _widgetOptions;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _widgetOptions = <Widget>[
      HomepageCont(widget.client, widget.authToken),
      HomepageCauta(widget.client, widget.authToken),
      HomepageRezervari(widget.client, widget.authToken),
    ];

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Cont',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Cauta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Rezervari',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
