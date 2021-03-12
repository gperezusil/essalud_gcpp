import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gcpp_essalud/src/pages/covid.dart';
import 'package:gcpp_essalud/src/services/firestore.dart';
import 'package:gcpp_essalud/src/util/metodos.dart';
import 'package:intl/intl.dart';

class SuspensionPerfectaPage2021 extends StatefulWidget {
  @override
  _SuspensionPerfectaPage2021State createState() =>
      _SuspensionPerfectaPage2021State();
}

class _SuspensionPerfectaPage2021State
    extends State<SuspensionPerfectaPage2021> {
  StreamSubscription<QuerySnapshot> noteSub;
  StreamSubscription<QuerySnapshot> noteSubFecha;
  List<charts.Series<LinearSales, String>> seriesTotal;
  List<charts.Series<LinearSales, String>> seriesEquipamiento;
  List<charts.Series<LinearSales, String>> seriesInsumos;
  List<charts.Series<LinearSales, String>> seriesServicios;
  List<charts.Series<LinearSales, String>> seriesMedicinas;
  Metodos me = new Metodos();
  final form = new DateFormat('dd/MM/yyyy');
  Timestamp fecha;
  CloudService cloud = new CloudService();
  Future<List<dynamic>> datos;

  @override
  void initState() {
    super.initState();
    listarFecha();
    listar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('DU N°038-2020 - DS N° 128-2020-EF')),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            circularOperativo(context),
          ],
        )));
  }

  listar() async {
    noteSub?.cancel();
    List<dynamic> aux = new List();
    noteSub = cloud
        .listarTransferencia2021('002628')
        .listen((QuerySnapshot snapshot) {
      snapshot.documents.map((f) {
        aux.add(f);
      }).toList();
      setState(() {
        datos = cloud.convertir(aux);
      });
    });
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

  Widget circularOperativo(context) {
    List<dynamic> prueba = new List();
    dynamic presupuestoCargado;
    List<LinearSales> data2 = new List();
    return FutureBuilder(
        future: datos,
        builder: (BuildContext context, AsyncSnapshot data) {
          if (!data.hasData) {
            return Center(child: new CircularProgressIndicator());
          }
          prueba = data.data
              .where((f) =>
                  f['bien'] == 'SUSPENSION PERFECTA' && f['fecha'] == fecha)
              .toList();
          seriesTotal = new List<charts.Series<LinearSales, String>>();

          prueba
              .map((f) => {
                    presupuestoCargado = f['pim'],
                    if (f['ejecucion'] / f['pim'] > 0)
                      {
                        data2.add(new LinearSales(
                            'Ejecu', f['ejecucion'], Colors.orangeAccent)),
                      },
                    if (f['solped'] / f['pim'] > 0)
                      {
                        data2.add(new LinearSales(
                            'SolPed', f['solped'], Colors.redAccent)),
                      },
                    if (f['pedido'] / f['pim'] > 0)
                      {
                        data2.add(new LinearSales(
                            'Pedi', f['pedido'], Colors.blueAccent)),
                      },
                    if (f['reservas'] / f['pim'] > 0)
                      {
                        data2.add(new LinearSales(
                            'Reser', f['reservas'], Colors.greenAccent)),
                      }
                  })
              .toList();

          seriesTotal.add(charts.Series<LinearSales, String>(
              id: 'Sales',
              domainFn: (LinearSales sales, _) => sales.year,
              measureFn: (LinearSales sales, _) => sales.sales,
              colorFn: (LinearSales sales, __) => sales.color,
              data: data2,
              // Set a label accessor to control the text of the arc label.
              labelAccessorFn: (LinearSales row, _) =>
                  '${me.formatearNumero((row.sales / presupuestoCargado) * 100).output.compactNonSymbol}%'));
          return ConstrainedBox(
              constraints: BoxConstraints.expand(height: 400.0),
              child: IntrinsicHeight(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                      child: Text('SUSPENSION PERFECTA',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                  SizedBox(height: 5),
                  Center(
                      child: Text(
                          me
                              .formatearNumero(presupuestoCargado)
                              .output
                              .withoutFractionDigits,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold))),
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      form.format(fecha.toDate()),
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                      child: Container(
                          height: 250,
                          child: charts.PieChart(
                            seriesTotal,
                            animate: true,
                            animationDuration: Duration(seconds: 2),
                            behaviors: [
                              new charts.DatumLegend(
                                showMeasures: true,
                                horizontalFirst: false,
                                outsideJustification:
                                    charts.OutsideJustification.middleDrawArea,
                                desiredMaxRows: 2,
                                entryTextStyle: charts.TextStyleSpec(),
                                legendDefaultMeasure:
                                    charts.LegendDefaultMeasure.firstValue,
                                measureFormatter: (num value) {
                                  return value == null
                                      ? '-'
                                      : '${me.formatearNumero(value).output.withoutFractionDigits}';
                                },
                                position: charts.BehaviorPosition.bottom,
                                cellPadding: EdgeInsets.all(5.0),
                              )
                            ],
                            defaultRenderer: new charts.ArcRendererConfig(
                                arcWidth: 70,
                                arcRendererDecorators: [
                                  new charts.ArcLabelDecorator(
                                      labelPosition:
                                          charts.ArcLabelPosition.auto,
                                      labelPadding: 5,
                                      showLeaderLines: true,
                                      outsideLabelStyleSpec:
                                          new charts.TextStyleSpec(
                                              fontSize: 16,
                                              color: charts.Color.fromHex(
                                                  code: "#000000")),
                                      insideLabelStyleSpec:
                                          new charts.TextStyleSpec(
                                              fontSize: 16,
                                              color: charts.Color.fromHex(
                                                  code: "#000000")))
                                ]),
                          )))
                ],
              )));
        });
  }
}
