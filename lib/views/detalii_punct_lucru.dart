import 'package:flutter/material.dart';
import '../models/client.dart';
import '../models/punct_lucru.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DetaliiPunctLucru extends StatefulWidget {
  DetaliiPunctLucru(this.client, this.authToken, this.punctLucru, this.zi);
  final Client client;
  final String authToken;
  final PunctLucru punctLucru;
  final DateTime zi;

  @override
  DetaliiPunctLucruState createState() => DetaliiPunctLucruState();
}

class DetaliiPunctLucruState extends State<DetaliiPunctLucru> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.cyan,
        body: SfCalendar(
          view: CalendarView.week,
          firstDayOfWeek: 1,
          initialDisplayDate: widget.zi,
          initialSelectedDate: widget.zi,
        ));
  }
}
