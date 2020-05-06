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
  StreamSubscription<QuerySnapshot> noteSubSede;
  CloudService cloud = new CloudService();
  Future<List<dynamic>> datos;
  Future<List<dynamic>> datosVilla;
  Future<List<dynamic>> datosSede;
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
    red = 'TOTAL';
    listar();
    listarFecha();
    listarSedeCentral();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: <Widget>[
        _builCombo(context),
        SizedBox(height: 10),
        linear(context),
        circular(context),
        Text('', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        detalle(context),
        SizedBox(
          height: 15,
        ),
        circularSede(context),
        SizedBox(height: 20)
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
    noteSub = cloud.listarDatos('Covid').listen((QuerySnapshot snapshot) {
      snapshot.documents.map((f) {
        f.data.values.map((d) {
          aux.add(d);
        }).toList();
      }).toList();
      setState(() {
        datos = cloud.convertir(aux);
      });
    });
  }


  listarSedeCentral() async {
    noteSubSede?.cancel();
    noteSubSede =
        cloud.listarDatos('covid-sede').listen((QuerySnapshot snapshot) {
      List<dynamic> aux = new List();
      snapshot.documents.map((f) {
        aux.add(f);
      }).toList();
      setState(() {
        datosSede = cloud.convertir(aux);
      });
    });
  }

  Widget _builCombo(context) {
    List<dynamic> prueba = new List();
    return FutureBuilder(
        future: datos,
        builder: (BuildContext context, AsyncSnapshot data) {
          if (!data.hasData) {
            return Center(child: new CircularProgressIndicator());
          }
          prueba = data.data.where((f) => f['fecha'] == fecha).toList();
          prueba.sort(
              (a, b) => a['red'].toString().compareTo(b['red'].toString()));
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
              items: prueba.map((dynamic valor) {
                return DropdownMenuItem<String>(
                  value: valor['red'],
                  child: Text(
                    valor['red'],
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                );
              }).toList());
        });
  }

  Widget linear(context) {
    List<dynamic> prueba = new List();
    List<TimeSeriesSales> data2 = new List();
    List<TimeSeriesSales> data3 = new List();
    List<TimeSeriesSales> data4 = new List();
    final simpleCurrencyFormatter =
        new charts.BasicNumericTickFormatterSpec.fromNumberFormat(
            new NumberFormat.compact());
    return FutureBuilder(
        future: datos,
        builder: (BuildContext context, AsyncSnapshot data) {
          if (!data.hasData) {
            return Center(child: new CircularProgressIndicator());
          }
          seriesList = new List<charts.Series<TimeSeriesSales, DateTime>>();
          prueba = data.data.where((f) => f['red'] == red).toList();
          prueba.sort(
              (a, b) => a['fecha'].toString().compareTo(b['fecha'].toString()));
          prueba
              .map((f) => {
                    data2.add(TimeSeriesSales(
                        (f['fecha'] as Timestamp).toDate(), f['liberado'])),
                    data3.add(TimeSeriesSales(
                        (f['fecha'] as Timestamp).toDate(), f['ejecucion'])),
                    data4.add(TimeSeriesSales(
                        (f['fecha'] as Timestamp).toDate(), f['pedido']))
                  })
              .toList();
          seriesList.add(charts.Series<TimeSeriesSales, DateTime>(
            id: 'Cargado',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (TimeSeriesSales sales, _) => sales.time,
            measureFn: (TimeSeriesSales sales, _) => sales.sales,
            measureLowerBoundFn: (TimeSeriesSales sales, _) => sales.sales - 5,
            measureUpperBoundFn: (TimeSeriesSales sales, _) => sales.sales + 5,
            data: data2,
          ));
          seriesList.add(charts.Series<TimeSeriesSales, DateTime>(
            id: 'Pedidos',
            colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
            domainFn: (TimeSeriesSales sales, _) => sales.time,
            measureFn: (TimeSeriesSales sales, _) => sales.sales,
            measureLowerBoundFn: (TimeSeriesSales sales, _) => sales.sales - 5,
            measureUpperBoundFn: (TimeSeriesSales sales, _) => sales.sales + 5,
            data: data4,
          ));
          seriesList.add(charts.Series<TimeSeriesSales, DateTime>(
            id: 'Ejecutado',
            colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
            domainFn: (TimeSeriesSales sales, _) => sales.time,
            measureFn: (TimeSeriesSales sales, _) => sales.sales,
            measureLowerBoundFn: (TimeSeriesSales sales, _) => sales.sales - 5,
            measureUpperBoundFn: (TimeSeriesSales sales, _) => sales.sales + 5,
            data: data3,
          ));

          return LayoutBuilder(builder: (context, constraints) {
            return ConstrainedBox(
                constraints: BoxConstraints.expand(height: 350.0),
                child: IntrinsicHeight(
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                      SizedBox(height: 10),
                      SizedBox(height: 10),
                      Text(red,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: new charts.TimeSeriesChart(
                                seriesList,
                                animate: true,
                                animationDuration: Duration(seconds: 2),
                                primaryMeasureAxis: new charts.NumericAxisSpec(
                                    tickFormatterSpec: simpleCurrencyFormatter),
                                defaultRenderer: new charts.LineRendererConfig(
                                    includePoints: true),
                                behaviors: [
                                  new charts.SeriesLegend(
                                    position: charts.BehaviorPosition.bottom,
                                    horizontalFirst: false,
                                    cellPadding: new EdgeInsets.only(
                                        right: 4.0, bottom: 4.0),
                                    showMeasures: true,
                                  ),
                                  new charts.ChartTitle('Fecha',
                                      behaviorPosition:
                                          charts.BehaviorPosition.bottom,
                                      titleOutsideJustification: charts
                                          .OutsideJustification.middleDrawArea),
                                ],
                                dateTimeFactory:
                                    const charts.LocalDateTimeFactory(),
                              ))),
                                        SizedBox(height: 10),
          Text('al ' +form.format(fecha.toDate()),style: TextStyle(color: Colors.grey,fontSize: 18)),
        SizedBox(height: 10),
                    ])));
          });
        });
  }

  Widget circular(context) {
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
              .where((f) => f['red'] == red && f['fecha'] == fecha)
              .toList();
          seriesListCircular = new List<charts.Series<LinearSales, String>>();

          prueba
              .map((f) => {
                    presupuestoCargado = f['liberado'],
                    data2.add(new LinearSales(
                        'Ejecu',
                        (f['ejecucion'] / f['liberado']) * 100,
                        Colors.pinkAccent)),
                    data2.add(new LinearSales(
                        'Saldo',
                        (f['saldoLiberado'] / f['liberado']) * 100,
                        Colors.limeAccent)),
                    data2.add(new LinearSales('SolPed',
                        (f['solped'] / f['liberado']) * 100, Colors.redAccent)),
                    data2.add(new LinearSales(
                        'Reser',
                        (f['reserva'] / f['liberado']) * 100,
                        Colors.greenAccent)),
                    data2.add(new LinearSales('Pedi',
                        (f['pedido'] / f['liberado']) * 100, Colors.blueAccent))
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
              constraints: BoxConstraints.expand(height: 400.0),
              child: IntrinsicHeight(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                      child: Text('Presupuesto Cargado',
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
                          height: 300,
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

  Widget detalle(context) {
    List<dynamic> prueba = new List();
    return FutureBuilder(
        future: datos,
        builder: (BuildContext context, AsyncSnapshot data) {
          if (!data.hasData) {
            return Center(child: new CircularProgressIndicator());
          }
          prueba = data.data
              .where((f) => f['red'] == red && f['fecha'] == fecha)
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
                                        prueba[0]['liberado']) *
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
                                .formatearNumero(((prueba[0]['solped'] /
                                        prueba[0]['liberado']) *
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
                                .formatearNumero(((prueba[0]['pedido'] /
                                        prueba[0]['liberado']) *
                                    100))
                                .output
                                .compactNonSymbol +
                            '%'))
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Reservas')),
                        DataCell(Text(me
                            .formatearNumero((prueba[0]['reserva']))
                            .output
                            .withoutFractionDigits)),
                        DataCell(Text(me
                                .formatearNumero(((prueba[0]['reserva'] /
                                        prueba[0]['liberado']) *
                                    100))
                                .output
                                .compactNonSymbol +
                            '%'))
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Saldo')),
                        DataCell(Text(me
                            .formatearNumero((prueba[0]['saldoLiberado']))
                            .output
                            .withoutFractionDigits)),
                        DataCell(Text(me
                                .formatearNumero(((prueba[0]['saldoLiberado'] /
                                        prueba[0]['liberado']) *
                                    100))
                                .output
                                .compactNonSymbol +
                            '%'))
                      ]),
                    ],
                    sortColumnIndex: 2,
                    sortAscending: false,
                  )));
        });
  }

  Widget circularSede(context) {
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
                                            Colors.pinkAccent))
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

  LinearSales(this.year, this.sales, Color color,)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
class LinearSalesRubro {
  final String year;
  final double sales;
  final String rubro;
  final charts.Color color;
  
  LinearSalesRubro(this.year, this.sales,this.rubro, Color color,)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
