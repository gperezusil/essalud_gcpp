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
            Expanded(
              flex: 5,
              child: GestureDetector(
                onTap: (){
                   Navigator.push(
                    context,
                    MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return RecursosPropiosPage();
                      },
                      fullscreenDialog: true,
                    ));
                },
                              child: Container(
                  height: 100,
                  color: Colors.blueAccent,
                  child: Center(child: Text('Recursos Propios COVID', style: TextStyle(fontSize: 20,color: Colors.white),)),
                  padding: EdgeInsets.all(10),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: GestureDetector(
                onTap: (){
                   Navigator.push(
                    context,
                    MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return CovidTransferenciaPage();
                      },
                      fullscreenDialog: true,
                    ));
                },
                              child: Container(
                    height: 100,
                  color: Colors.cyan,
                  child: Center(child: Text('Transferencias Financieras COVID' , 
                  textAlign: TextAlign.center , style: TextStyle(fontSize: 20,color: Colors.white))),
                  padding: EdgeInsets.all(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
