import 'package:flutter/material.dart';
import 'package:gcpp_essalud/src/pages/covid.dart';
import 'package:gcpp_essalud/src/pages/covidPropios.dart';
import 'package:gcpp_essalud/src/pages/covidTransferencia.dart';

class MenuCovidPage extends StatefulWidget {
  @override
  _MenuCovidPageState createState() => _MenuCovidPageState();
}

class _MenuCovidPageState extends State<MenuCovidPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
              color: Colors.blue,
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                "Recursos Propios COVID",
              ),
              elevation: 10.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return RecursosPropiosPage();
                      },
                      fullscreenDialog: true,
                    ));
              },
            ),
            RaisedButton(
              elevation: 10.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: Colors.greenAccent,
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                "Transferencias COVID",
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return CovidTransferenciaPage();
                      },
                      fullscreenDialog: true,
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
