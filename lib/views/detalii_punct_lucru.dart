import 'package:flutter/material.dart';
import '../models/client.dart';
import '../models/punct_lucru.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../widget/creare_rezervare_dialog.dart';

class DetaliiPunctLucru extends StatefulWidget {
  DetaliiPunctLucru(this.client, this.authToken, this.punctLucru, this.ziAleasa,
      this.ultimaZi, this.rezervari);
  final Client client;
  final String authToken;
  final PunctLucru punctLucru;
  final DateTime ziAleasa;
  final DateTime ultimaZi;
  final List<Appointment> rezervari;

  @override
  DetaliiPunctLucruState createState() => DetaliiPunctLucruState();
}

class DetaliiPunctLucruState extends State<DetaliiPunctLucru> {
  final CalendarController calendarController = new CalendarController();
  DateTime? dataPrimita;
  bool dataValida = false;

  void alesData(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.appointments != null) {
      dataValida = false;
      setState(() {});
    } else {
      verificaTimp(calendarController.selectedDate!);
    }
  }

  Future<void> verificaTimp(DateTime data) async {
    Map<String, dynamic> result = await verificareTimpAles(
        widget.punctLucru, data, null, widget.authToken);
    dataValida = result['accepted'];
    dataPrimita = result['data'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SfCalendar(
        controller: calendarController,
        view: CalendarView.week,
        firstDayOfWeek: 1,
        initialDisplayDate: widget.ziAleasa,
        initialSelectedDate: widget.ziAleasa,
        dataSource: RezervareDataSource(widget.rezervari),
        minDate: DateTime.now(),
        maxDate: widget.ultimaZi,
        onTap: (CalendarTapDetails calendarTapDetails) {
          alesData(calendarTapDetails);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: dataValida
            ? () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => CreareRezervareDialog(
                      widget.punctLucru,
                      widget.client,
                      widget.authToken,
                      dataPrimita!),
                );
              }
            : null,
        child: Icon(Icons.check),
        backgroundColor: dataValida ? Colors.greenAccent : Colors.grey,
      ),
    ));
  }
}

class RezervareDataSource extends CalendarDataSource {
  RezervareDataSource(List<Appointment> rezervari) {
    appointments = rezervari;
  }
}
