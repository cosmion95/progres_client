import 'package:demo_login_app/models/punct_lucru.dart';
import 'package:demo_login_app/views/detalii_punct_lucru.dart';
import 'package:flutter/material.dart';
import '../models/client.dart';
import '../models/punct_lucru.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widget/punct_details_widget.dart';
import '../models/program_punct.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class PunctLucruView extends StatefulWidget {
  PunctLucruView(this.punctLucru, this.client, this.authToken,
      this.urmatoareaZiLucratoare);
  final PunctLucru punctLucru;
  final Client client;
  final String authToken;
  final DateTime urmatoareaZiLucratoare;

  @override
  PunctLucruViewState createState() => PunctLucruViewState();
}

class PunctLucruViewState extends State<PunctLucruView> {
  DateTime? _firstDay;
  DateTime? _lastDay;
  DateTime? _selectedDay;
  DateTime? _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  List<ProgramPunct>? program;
  List<String> programZi = [];
  bool eZiLucratoare = false;

  Future<void> getProgram() async {
    program = await getProgramPunct(widget.punctLucru, widget.authToken);
  }

  Future<void> getZi() async {
    DateTime dat =
        await getUrmatoareaZiLucratoare(widget.punctLucru, widget.authToken);
    print(dat);
  }

  Future<void> detaliiPunct() async {
    List<Appointment> rezervari = await getProgramNeeligibil(
        widget.client, widget.punctLucru, widget.authToken);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DetaliiPunctLucru(widget.client, widget.authToken,
            widget.punctLucru, _selectedDay!, _lastDay!, rezervari)));
  }

  Color? calculeazaCuloare(double procent) {
    if (procent < 0.5) {
      return Color.lerp(Colors.green, Colors.yellow, procent * 2);
    } else {
      return Color.lerp(Colors.yellow, Colors.red, procent / 1.5);
    }
  }

  void setProgram(DateTime zi) {
    programZi.clear();
    programZi.add("Program: ");
    for (var prog in program!) {
      if (prog.data.year == zi.year &&
          prog.data.month == zi.month &&
          prog.data.day == zi.day) {
        programZi.add(prog.oraStart + " - " + prog.oraFinal);
      }
    }
    if (programZi.length > 1) {
      eZiLucratoare = true;
    } else {
      eZiLucratoare = false;
    }
  }

  @override
  void initState() {
    super.initState();
    getProgram();
    getZi();
  }

  @override
  Widget build(BuildContext context) {
    _lastDay =
        DateTime.now().add(Duration(days: widget.punctLucru.zileRezervariMax));
    _firstDay = widget.urmatoareaZiLucratoare;

    if (_selectedDay == null) {
      _selectedDay = _firstDay;
    }
    if (_focusedDay == null) {
      _focusedDay = _firstDay;
    }

    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          PunctListWidget(widget.punctLucru),
          TableCalendar(
            firstDay: _firstDay!,
            lastDay: _lastDay!,
            focusedDay: _focusedDay!,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                setProgram(_selectedDay!);
              });
            },
          ),
          Expanded(
              child: Padding(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: programZi.length,
                          //itemExtent: 30,
                          itemBuilder: (context, index) {
                            return Text(programZi[index]);
                          },
                        )),
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(left: 40, top: 25),
                                child: Text("Ocupat: "))),
                        Expanded(
                            child: FutureBuilder<int>(
                          future: getProcentOcupare(widget.punctLucru,
                              _selectedDay!, widget.authToken),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              print(snapshot.error);
                              return Text("Eroare la incarcarea procentului.");
                            }
                            return snapshot.hasData
                                ? CircleAvatar(
                                    radius: 35,
                                    backgroundColor: calculeazaCuloare(
                                        snapshot.data!.toDouble() / 100),
                                    child: Text(
                                      snapshot.data.toString() + "%",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(
                                        left: 15, right: 15, bottom: 5),
                                    child: Container(
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ));
                          },
                        )),
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: FloatingActionButton(
                                    heroTag: "makeRezervare",
                                    backgroundColor: eZiLucratoare
                                        ? Colors.blue
                                        : Colors.grey,
                                    onPressed: eZiLucratoare
                                        ? () {
                                            detaliiPunct();
                                          }
                                        : null,
                                    child: Icon(Icons.add))))
                      ]))),
        ],
      )),
    );
  }
}
