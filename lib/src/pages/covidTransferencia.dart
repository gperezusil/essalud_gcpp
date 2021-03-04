import 'package:flutter/material.dart';
import 'package:gcpp_essalud/src/pages/suspension2021.dart';
import 'package:gcpp_essalud/src/pages/transferencia.dart';
import 'package:gcpp_essalud/src/pages/decreto026.dart';
import 'package:gcpp_essalud/src/pages/suspension.dart';
import 'package:intl/intl.dart';

class CovidTransferenciaPage extends StatefulWidget {
  @override
  _CovidTransferenciaPageState createState() => _CovidTransferenciaPageState();
}

class _CovidTransferenciaPageState extends State<CovidTransferenciaPage> {
  final f = new DateFormat('dd-MM-yyyy');
  final form = new DateFormat('dd/MM/yyyy');
  String annoSeleccionado = '2021';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transferencias Financieras COVID')),
      body: SingleChildScrollView(
        child: Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            direction: Axis.horizontal,
            spacing: 20.0, // gap between adjacent chips
            runSpacing: 8.0,
            children: [
              _builCombo(context),
              _transferencias2020(),
              _transferencias2021()
            ],
          ),
        ),
      ),
    );
  }

  Widget _builCombo(context) {
    var anno = ['2020', '2021'];
    return Center(
        child: DropdownButton(
            hint: Text("Seleccione Año"),
            value: annoSeleccionado,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black, fontSize: 15),
            onChanged: (String ge) {
              setState(() {
                annoSeleccionado = ge;
              });
            },
            items: anno.map((String valor) {
              return DropdownMenuItem<String>(
                value: valor,
                child: Text(
                  valor,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              );
            }).toList()));
  }

  Widget _transferencias2020() {
    if (annoSeleccionado == '2020') {
      return Wrap(
        direction: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return TransferenciaPage(
                            fondo: '002518',
                            descFondo: 'Villa Panamericana (2518)');
                      },
                      fullscreenDialog: true,
                    ));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                width: MediaQuery.of(context).size.width / 2.5,
                height: 100,
                child: Center(
                    child: Text('Villa Panamericana (2518)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white))),
                padding: EdgeInsets.all(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return TransferenciaPage(
                            fondo: '002519',
                            descFondo: 'Villa Panamericana (2519)');
                      },
                      fullscreenDialog: true,
                    ));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                width: MediaQuery.of(context).size.width / 2.5,
                height: 100,
                child: Center(
                    child: Text('Villa Panamericana (2519)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white))),
                padding: EdgeInsets.all(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return TransferenciaPage(
                            fondo: '002520', descFondo: 'Traslados (2520)');
                      },
                      fullscreenDialog: true,
                    ));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                width: MediaQuery.of(context).size.width / 2.5,
                height: 100,
                child: Center(
                    child: Text('Traslados (2520)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white))),
                padding: EdgeInsets.all(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return TransferenciaPage(
                            fondo: '002521',
                            descFondo: 'Decreto Supremo N° 55-2020');
                      },
                      fullscreenDialog: true,
                    ));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                width: MediaQuery.of(context).size.width / 2.5,
                height: 100,
                child: Center(
                    child: Text('Decreto Supremo N° 55-2020',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white))),
                padding: EdgeInsets.all(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return TransferenciaPage(
                            fondo: '002522',
                            descFondo: 'Decreto Supremo N° 80-2020');
                      },
                      fullscreenDialog: true,
                    ));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                width: MediaQuery.of(context).size.width / 2.5,
                height: 100,
                child: Center(
                    child: Text('Decreto Supremo N° 80-2020',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white))),
                padding: EdgeInsets.all(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return TransferenciaPage(
                            fondo: '002523',
                            descFondo: 'Villa Panamericana (2523)');
                      },
                      fullscreenDialog: true,
                    ));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                width: MediaQuery.of(context).size.width / 2.5,
                height: 100,
                child: Center(
                    child: Text('Villa Panamericana (2523)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white))),
                padding: EdgeInsets.all(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return TransferenciaPage(
                            fondo: '002524',
                            descFondo: 'Videnita y Cerro Juli (2524)');
                      },
                      fullscreenDialog: true,
                    ));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                width: MediaQuery.of(context).size.width / 2.5,
                height: 100,
                child: Center(
                    child: Text('Videnita y Cerro Juli (2524)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white))),
                padding: EdgeInsets.all(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return TransferenciaPage(
                            fondo: '002525',
                            descFondo: 'Tacna y Moquegua (2525)');
                      },
                      fullscreenDialog: true,
                    ));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                width: MediaQuery.of(context).size.width / 2.5,
                height: 100,
                child: Center(
                    child: Text('Tacna y Moquegua (2525)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white))),
                padding: EdgeInsets.all(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return TransferenciaPage(
                            fondo: '002526', descFondo: 'DU-113(2526)');
                      },
                      fullscreenDialog: true,
                    ));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                width: MediaQuery.of(context).size.width / 2.5,
                height: 100,
                child: Center(
                    child: Text('DU-113(2526)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white))),
                padding: EdgeInsets.all(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return Decreto026Page();
                      },
                      fullscreenDialog: true,
                    ));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                width: MediaQuery.of(context).size.width / 2.5,
                height: 100,
                child: Center(
                    child: Text('DS N° 026-2020 - DS N°307-2020',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white))),
                padding: EdgeInsets.all(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return SuspensionPerfectaPage();
                      },
                      fullscreenDialog: true,
                    ));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                width: MediaQuery.of(context).size.width / 2.5,
                height: 100,
                child: Center(
                    child: Text('Suspension Perfecta',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white))),
                padding: EdgeInsets.all(10),
              ),
            ),
          ),
        ],
      );
    } else {
      return SizedBox(height: 0);
    }
  }

  Widget _transferencias2021() {
    return Wrap(
      direction: Axis.horizontal,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return SuspensionPerfectaPage2021();
                    },
                    fullscreenDialog: true,
                  ));
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.cyan,
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              width: MediaQuery.of(context).size.width / 2.5,
              height: 100,
              child: Center(
                  child: Text('Supension Perfecta',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.white))),
              padding: EdgeInsets.all(10),
            ),
          ),
        ),
      ],
    );
  }
}
