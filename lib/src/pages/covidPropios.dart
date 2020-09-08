import 'package:flutter/material.dart';
import 'package:gcpp_essalud/src/pages/covid.dart';

class RecursosPropiosPage extends StatefulWidget {
  @override
  _RecursosPropiosPageState createState() => _RecursosPropiosPageState();
}

class _RecursosPropiosPageState extends State<RecursosPropiosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recursos Propios COVID')),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
              color: Colors.blue,
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                "Decreto Supremo 10",
              ),
              elevation: 10.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              onPressed: () {},
            ),
            RaisedButton(
              elevation: 10.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: Colors.greenAccent,
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                "Decreto Supremo 11",
              ),
              onPressed: () {},
            ),
            RaisedButton(
              elevation: 10.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: Colors.purple,
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                "Covid Redes",
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return CovidPage();
                      },
                      fullscreenDialog: true,
                    ));
              },
            ),
            RaisedButton(
              elevation: 10.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: Colors.cyan,
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                "DU 26 (Bono)",
              ),
              onPressed: () {},
            ),
            RaisedButton(
              elevation: 10.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: Colors.amberAccent,
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                "Covid Sede",
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
