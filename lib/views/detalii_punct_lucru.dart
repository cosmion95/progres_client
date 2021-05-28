import 'package:flutter/material.dart';
import '../models/client.dart';
import '../models/punct_lucru.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../widget/creare_rezervare_dialog.dart';
import '../models/program_punct.dart';
import '../widget/detalii_rezervare_dialog.dart';

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
  int? rezervareId;
  Color? culoareRezervare;

  List<Appointment>? rezervariNoi;

  void alesData(CalendarTapDetails calendarTapDetails) {
    rezervareId = null;
    culoareRezervare = null;
    if (calendarTapDetails.appointments != null) {
      for (Appointment app in calendarTapDetails.appointments!) {
        if (app.notes != null) {
          rezervareId = int.parse(app.notes!);
          culoareRezervare = app.color;
          break;
        }
      }
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

  Future<void> refreshRezervari() async {
    rezervariNoi = await getProgramNeeligibil(
        widget.client, widget.punctLucru, widget.authToken);
    setState(() {});
  }

  Icon getButtonIcon() {
    if (rezervareId != null) {
      return Icon(Icons.edit);
    }
    return Icon(Icons.check);
  }

  Color getButtonColor() {
    if (rezervareId != null) {
      return culoareRezervare!;
    }
    if (dataValida) {
      return Colors.greenAccent;
    }
    return Colors.grey;
  }

  void buttonPressed() {
    if (rezervareId != null) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => DetaliiRezervareDialog(
            widget.punctLucru,
            widget.client,
            rezervareId!,
            culoareRezervare!,
            widget.authToken),
      ).then((value) => {refreshRezervari()});
    } else {
      if (dataValida) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => CreareRezervareDialog(
              widget.punctLucru, widget.client, widget.authToken, dataPrimita!),
        ).then((value) => {refreshRezervari()});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (rezervariNoi == null) {
      rezervariNoi = widget.rezervari;
    }
    return SafeArea(
        child: Scaffold(
      body: SfCalendar(
        controller: calendarController,
        view: CalendarView.week,
        firstDayOfWeek: 1,
        initialDisplayDate: widget.ziAleasa,
        initialSelectedDate: widget.ziAleasa,
        dataSource: RezervareDataSource(rezervariNoi!),
        minDate: DateTime.now(),
        maxDate: widget.ultimaZi,
        onTap: (CalendarTapDetails calendarTapDetails) {
          alesData(calendarTapDetails);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: buttonPressed,
        child: getButtonIcon(),
        backgroundColor: getButtonColor(),
      ),
    ));
  }
}

class RezervareDataSource extends CalendarDataSource {
  RezervareDataSource(List<Appointment> rezervari) {
    appointments = rezervari;
  }
}
