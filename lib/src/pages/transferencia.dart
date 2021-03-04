import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gcpp_essalud/src/pages/covid.dart';
import 'package:gcpp_essalud/src/services/firestore.dart';
import 'package:gcpp_essalud/src/util/metodos.dart';
import 'package:intl/intl.dart';

class TransferenciaPage extends StatefulWidget {
  final String fondo;
  final String descFondo;
  const TransferenciaPage({Key key, this.fondo, this.descFondo})
      : super(key: key);

  static Route<dynamic> route(d, desc) {
    return MaterialPageRoute(
      builder: (context) => TransferenciaPage(
        fondo: d,
        descFondo: desc,
      ),
    );
  }

  @override
  _TransferenciaPageState createState() => _TransferenciaPageState();
}

class _TransferenciaPageState extends State<TransferenciaPage> {
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
        appBar: AppBar(title: Text(widget.descFondo)),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            circularOperativo(context),
            SizedBox(height: 10),
            detalle(context),
            SizedBox(height: 20),
            circularMedicinas(context),
            SizedBox(height: 20),
            circularInsumos(context),
            SizedBox(height: 20),
            circularServicios(context),
            SizedBox(height: 20),
            circularrrhh(context),
            SizedBox(height: 20),
            circularEquipamiento(context),
            SizedBox(height: 20),
            circularCamillas(context),
            SizedBox(height: 20),
            circularMuebles(context),
            SizedBox(height: 20),
            circularinfraestructura(context)
          ],
        )));
  }

  listar() async {
    noteSub?.cancel();
    List<dynamic> aux = new List();
    noteSub = cloud
        .listarTransferencia(widget.fondo)
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
              .where((f) => f['bien'] == 'TOTAL' && f['fecha'] == fecha)
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
                      child: Text('TOTAL',
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
                                entryTextStyle: charts.TextStyleSpec(),
                                legendDefaultMeasure:
                                    charts.LegendDefaultMeasure.firstValue,
                                position: charts.BehaviorPosition.bottom,
                                horizontalFirst: true,
                                cellPadding: new EdgeInsets.only(
                                    right: 4.0, bottom: 4.0),
                              ),
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

  Widget detalle(context) {
    List<dynamic> prueba = new List();
    return FutureBuilder(
        future: datos,
        builder: (BuildContext context, AsyncSnapshot data) {
          if (!data.hasData) {
            return Center(child: new CircularProgressIndicator());
          }
          prueba = data.data
              .where((f) => f['bien'] == 'TOTAL' && f['fecha'] == fecha)
              .toList();

          return Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    dividerThickness: 1,
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

  Widget circularMedicinas(context) {
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
              .where((f) => f['bien'] == 'MEDICINAS' && f['fecha'] == fecha)
              .toList();
          seriesEquipamiento = new List<charts.Series<LinearSales, String>>();
          if (prueba.isEmpty) {
            return SizedBox(
              height: 0,
            );
          } else {
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

            seriesEquipamiento.add(charts.Series<LinearSales, String>(
                id: 'Sales',
                domainFn: (LinearSales sales, _) => sales.year,
                measureFn: (LinearSales sales, _) => sales.sales,
                colorFn: (LinearSales sales, __) => sales.color,
                data: data2,
                // Set a label accessor to control the text of the arc label.
                labelAccessorFn: (LinearSales row, _) =>
                    '${me.formatearNumero((row.sales / presupuestoCargado) * 100).output.compactNonSymbol}%'));
            return ConstrainedBox(
                constraints: BoxConstraints.expand(height: 300.0),
                child: IntrinsicHeight(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                        child: Text('MEDICINAS',
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
                                  showMeasures: true,
                                  horizontalFirst: false,
                                  outsideJustification: charts
                                      .OutsideJustification.middleDrawArea,
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
                                  arcWidth: 30,
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
          }
        });
  }

  Widget circularInsumos(context) {
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
                  f['bien'] == 'INSUMOS Y MATERIAL MEDICO' &&
                  f['fecha'] == fecha)
              .toList();
          seriesEquipamiento = new List<charts.Series<LinearSales, String>>();
          if (prueba.isEmpty) {
            return SizedBox(
              height: 0,
            );
          } else {
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

            seriesEquipamiento.add(charts.Series<LinearSales, String>(
                id: 'Sales',
                domainFn: (LinearSales sales, _) => sales.year,
                measureFn: (LinearSales sales, _) => sales.sales,
                colorFn: (LinearSales sales, __) => sales.color,
                data: data2,
                // Set a label accessor to control the text of the arc label.
                labelAccessorFn: (LinearSales row, _) =>
                    '${me.formatearNumero((row.sales / presupuestoCargado) * 100).output.compactNonSymbol}%'));
            return ConstrainedBox(
                constraints: BoxConstraints.expand(height: 300.0),
                child: IntrinsicHeight(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                        child: Text('INSUMOS Y MATERIAL MEDICO',
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
                                  showMeasures: true,
                                  horizontalFirst: false,
                                  outsideJustification: charts
                                      .OutsideJustification.middleDrawArea,
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
                                  arcWidth: 30,
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
          }
        });
  }

  Widget circularServicios(context) {
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
                  f['bien'] == 'SERVICIOS COMPLEMENTARIOS' &&
                  f['fecha'] == fecha)
              .toList();
          seriesEquipamiento = new List<charts.Series<LinearSales, String>>();
          if (prueba.isEmpty) {
            return SizedBox(
              height: 0,
            );
          } else {
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

            seriesEquipamiento.add(charts.Series<LinearSales, String>(
                id: 'Sales',
                domainFn: (LinearSales sales, _) => sales.year,
                measureFn: (LinearSales sales, _) => sales.sales,
                colorFn: (LinearSales sales, __) => sales.color,
                data: data2,
                // Set a label accessor to control the text of the arc label.
                labelAccessorFn: (LinearSales row, _) =>
                    '${me.formatearNumero((row.sales / presupuestoCargado) * 100).output.compactNonSymbol}%'));
            return ConstrainedBox(
                constraints: BoxConstraints.expand(height: 300.0),
                child: IntrinsicHeight(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                        child: Text('SERVICIOS COMPLEMENTARIOS',
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
                                  showMeasures: true,
                                  outsideJustification: charts
                                      .OutsideJustification.middleDrawArea,
                                  desiredMaxRows: 2,
                                  entryTextStyle: charts.TextStyleSpec(),
                                  legendDefaultMeasure:
                                      charts.LegendDefaultMeasure.firstValue,
                                  horizontalFirst: false,
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
                                  arcWidth: 30,
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
          }
        });
  }

  Widget circularrrhh(context) {
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
              .where((f) => f['bien'] == 'RRHH' && f['fecha'] == fecha)
              .toList();
          seriesEquipamiento = new List<charts.Series<LinearSales, String>>();
          if (prueba.isEmpty) {
            return SizedBox(
              height: 0,
            );
          } else {
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

            seriesEquipamiento.add(charts.Series<LinearSales, String>(
                id: 'Sales',
                domainFn: (LinearSales sales, _) => sales.year,
                measureFn: (LinearSales sales, _) => sales.sales,
                colorFn: (LinearSales sales, __) => sales.color,
                data: data2,
                // Set a label accessor to control the text of the arc label.
                labelAccessorFn: (LinearSales row, _) =>
                    '${me.formatearNumero((row.sales / presupuestoCargado) * 100).output.compactNonSymbol}%'));
            return ConstrainedBox(
                constraints: BoxConstraints.expand(height: 300.0),
                child: IntrinsicHeight(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                        child: Text('RRHH',
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
                                  showMeasures: true,
                                  outsideJustification: charts
                                      .OutsideJustification.middleDrawArea,
                                  horizontalFirst: false,
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
                                  arcWidth: 30,
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
          }
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
              .where((f) => f['bien'] == 'EQUIPAMIENTO' && f['fecha'] == fecha)
              .toList();
          seriesEquipamiento = new List<charts.Series<LinearSales, String>>();
          if (prueba.isEmpty) {
            return SizedBox(
              height: 0,
            );
          } else {
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

            seriesEquipamiento.add(charts.Series<LinearSales, String>(
                id: 'Sales',
                domainFn: (LinearSales sales, _) => sales.year,
                measureFn: (LinearSales sales, _) => sales.sales,
                colorFn: (LinearSales sales, __) => sales.color,
                data: data2,
                // Set a label accessor to control the text of the arc label.
                labelAccessorFn: (LinearSales row, _) =>
                    '${me.formatearNumero((row.sales / presupuestoCargado) * 100).output.compactNonSymbol}%'));
            return ConstrainedBox(
                constraints: BoxConstraints.expand(height: 300.0),
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
                                  showMeasures: true,
                                  horizontalFirst: false,
                                  outsideJustification: charts
                                      .OutsideJustification.middleDrawArea,
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
                                  arcWidth: 30,
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
          }
        });
  }

  Widget circularCamillas(context) {
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
              .where((f) => f['bien'] == 'CAMILLAS' && f['fecha'] == fecha)
              .toList();
          seriesEquipamiento = new List<charts.Series<LinearSales, String>>();
          if (prueba.isEmpty) {
            return SizedBox(
              height: 0,
            );
          } else {
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

            seriesEquipamiento.add(charts.Series<LinearSales, String>(
                id: 'Sales',
                domainFn: (LinearSales sales, _) => sales.year,
                measureFn: (LinearSales sales, _) => sales.sales,
                colorFn: (LinearSales sales, __) => sales.color,
                data: data2,
                // Set a label accessor to control the text of the arc label.
                labelAccessorFn: (LinearSales row, _) =>
                    '${me.formatearNumero((row.sales / presupuestoCargado) * 100).output.compactNonSymbol}%'));
            return ConstrainedBox(
                constraints: BoxConstraints.expand(height: 300.0),
                child: IntrinsicHeight(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                        child: Text('CAMILLAS',
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
                                  showMeasures: true,
                                  horizontalFirst: false,
                                  outsideJustification: charts
                                      .OutsideJustification.middleDrawArea,
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
                                  arcWidth: 30,
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
          }
        });
  }

  Widget circularMuebles(context) {
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
              .where((f) => f['bien'] == 'MUEBLES' && f['fecha'] == fecha)
              .toList();
          seriesEquipamiento = new List<charts.Series<LinearSales, String>>();
          if (prueba.isEmpty) {
            return SizedBox(
              height: 0,
            );
          } else {
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

            seriesEquipamiento.add(charts.Series<LinearSales, String>(
                id: 'Sales',
                domainFn: (LinearSales sales, _) => sales.year,
                measureFn: (LinearSales sales, _) => sales.sales,
                colorFn: (LinearSales sales, __) => sales.color,
                data: data2,
                // Set a label accessor to control the text of the arc label.
                labelAccessorFn: (LinearSales row, _) =>
                    '${me.formatearNumero((row.sales / presupuestoCargado) * 100).output.compactNonSymbol}%'));
            return ConstrainedBox(
                constraints: BoxConstraints.expand(height: 300.0),
                child: IntrinsicHeight(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                        child: Text('MUEBLES',
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
                                  showMeasures: true,
                                  horizontalFirst: false,
                                  outsideJustification: charts
                                      .OutsideJustification.middleDrawArea,
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
                                  arcWidth: 30,
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
          }
        });
  }

  Widget circularinfraestructura(context) {
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
                  f['bien'] == 'COSTO DE INFRAESTRUCTURA TEMPORAL' &&
                  f['fecha'] == fecha)
              .toList();
          seriesEquipamiento = new List<charts.Series<LinearSales, String>>();
          if (prueba.isEmpty) {
            return SizedBox(
              height: 0,
            );
          } else {
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

            seriesEquipamiento.add(charts.Series<LinearSales, String>(
                id: 'Sales',
                domainFn: (LinearSales sales, _) => sales.year,
                measureFn: (LinearSales sales, _) => sales.sales,
                colorFn: (LinearSales sales, __) => sales.color,
                data: data2,
                // Set a label accessor to control the text of the arc label.
                labelAccessorFn: (LinearSales row, _) =>
                    '${me.formatearNumero((row.sales / presupuestoCargado) * 100).output.compactNonSymbol}%'));
            return ConstrainedBox(
                constraints: BoxConstraints.expand(height: 300.0),
                child: IntrinsicHeight(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                        child: Text('COSTO DE INFRAESTRUCTURA TEMPORAL',
                            textAlign: TextAlign.center,
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
                                  showMeasures: true,
                                  horizontalFirst: false,
                                  outsideJustification: charts
                                      .OutsideJustification.middleDrawArea,
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
                                  arcWidth: 30,
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
          }
        });
  }
}
