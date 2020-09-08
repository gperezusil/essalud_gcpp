import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gcpp_essalud/src/pages/covid.dart';
import 'package:gcpp_essalud/src/services/firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:gcpp_essalud/src/util/metodos.dart';

class DecretoPage extends StatefulWidget {
  final String decreto;
  const DecretoPage({Key key, this.decreto}) : super(key: key);

    static Route<dynamic> route(d) {
    return MaterialPageRoute(
      builder: (context) => DecretoPage(decreto: d),
    );
  }
  @override
  _DecretoPageState createState() => _DecretoPageState();
}

class _DecretoPageState extends State<DecretoPage> {
  StreamSubscription<QuerySnapshot> noteSub;
  StreamSubscription<QuerySnapshot> noteSubFecha;
  List<charts.Series<LinearSales, String>> seriesTotal;
  List<charts.Series<LinearSales, String>> seriesEquipamiento;
  Metodos me = new Metodos();
  Timestamp fecha;
  CloudService cloud = new CloudService();
  Future<List<dynamic>> datos;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.decreto)),
      body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            SizedBox(height: 10),
      circularOperativo(context),
      SizedBox(height: 10),
      detalle(context),
      SizedBox(height: 20),
      circularEquipamiento(context)
          ],
        ))
    );
  }
  @override
  void initState() { 
    super.initState();
    listarFecha();
    listar();
  }

  listar() async {
    noteSub?.cancel();
    List<dynamic> aux = new List();
    noteSub = cloud.listarDatos(widget.decreto).listen((QuerySnapshot snapshot) {
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
                  f['red'] == 'TOTAL' &&
                  f['fecha'] == fecha )
              .toList();
          seriesTotal = new List<charts.Series<LinearSales, String>>();

          prueba
              .map((f) => {
                    presupuestoCargado = f['pim'],
                    data2.add(new LinearSales('Ejecu',
                        (f['ejecucion'] / f['pim']) * 100, Colors.purple)),
                    data2.add(new LinearSales('SolPed',
                        (f['solped'] / f['pim']) * 100, Colors.redAccent)),
                    data2.add(new LinearSales('Reser',
                        (f['reservas'] / f['pim']) * 100, Colors.greenAccent)),
                    data2.add(new LinearSales('Pedi',
                        (f['pedido'] / f['pim']) * 100, Colors.blueAccent))
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
                  '${row.year}:${me.formatearNumero(row.sales).output.compactNonSymbol}%'));
          return ConstrainedBox(
              constraints: BoxConstraints.expand(height: 300.0),
              child: IntrinsicHeight(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                      child: Text('TOTAL',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                  Center(
                      child: Text(
                          me
                              .formatearNumero(presupuestoCargado)
                              .output
                              .withoutFractionDigits,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
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
                                position: charts.BehaviorPosition.bottom,
                                cellPadding: EdgeInsets.all(5.0),
                              )
                            ],
                            defaultRenderer: new charts.ArcRendererConfig(
                                arcWidth: 80,
                                arcRendererDecorators: [
                                  new charts.ArcLabelDecorator(
                                      labelPosition:
                                          charts.ArcLabelPosition.auto,
                                      insideLabelStyleSpec:
                                          new charts.TextStyleSpec(
                                              fontSize: 11,
                                              color: charts.Color.fromHex(
                                                  code: "#000000")))
                                ]),
                          )))
                ],
              )));
        });
  }

    Widget circularEquipamiento(context) {
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
                  f['red'] == 'EQUIPAMIENTO' &&
                  f['fecha'] == fecha )
              .toList();
          seriesEquipamiento = new List<charts.Series<LinearSales, String>>();

          prueba
              .map((f) => {
                    presupuestoCargado = f['pim'],
                    data2.add(new LinearSales('Ejecu',
                        (f['ejecucion'] / f['pim']) * 100, Colors.purple)),
                    data2.add(new LinearSales('SolPed',
                        (f['solped'] / f['pim']) * 100, Colors.redAccent)),
                    data2.add(new LinearSales('Reser',
                        (f['reservas'] / f['pim']) * 100, Colors.greenAccent)),
                    data2.add(new LinearSales('Pedi',
                        (f['pedido'] / f['pim']) * 100, Colors.blueAccent))
                  })
              .toList();

          seriesEquipamiento.add(charts.Series<LinearSales, String>(
              id: 'Sales',
              domainFn: (LinearSales sales, _) => sales.year,
              measureFn: (LinearSales sales, _) => sales.sales,
              colorFn: (LinearSales sales, __) => sales.color,
              data: data2,
              // Set a label accessor to control the text of the arc label.
              labelAccessorFn: (LinearSales row, _) =>
                  '${row.year}:${me.formatearNumero(row.sales).output.compactNonSymbol}%'));
          return ConstrainedBox(
              constraints: BoxConstraints.expand(height: 200.0),
              child: IntrinsicHeight(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                      child: Text('EQUIPAMIENTO',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                  Center(
                      child: Text(
                          me
                              .formatearNumero(presupuestoCargado)
                              .output
                              .withoutFractionDigits,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                  SizedBox(height: 10),
                  Expanded(
                      child: Container(
                          height: 150,
                          child: charts.PieChart(
                            seriesEquipamiento,
                            animate: true,
                            animationDuration: Duration(seconds: 2),
                            behaviors: [
                              new charts.DatumLegend(
                                position: charts.BehaviorPosition.end,
                                cellPadding: EdgeInsets.all(5.0),
                              )
                            ],
                            defaultRenderer: new charts.ArcRendererConfig(
                                arcWidth: 80,
                                arcRendererDecorators: [
                                  new charts.ArcLabelDecorator(
                                      labelPosition:
                                          charts.ArcLabelPosition.auto,
                                      insideLabelStyleSpec:
                                          new charts.TextStyleSpec(
                                              fontSize: 11,
                                              color: charts.Color.fromHex(
                                                  code: "#000000")))
                                ]),
                          )))
                ],
              )));
        });
  }
    Widget detalle(context) {
    List<dynamic> prueba = new List();
    return FutureBuilder(
        future: datos,
        builder: (BuildContext context, AsyncSnapshot data) {
          if (!data.hasData) {
            return Center(child: new CircularProgressIndicator());
          }
          prueba = data.data
              .where((f) =>
                  f['red'] == 'TOTAL' &&
                  f['fecha'] == fecha )
              .toList();

          return Container(
              color: Colors.white,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(
                          label: Text("Compromiso",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text("Monto",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text("%",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text('Ejecucion')),
                        DataCell(Text(me
                            .formatearNumero((prueba[0]['ejecucion']))
                            .output
                            .withoutFractionDigits)),
                        DataCell(Text(me
                                .formatearNumero(((prueba[0]['ejecucion'] /
                                        prueba[0]['pim']) *
                                    100))
                                .output
                                .compactNonSymbol +
                            '%')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('SolPed')),
                        DataCell(Text(me
                            .formatearNumero((prueba[0]['solped']))
                            .output
                            .withoutFractionDigits)),
                        DataCell(Text(me
                                .formatearNumero(
                                    ((prueba[0]['solped'] / prueba[0]['pim']) *
                                        100))
                                .output
                                .compactNonSymbol +
                            '%')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Pedidos')),
                        DataCell(Text(me
                            .formatearNumero((prueba[0]['pedido']))
                            .output
                            .withoutFractionDigits)),
                        DataCell(Text(me
                                .formatearNumero(
                                    ((prueba[0]['pedido'] / prueba[0]['pim']) *
                                        100))
                                .output
                                .compactNonSymbol +
                            '%'))
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Reservas')),
                        DataCell(Text(me
                            .formatearNumero((prueba[0]['reservas']))
                            .output
                            .withoutFractionDigits)),
                        DataCell(Text(me
                                .formatearNumero(((prueba[0]['reservas'] /
                                        prueba[0]['pim']) *
                                    100))
                                .output
                                .compactNonSymbol +
                            '%'))
                      ])
                    ],
                    sortColumnIndex: 2,
                    sortAscending: false,
                  )));
        });
  }
  
}
