import 'package:flutter/material.dart';
import 'package:gcpp_essalud/src/pages/covid.dart';
import 'package:gcpp_essalud/src/pages/covidTransferencia.dart';
import 'package:gcpp_essalud/src/pages/decreto.dart';

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
        child: Wrap(
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
                          return DecretoPage(decreto: 'Covid-DS10',);
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
                      child: Text('Decreto Supremo Nº 10-2020-SA',
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
                          return DecretoPage(decreto: 'Covid-DS11',);
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
                      child: Text('Decreto Supremo Nº 11-2020-SA',
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
                          return CovidPage();
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
                      child: Text('Covid Redes',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.white))),
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
                      child: Text('DU Nº 026-2020 (Bonos)',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.white))),
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
                      child: Text('Covid Sede',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.white))),
                  padding: EdgeInsets.all(10),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
