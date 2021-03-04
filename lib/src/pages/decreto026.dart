import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gcpp_essalud/src/services/firestore.dart';
import 'package:gcpp_essalud/src/util/metodos.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Decreto026Page extends StatefulWidget {
  @override
  _Decreto026PageState createState() => _Decreto026PageState();
}

class _Decreto026PageState extends State<Decreto026Page> {
  StreamSubscription<QuerySnapshot> noteSub;
  StreamSubscription<QuerySnapshot> noteSubFecha;
  Future<List<dynamic>> datos;
  List<dynamic> prueba = new List();
  CloudService cloud = new CloudService();
  Timestamp fecha;
  Metodos me = new Metodos();

  @override
  void initState() {
    super.initState();
    listarFecha();
    listar();
  }

  listarFecha() async {
    noteSubFecha?.cancel();
    noteSubFecha = cloud
        .listarDatos('Configuracion-fecha')
        .listen((QuerySnapshot snapshot) {
      snapshot.documents.map((f) {
        if (f.data['estado']) {
          fecha = f.data['fecha'];
        }
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DU N°026-2020'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: datos,
          builder: (BuildContext context, AsyncSnapshot data) {
            if (!data.hasData) {
              return Text('Cargando Informacion');
            }
            prueba = data.data.where((f) => f['fecha'] == fecha).toList();
            return Center(
              child: Container(
                  child: Column(
                      children: prueba.map((item) {
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    new CircularPercentIndicator(
                      radius: 200,
                      lineWidth: 20.0,
                      animation: true,
                      percent:
                          me.verificarNumero2(item['ejecucion'] / item['pim']),
                      center: new Text(
                        me
                                .formatearNumero(
                                    (item['ejecucion'] / item['pim']) * 100)
                                .output
                                .nonSymbol
                                .toString() +
                            '%',
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30.0),
                      ),
                      header: Text('Subsidio por Incapacidad Temporal',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          )),
                      footer: new Text(
                        me
                            .formatearNumero(
                                double.parse(item['ejecucion'].toString()))
                            .output
                            .withoutFractionDigits
                            .toString(),
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                    SizedBox(height: 5),
                    Text(
                      me
                          .formatearNumero(double.parse(item['pim'].toString()))
                          .output
                          .withoutFractionDigits
                          .toString(),
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                  ],
                );
              }).toList())),
            );
          },
        ),
      ),
    );
  }

  listar() async {
    noteSub?.cancel();
    List<dynamic> aux = new List();
    noteSub =
        cloud.listarTransferencia('002627').listen((QuerySnapshot snapshot) {
      snapshot.documents.map((f) {
        aux.add(f);
      }).toList();
      setState(() {
        datos = cloud.convertir(aux);
      });
    });
  }
}
