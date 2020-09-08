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
      body: SingleChildScrollView(
        child: Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            direction: Axis.horizontal,
            spacing: 20.0, // gap between adjacent chips
            runSpacing: 8.0,
            children: [
              Wrap(
                direction: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {},
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
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white))),
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {},
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
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white))),
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {},
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
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white))),
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {},
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
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white))),
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {},
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
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white))),
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {},
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
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white))),
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {},
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
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white))),
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.cyan,
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: 100,
                        child: Center(
                            child: Text('Decreto Supremo N° 026-2020',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white))),
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {},
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
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white))),
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.cyan,
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: 100,
                        child: Center(
                            child: Text('Continuidad Laboral',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white))),
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
