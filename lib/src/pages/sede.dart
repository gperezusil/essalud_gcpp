import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:gcpp_essalud/src/util/metodos.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';

class SedeCentral extends StatefulWidget {
  @override
  _SedeCentralState createState() => _SedeCentralState();
}

class _SedeCentralState extends State<SedeCentral> {
  Metodos me = new Metodos();
  String gerencia;
  Random random = new Random();


  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 5, 5),
                child: Column(
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection('Sede')
                          .where('rubro', isEqualTo: 'SUB-TOTAL')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> data) {
                        if (!data.hasData) {
                          return Center(child: new CircularProgressIndicator());
                        }
                        data.data.documents.sort((a, b) => a.data['red']
                            .toString()
                            .compareTo(b.data['red'].toString()));
                        return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: DropdownButton(
                              isExpanded: true,
                              hint: Text("Seleccione Gerencia"),
                              value: gerencia,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                              onChanged: (String ge) {
                                setState(() {
                                  gerencia = ge;
                                });
                              },
                              items: data.data.documents
                                  .map((DocumentSnapshot valor) {
                                return DropdownMenuItem<String>(
                                  value: valor.data['red'],
                                  child: Text(
                                    valor.data['red'],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                );
                              }).toList(),
                            ));
                      },
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection('Sede')
                          .where('red', isEqualTo: gerencia)
                          .where('rubro', isEqualTo: 'SUB-TOTAL')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> data) {
                        if (!data.hasData) {
                          return Center(child: new CircularProgressIndicator());
                        }
                        return GestureDetector(
                          child: Container(
                              child: Column(
                            children: [
                              new CircularPercentIndicator(
                                radius: 130.0,
                                lineWidth: 15.0,
                                animation: true,
                                percent: me.verificarNumero(
                                    data.data.documents[0]['porcentaje']),
                                center: new Text(
                                  me
                                          .formatearNumero(data.data
                                                  .documents[0]['porcentaje'] *
                                              100)
                                          .output
                                          .nonSymbol
                                          .toString() +
                                      '%',
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                header: Text(data.data.documents[0]['red'],
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0)),
                                footer: new Text(
                                  me
                                      .formatearNumero(
                                          data.data.documents[0]['ejecucion'])
                                      .output
                                      .withoutFractionDigits
                                      .toString(),
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: Colors.greenAccent,
                              )
                            ],
                          )),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    detalleRedes(context)
                  ],
                ))));
  }

  Widget detalleRedes(context) {
    return Wrap(
      children: <Widget>[
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('Sede')
              .where('red', isEqualTo: gerencia)
              .where('rubro',
                  whereIn: ['PERSONAL', 'BIENES', 'SERVICIOS']).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
            if (!data.hasData) {
              return Center(child: new CircularProgressIndicator());
            }
            data.data.documents.sort((a,b)=>a.data['rubro'].toString().compareTo(b.data['rubro'].toString()));
            return Column(children: <Widget>[
              Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20.0, // gap between adjacent chips
                  runSpacing: 8.0,
                  children: data.data.documents.map((item) {
                        
                    return new Wrap(children: <Widget>[
                      GestureDetector(
                        child: CircularPercentIndicator(
                          radius: 90.0,
                          lineWidth: 10.0,
                          animation: true,
                          percent: me.verificarNumero(item.data['porcentaje']),
                          center: new Text(
                            me
                                    .formatearNumero(
                                        item.data['porcentaje'] * 100)
                                    .output
                                    .nonSymbol
                                    .toString() +
                                '%',
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14.0),
                          ),
                          header: Text(
                            me.mayuscula(
                                item.data['rubro'].toString().toLowerCase()),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          footer: new Text(
                            me
                                .formatearNumero(item.data['ejecucion'])
                                .output
                                .withoutFractionDigits
                                .toString(),
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10.0),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.blue,
                        ),
                        onTap: () {
                          setState(() {
                             // rubro=item.data['rubro'];
                          });
                        },
                      )
                    ]);
                  }).toList()),
            ]);
          },
        )
      ],
    );
  }
}
