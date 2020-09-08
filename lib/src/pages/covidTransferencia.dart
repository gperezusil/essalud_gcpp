import 'package:flutter/material.dart';

class CovidTransferenciaPage extends StatefulWidget {
  @override
  _CovidTransferenciaPageState createState() => _CovidTransferenciaPageState();
}

class _CovidTransferenciaPageState extends State<CovidTransferenciaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transferencias Financieras COVID')),
      body: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          spacing: 20.0, // gap between adjacent chips
          runSpacing: 8.0,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  color: Colors.blue,
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(
                    "Villa Panamericana (2518)",
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
                    "Villa Panamericana (2519)",
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
                    "Traslados (2520)",
                  ),
                  onPressed: () {},
                ),
                RaisedButton(
                  elevation: 10.0,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  color: Colors.cyan,
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(
                    "Decreto Supremo N° 55-2020",
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
                    "Decreto Supremo N° 80-2020",
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
                    "Villa Panamericana (2523)",
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
                    "Videnita y Cerro Juli (2524) ",
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
                    "Decreto Supremo N° 026-2020",
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
                    "Suspension Perfecta",
                  ),
                  onPressed: () {},
                ),
                RaisedButton(
                  elevation: 10.0,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  color: Colors.blueGrey,
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(
                    "Continuidad",
                  ),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
