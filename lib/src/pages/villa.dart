import 'dart:async';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:gcpp_essalud/src/pages/covid.dart';
import 'package:gcpp_essalud/src/services/firestore.dart';
import 'package:gcpp_essalud/src/util/metodos.dart';
class VillaPanamericanaPage extends StatefulWidget {
  VillaPanamericanaPage({Key key}) : super(key: key);

  @override
  _VillaPanamericanaPageState createState() => _VillaPanamericanaPageState();
}

class _VillaPanamericanaPageState extends State<VillaPanamericanaPage> {
  CloudService cloud = new CloudService();
  Metodos me = new Metodos();
   List<charts.Series<TimeSeriesSales, DateTime>> seriesVillaPanamericana;
   List<charts.Series<LinearSales, String>> seriesListCircularVilla;
   Future<List<dynamic>> datosVilla;
   StreamSubscription<QuerySnapshot> noteSubVilla;
   StreamSubscription<QuerySnapshot> noteSubFecha;
   Timestamp fecha;
   final form = new DateFormat('dd/MM/yyyy');
   double presupuestoCargado;

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


     listarVilla() async {
    noteSubVilla?.cancel();
    List<dynamic> aux = new List();
    noteSubVilla = cloud.listarDatos('Villa').listen((QuerySnapshot snapshot) {
      snapshot.documents.map((f) {
        f.data.values.map((d) {
          aux.add(d);
        }).toList();
      }).toList();
      setState(() {
        datosVilla = cloud.convertir(aux);
      });
    });
  }
  @override
  void initState() {
    super.initState();
    listarFecha();
    listarVilla();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Container(
         child: _villaDeportiva(context),
      ),
    );
  }


  _villaDeportiva(context) {
    return Padding(
          padding:EdgeInsets.only(top: 10) ,
          child: Container(
        child: Column(
          children: [
            Text('Etapa 1',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            linearVilla(context),
            SizedBox(height: 15),
            circular(context),
             SizedBox(height: 15),
            detalle(context)
          ],
        ),
      ),
    );
  }

  Widget linearVilla(context) {
    List<dynamic> prueba = new List();
    List<TimeSeriesSales> data2 = new List();
    List<TimeSeriesSales> data3 = new List();
    List<TimeSeriesSales> data4 = new List();
    final simpleCurrencyFormatter =
        new charts.BasicNumericTickFormatterSpec.fromNumberFormat(
            new NumberFormat.compact());
    return FutureBuilder(
        future: datosVilla,
        builder: (BuildContext context, AsyncSnapshot data) {
          if (!data.hasData) {
            return Center(child: new CircularProgressIndicator());
          }
          if(data.connectionState!=ConnectionState.waiting){
                        seriesVillaPanamericana =
              new List<charts.Series<TimeSeriesSales, DateTime>>();
          prueba = data.data.where((f) => f['red'] == 'TOTAL').toList();
          prueba.sort((a, b) =>
              a['fechaVilla'].toString().compareTo(b['fechaVilla'].toString()));
          prueba
              .map((f) => {
                    data2.add(TimeSeriesSales(
                        (f['fechaVilla'] as Timestamp).toDate(),
                        double.parse(f['liberado'].toString()))),
                    data3.add(TimeSeriesSales(
                        (f['fechaVilla'] as Timestamp).toDate(),
                        double.parse(f['ejecucion'].toString()))),
                    data4.add(TimeSeriesSales(
                        (f['fechaVilla'] as Timestamp).toDate(), 
                        double.parse(f['pedido'].toString())))
                  })
              .toList();
          seriesVillaPanamericana.add(charts.Series<TimeSeriesSales, DateTime>(
            id: 'Cargado',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (TimeSeriesSales sales, _) => sales.time,
            measureFn: (TimeSeriesSales sales, _) => sales.sales,
            measureLowerBoundFn: (TimeSeriesSales sales, _) => sales.sales - 5,
            measureUpperBoundFn: (TimeSeriesSales sales, _) => sales.sales + 5,
            data: data2,
          ));
          seriesVillaPanamericana.add(charts.Series<TimeSeriesSales, DateTime>(
            id: 'Pedidos',
            colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
            domainFn: (TimeSeriesSales sales, _) => sales.time,
            measureFn: (TimeSeriesSales sales, _) => sales.sales,
            measureLowerBoundFn: (TimeSeriesSales sales, _) => sales.sales - 5,
            measureUpperBoundFn: (TimeSeriesSales sales, _) => sales.sales + 5,
            data: data4,
          ));
          seriesVillaPanamericana.add(charts.Series<TimeSeriesSales, DateTime>(
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
                                       
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: new charts.TimeSeriesChart(
                                seriesVillaPanamericana,
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
                                      showMeasures: true),
                                  new charts.ChartTitle('Fecha',
                                      behaviorPosition:
                                          charts.BehaviorPosition.bottom,
                                      titleOutsideJustification: charts
                                          .OutsideJustification.middleDrawArea),
                                ],
                                dateTimeFactory:
                                    const charts.LocalDateTimeFactory(),
                              )))
                    ])));
          });
          }
          return SizedBox(height: 1);
        });
  }
  
  Widget circular(context) {
    List<dynamic> prueba = new List();
    dynamic presupuestoCargado;
    List<LinearSales> data2 = new List();
    return FutureBuilder(
        future: datosVilla,
        builder: (BuildContext context, AsyncSnapshot data) {
          if (!data.hasData) {
            return Center(child: new CircularProgressIndicator());
          }
          prueba = data.data
              .where((f) => f['red'] == 'TOTAL' && f['fechaVilla'] == fecha)
              .toList();
          seriesListCircularVilla = new List<charts.Series<LinearSales, String>>();

          prueba
              .map((f) => {
                    presupuestoCargado = f['liberado'],
                    data2.add(new LinearSales(
                        'Ejecu',
                        (f['ejecucion'] / f['liberado']) * 100,
                        Colors.pinkAccent)),
                   
                   
                    data2.add(new LinearSales(
                        'Reser',
                        (f['reserva'] / f['liberado']) * 100,
                        Colors.greenAccent)),
                         data2.add(new LinearSales(
                        'Saldo',
                        (f['saldoLiberado'] / f['liberado']) * 100,
                        Colors.limeAccent)),
                    data2.add(new LinearSales('Pedi',
                        (f['pedido'] / f['liberado']) * 100, Colors.blueAccent)),
                        
                         data2.add(new LinearSales('SolPed',
                        (f['solped'] / f['liberado']) * 100, Colors.redAccent)),
                  })
              .toList();

          seriesListCircularVilla.add(charts.Series<LinearSales, String>(
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
                               SizedBox(height: 5),
                               Center(
                   child:Text('al ' +form.format(fecha.toDate()),
                        style: TextStyle(color: Colors.grey,fontSize: 18))),

                  SizedBox(height: 10),
                  Expanded(
                      child: Container(
                          height: 300,
                          child: charts.PieChart(
                            seriesListCircularVilla,
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
        future: datosVilla,
        builder: (BuildContext context, AsyncSnapshot data) {
          if (!data.hasData) {
            return Center(child: new CircularProgressIndicator());
          }
          prueba = data.data
              .where((f) => f['red'] == 'TOTAL' && f['fechaVilla'] == fecha)
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

}