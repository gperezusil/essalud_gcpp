import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gcpp_essalud/src/modelos/redes.dart';
import 'package:gcpp_essalud/src/services/firestore.dart';
import 'package:gcpp_essalud/src/util/metodos.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:charts_flutter/src/text_element.dart';
import 'package:charts_flutter/src/text_style.dart' as style;

class CovidPage extends StatefulWidget {
  @override
  _CovidPageState createState() => _CovidPageState();
}

class _CovidPageState extends State<CovidPage> {
  List<charts.Series<TimeSeriesSales, DateTime>> seriesList;
  List<charts.Series<LinearSales, String>> seriesListCircular;
  StreamSubscription<QuerySnapshot> noteSub;
  StreamSubscription<QuerySnapshot> noteSubFecha;
  CloudService cloud = new CloudService();
  Future<List<dynamic>> datos;
  String red;
  String fecha;
  bool animate;
  static double pointerValue;
  Metodos me = new Metodos();
  Redes buscarDireccion;

  Widget wid;
  var data;

  @override
  void initState() {
    super.initState();
    red='TOTAL';
    listar();
    listarFecha();

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
        Text('',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        detalle(context),
        SizedBox(
          height: 15,
        ),
        circularSede(context)
      ],
    )));
  }

    listarFecha() async {
    noteSubFecha?.cancel();
    noteSubFecha =
        cloud.listarDatos('Configuracion-fecha').listen((QuerySnapshot snapshot) {
      snapshot.documents.map((f) {
         if(f.data['estado']){
         fecha= f.data['fecha'];
         }
      }).toList();
    });
  }

  listar() async {
    noteSub?.cancel();
     List<dynamic> aux= new List();
    noteSub =
        cloud.listarDatos('Covid').listen((QuerySnapshot snapshot) {
            snapshot.documents.map((f){
              f.data.values.map((d){
               aux.add(d);    
                }).toList();
              }).toList();
                              setState(() {
                datos = cloud.convertir(aux); 
                
              });
    });
  }

  Widget _builCombo(context) {

    List<dynamic> prueba = new List();
    return  FutureBuilder(
          future: datos,
          builder: (BuildContext context, AsyncSnapshot data) {
            if (!data.hasData) {
              return Center(child: new CircularProgressIndicator());
            }
             prueba =data.data.where((f)=>f['fecha']==fecha).toList();
            prueba.sort((a,b)=>a['red'].toString().compareTo(b['red'].toString()));
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
    final simpleCurrencyFormatter =
        new charts.BasicNumericTickFormatterSpec.fromNumberFormat(
            new NumberFormat.compact());      
    return FutureBuilder(
          future: datos,
          builder: (BuildContext context, AsyncSnapshot data) {
            if (!data.hasData) {
              return Center(child: new CircularProgressIndicator());
            }
             prueba =data.data.where((f)=> f['red']==red).toList();
            seriesList = new List<
                              charts.Series<TimeSeriesSales, DateTime>>();
                          prueba.map((f)=>{
                             data2.add(TimeSeriesSales(
                                new DateTime(int.parse(f['fecha'].toString().substring(6,10))
                                , int.parse(f['fecha'].toString().substring(3,5)), 
                                int.parse(f['fecha'].toString().substring(0,2))), f['liberado']))
                          }).toList();
                      
                          seriesList
                              .add(charts.Series<TimeSeriesSales, DateTime>(
                            id: 'Sales',
                            colorFn: (_, __) =>
                                charts.MaterialPalette.blue.shadeDefault,
                            domainFn: (TimeSeriesSales sales, _) => sales.time,
                            measureFn: (TimeSeriesSales sales, _) =>
                                sales.sales,
                            measureLowerBoundFn: (TimeSeriesSales sales, _) =>
                                sales.sales - 5,
                            measureUpperBoundFn: (TimeSeriesSales sales, _) =>
                                sales.sales + 5,
                            data: data2,
                          ));
    return LayoutBuilder(builder: (context, constraints) {
      return ConstrainedBox(
          constraints: BoxConstraints.expand(height: 280.0),
          child: IntrinsicHeight(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 10),
              SizedBox(height: 10),
              Text(red,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 5,
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: charts.TimeSeriesChart(
                            seriesList,
                            animate: true,
                            animationDuration: Duration(seconds: 2),
                            primaryMeasureAxis: new charts.NumericAxisSpec(
                                tickFormatterSpec: simpleCurrencyFormatter),
                            defaultRenderer: new charts.LineRendererConfig(
                                includePoints: true),
                            behaviors: [
                              charts.LinePointHighlighter(
                                  symbolRenderer: CustomCircleSymbolRenderer()),
                              new charts.ChartTitle('Fecha',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
                            ],
                            selectionModels: [
                              charts.SelectionModelConfig(changedListener:
                                  (charts.SelectionModel model) {
                                if (model.hasDatumSelection)
                                pointerValue = double.parse(model.selectedSeries[0]
                                    .measureFn(model.selectedDatum[0].index)
                                    .toString());
                              })
                            ],
                            dateTimeFactory:
                                const charts.LocalDateTimeFactory(),
                          )))
            ]))          
          );
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
        prueba =data.data.where((f)=> f['red']==red && f['fecha']==fecha).toList(); 
        seriesListCircular =
                            new List<charts.Series<LinearSales, String>>();
                            
                            prueba.map((f)=>{
                              presupuestoCargado=f['liberado'],
                          data2.add(new LinearSales('Ejecu', (f['ejecucion']/f['liberado'])*100, Colors.pinkAccent)),
                          data2.add(new LinearSales('Saldo', (f['saldoLiberado']/f['liberado'])*100, Colors.limeAccent)),
                          data2.add(new LinearSales('SolPed', (f['solped']/f['liberado'])*100, Colors.redAccent)),
                          data2.add(new LinearSales('Reser', (f['reserva']/f['liberado'])*100, Colors.greenAccent)),
                          data2.add(new LinearSales('Pedi', (f['pedido']/f['liberado'])*100, Colors.blueAccent))
                            }).toList();
                         
                        seriesListCircular.add(charts.Series<LinearSales,
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
        ConstrainedBox(
        constraints: BoxConstraints.expand(height: 400.0),
        child: IntrinsicHeight(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
                child: Text('Presupuesto Cargado',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            Center(
                child: Text(
                    me.formatearNumero(presupuestoCargado).output.withoutFractionDigits,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            SizedBox(height: 10),
            Expanded(
                child: Container(
                    height: 300,
                    child: 
                        charts.PieChart(
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
                                    labelPosition: charts.ArcLabelPosition.auto,
                                    insideLabelStyleSpec:
                                        new charts.TextStyleSpec(
                                            fontSize: 11,
                                            color: charts.Color.fromHex(
                                                code: "#000000")))
                              ]),
                        )
                        )
                        )
          ],
        )));});
  }

  Widget detalle(context) {
    List<dynamic> prueba = new List();
    return FutureBuilder(
          future: datos,
          builder: (BuildContext context, AsyncSnapshot data) {
            if (!data.hasData) {
              return Center(child: new CircularProgressIndicator());
            }
        prueba =data.data.where((f)=> f['red']==red && f['fecha']==fecha).toList(); 
    
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
              rows: 
              [
                DataRow(cells: [
                  DataCell(Text('Ejecucion')),
                  DataCell(Text(me.formatearNumero((prueba[0]['ejecucion'])).output.withoutFractionDigits)),
                  DataCell(Text(me.formatearNumero(((prueba[0]['ejecucion']/prueba[0]['liberado'])*100)).output.compactNonSymbol+'%')),
                ]),
                DataRow(cells: [
                  DataCell(Text('SolPed')),
                  DataCell(Text(me.formatearNumero((prueba[0]['solped'])).output.withoutFractionDigits)),
                  DataCell(Text(me.formatearNumero(((prueba[0]['solped']/prueba[0]['liberado'])*100)).output.compactNonSymbol+'%')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Pedidos')),
                  DataCell(Text(me.formatearNumero((prueba[0]['pedido'])).output.withoutFractionDigits)),
                  DataCell(Text(me.formatearNumero(((prueba[0]['pedido']/prueba[0]['liberado'])*100)).output.compactNonSymbol+'%'))
                ]),
                DataRow(cells: [
                  DataCell(Text('Reservas')),
                  DataCell(Text(me.formatearNumero((prueba[0]['reserva'])).output.withoutFractionDigits)),
                  DataCell(Text(me.formatearNumero(((prueba[0]['reserva']/prueba[0]['liberado'])*100)).output.compactNonSymbol+'%'))
                ]),
                DataRow(cells: [
                  DataCell(Text('Saldo')),
                  DataCell(Text(me.formatearNumero((prueba[0]['saldoLiberado'])).output.withoutFractionDigits)),
                  DataCell(Text(me.formatearNumero(((prueba[0]['saldoLiberado']/prueba[0]['liberado'])*100)).output.compactNonSymbol+'%'))
                ]),
              ],
              sortColumnIndex: 2,
              sortAscending: false,
              
            )));
            });
  }

  Widget circularSede(context) {
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
                      future: datos,
                      builder: (BuildContext context, AsyncSnapshot data) {
                        if (!data.hasData) {
                          return Text('Cargando Informacion');
                        }
                        seriesListCircular =
                            new List<charts.Series<LinearSales, String>>();
                        final data2 = [
                          new LinearSales('CEABE', 61.5, Colors.blueAccent),
                          new LinearSales('LOGIS', 38.1, Colors.redAccent),
                          new LinearSales('GOF', 0.4, Colors.orangeAccent),
                        ];
                        seriesListCircular.add(charts.Series<LinearSales,
                                String>(
                            id: 'Sales',
                            domainFn: (LinearSales sales, _) => sales.year,
                            measureFn: (LinearSales sales, _) => sales.sales,
                            colorFn: (LinearSales sales, __) => sales.color,
                            data: data2,
                            // Set a label accessor to control the text of the arc label.
                            labelAccessorFn: (LinearSales row, _) =>
                                '${row.year}:${row.sales}%'));

                        return charts.PieChart(
                          seriesListCircular,
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
                                    labelPosition: charts.ArcLabelPosition.auto,
                                    insideLabelStyleSpec:
                                        new charts.TextStyleSpec(
                                            fontSize: 11,
                                            color: charts.Color.fromHex(
                                                code: "#000000")))
                              ]),
                        );
                      },
                    ))),
            Container(
                color: Colors.white,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
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
                      rows: [
                        DataRow(cells: [
                          DataCell(Text('CEABE')),
                          DataCell(Text('Arya')),
                          DataCell(Text('6')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('LOGISTICA')),
                          DataCell(Text('John')),
                          DataCell(Text('9')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('GOF')),
                          DataCell(Text('Tony')),
                          DataCell(Text('8')),
                        ]),
                      ],
                      sortColumnIndex: 0,
                      sortAscending: true,
                    )))
          ],
        )));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  Metodos me = new Metodos();
  @override
  void paint(charts.ChartCanvas canvas, Rectangle<num> bounds,
      {List<int> dashPattern,
      charts.Color fillColor,
      charts.Color strokeColor,
      double strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    canvas.drawRect(
        Rectangle(bounds.left - 5, bounds.top - 30, bounds.width + 10,
            bounds.height + 10),
        fill: charts.Color.white);
    var textStyle = style.TextStyle();
    textStyle.color = charts.Color.black;
    textStyle.fontSize = 12;
    canvas.drawText(TextElement(me.formatearNumero(_CovidPageState.pointerValue).output.compactNonSymbol, style: textStyle), (bounds.left).round(),
        (bounds.top - 28).round());
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

  LinearSales(this.year, this.sales, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
