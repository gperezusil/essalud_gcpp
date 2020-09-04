import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gcpp_essalud/src/modelos/redes.dart';
import 'package:gcpp_essalud/src/services/firestore.dart';
import 'package:gcpp_essalud/src/util/metodos.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class CovidPage extends StatefulWidget {
  @override
  _CovidPageState createState() => _CovidPageState();
}

class _CovidPageState extends State<CovidPage> {
  List<charts.Series<TimeSeriesSales, DateTime>> seriesList;
  List<charts.Series<LinearSales, String>> seriesListCircular;
  List<charts.Series<LinearSales, String>> seriesListCircularSede;
  final form = new DateFormat('dd/MM/yyyy');
  StreamSubscription<QuerySnapshot> noteSub;
  StreamSubscription<QuerySnapshot> noteSubFecha;
  CloudService cloud = new CloudService();
  Future<List<dynamic>> datos;
  Future<List<dynamic>> datosVilla;
  String red;
  Timestamp fecha;
  bool animate;
  Metodos me = new Metodos();
  Redes buscarDireccion;
  Widget wid;
  var data;

  @override
  void initState() {
    super.initState();
    listarFecha();
    listar();
    red = 'TOTAL';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: <Widget>[
        _builCombo(context),
        SizedBox(height: 10),
        Center(
            child: Text(
          red,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        )),
        SizedBox(height: 20),
        circularOperativo(context),
        SizedBox(height: 20),
        detalle(context),
        SizedBox(height: 20),
        circularCapital(context),
        SizedBox(height: 20),
        detalleCapital(context),
      ],
    )));
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

  listar() async {
    noteSub?.cancel();
    List<dynamic> aux = new List();
    noteSub = cloud.listarDatos('Covid-red').listen((QuerySnapshot snapshot) {
      snapshot.documents.map((f) {
        print(f.data);
        aux.add(f);
      }).toList();
      setState(() {
        datos = cloud.convertir(aux);
      });
    });
  }

  Widget _builCombo(context) {
    me.redescompleto.sort((a, b) => a.toString().compareTo(b.toString()));
    return DropdownButton(
        hint: Text("Seleccione Red"),
        value: red,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.black, fontSize: 15),
        onChanged: (String ge) {
          setState(() {
            red = ge;
          });
        },
        items: me.redescompleto.map((String valor) {
          return DropdownMenuItem<String>(
            value: valor,
            child: Text(
              valor,
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          );
        }).toList());
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
                  f['red'] == red &&
                  f['fecha'] == fecha &&
                  f['tipo'] == 'GASTO OPERATIVO')
              .toList();
          seriesListCircular = new List<charts.Series<LinearSales, String>>();

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

          seriesListCircular.add(charts.Series<LinearSales, String>(
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
                      child: Text('Gasto Operativo',
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
                            seriesListCircular,
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

  Widget circularCapital(context) {
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
                  f['red'] == red &&
                  f['fecha'] == fecha &&
                  f['tipo'] == 'GASTO CAPITAL')
              .toList();
          seriesListCircularSede =
              new List<charts.Series<LinearSales, String>>();

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

          seriesListCircularSede.add(charts.Series<LinearSales, String>(
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
                      child: Text('Gasto Capital',
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
                            seriesListCircularSede,
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
                  f['red'] == red &&
                  f['fecha'] == fecha &&
                  f['tipo'] == 'GASTO OPERATIVO')
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

  Widget detalleCapital(context) {
    List<dynamic> prueba = new List();
    return FutureBuilder(
        future: datos,
        builder: (BuildContext context, AsyncSnapshot data) {
          if (!data.hasData) {
            return Center(child: new CircularProgressIndicator());
          }
          prueba = data.data
              .where((f) =>
                  f['red'] == red &&
                  f['fecha'] == fecha &&
                  f['tipo'] == 'GASTO CAPITAL')
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

  /* Widget circularSede(context) {
    if(red=='SEDE CENTRAL'){
    List<dynamic> prueba = new List();
    List<LinearSales> data2 = new List();
    return ConstrainedBox(
        constraints: BoxConstraints.expand(height: 500.0),
        child: IntrinsicHeight(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
                child: Text('Gerencias Sede Central',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            SizedBox(height: 10),
            Expanded(
                child: Container(
                    height: 250,
                    child: FutureBuilder(
                      future: datosSede,
                      builder: (BuildContext context, AsyncSnapshot data) {
                        if (!data.hasData) {
                          return Text('Cargando Informacion');
                        } else if (data.connectionState !=
                            ConnectionState.waiting) {
                          prueba = data.data
                              .where((f) => f['fecha'] == fecha)
                              .toList();
                          seriesListCircularSede =
                              new List<charts.Series<LinearSales, String>>();
                          prueba
                              .map((f) => {
                                    if (f['gerencia'] == 'GOF')
                                      {
                                        data2.add(new LinearSales(
                                            f['gerencia'],
                                            (f['monto'] / f['cargado']) * 100,
                                            Colors.purple))
                                      }
                                    else if (f['gerencia'] == 'CEABE')
                                      {
                                        data2.add(new LinearSales(
                                            f['gerencia'],
                                            (f['monto'] / f['cargado']) * 100,
                                            Colors.blueAccent))
                                      }
                                    else
                                      {
                                        data2.add(new LinearSales(
                                            f['gerencia'],
                                            (f['monto'] / f['cargado']) * 100,
                                            Colors.redAccent))
                                      }
                                  })
                              .toList();
                          seriesListCircularSede.add(charts.Series<LinearSales,
                                  String>(
                              id: 'Sales',
                              domainFn: (LinearSales sales, _) => sales.year,
                              measureFn: (LinearSales sales, _) => sales.sales,
                              colorFn: (LinearSales sales, __) => sales.color,
                              data: data2,
                              // Set a label accessor to control the text of the arc label.
                              labelAccessorFn: (LinearSales row, _) =>
                                  '${row.year}:${me.formatearNumero(row.sales).output.compactNonSymbol}%'));

                          return 
                          charts.PieChart(
                            seriesListCircularSede,
                            animate: true,
                            animationDuration: Duration(seconds: 2),
                            behaviors: [
                              new charts.DatumLegend(
                                position: charts.BehaviorPosition.end,
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
                          );
                        }
                        return SizedBox(height: 1);
                      },
                    ))),
            FutureBuilder(
              future: datosSede,
                      builder: (BuildContext context, AsyncSnapshot data) {
                        if (!data.hasData) {
                          return Text('Cargando Informacion');
                        } else if (data.connectionState !=ConnectionState.waiting) {
                          prueba = data.data
                              .where((f) => f['fecha'] == fecha)
                              .toList();
            return Container(
                color: Colors.white,
                    child: DataTable(
                      columns: [
                        DataColumn(
                            label: Text("Gerencia",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Monto",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("%",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: prueba.map((f) {
                  return DataRow(cells: [
                    DataCell(Text(f['gerencia'])),
                    DataCell(Text(me
                        .formatearNumero(double.parse(f['monto'].toString()))
                        .output
                        .withoutFractionDigits
                        .toString())),
                    DataCell(Text(me
                        .formatearNumero(double.parse(f['monto'].toString())/double.parse(f['cargado'].toString())* 100)
                        .output
                        .compactNonSymbol
                        .toString()+'%')),
                  ]);
                }).toList(),
                      sortColumnIndex: 0,
                      sortAscending: true,
                    ));
                    }
                    return SizedBox(height: 1);
                    }
                    )
                    
          ],
        )));
    }
    return SizedBox(height: 1);

  }
*/

  @override
  void dispose() {
    super.dispose();
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final double sales;

  TimeSeriesSales(this.time, this.sales);
}

class OrdinalSales {
  final String year;
  final double sales;
  final String anno;

  OrdinalSales(this.year, this.sales, this.anno);
}

class LinearSales {
  final String year;
  final double sales;
  final charts.Color color;

  LinearSales(
    this.year,
    this.sales,
    Color color,
  ) : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class LinearSalesRubro {
  final String year;
  final double sales;
  final String rubro;
  final charts.Color color;

  LinearSalesRubro(
    this.year,
    this.sales,
    this.rubro,
    Color color,
  ) : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
