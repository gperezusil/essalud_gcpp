import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gcpp_essalud/src/util/metodos.dart';

class RankingChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final List<charts.Series> seriesList2;
  final bool animate;
 
  RankingChart(this.seriesList,this.seriesList2, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory RankingChart.withSampleData() {
    return new RankingChart(
      _createSampleData(),
      _createSampleData2(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    
    // For horizontal bar charts, set the [vertical] flag to false.
    return Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
               child: ConstrainedBox(
                  constraints: BoxConstraints.expand(height:1500.0),
                    child: IntrinsicHeight(
                    child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text("Raking de Redes Asistenciales",
                     style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0)),
                                       SizedBox(height: 5),
                                    Text("al 17/02/2020",
                     style: new TextStyle(color: Colors.grey,
                                    fontSize: 15.0)),
                    Expanded(
                      child: Container(
                        child: 
                        Padding( 
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child:new charts.BarChart(
                      seriesList,
                      animate: animate,
                      vertical: false,
                      
                       barRendererDecorator: new charts.BarLabelDecorator<String>(),

                    )))),
                                        Text("Raking de Sede Central",
                     style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0)),
                                       SizedBox(height: 5),
                                    Text("al 17/02/2020",
                     style: new TextStyle(color: Colors.grey,
                                    fontSize: 15.0)),
                    Expanded(
                      child: Container(
                        child: 
                        Padding( 
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child:new charts.BarChart(
                      seriesList2,
                      animate: animate,
                      vertical: false,
                      
                       barRendererDecorator: new charts.BarLabelDecorator<String>(),

                    ))))
                  ],
                ))));}));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
   Metodos me = new Metodos();
   List<OrdinalSales> valores = new List();
     Firestore.instance
        .collection('RankingRedes')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.documents
          .map((f) => {f.data.values.map((d) {
          valores.add(new OrdinalSales(d['red'], double.parse(me.formatearNumero(d['porcentaje'] * 100).output.compactNonSymbol)));
           valores.sort((a, b) => b.sales.compareTo(a.sales));
          }).toList()})
          .toList();
    });
    
    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,

        data: valores,
        labelAccessorFn: (OrdinalSales sales, _) =>
              '${sales.sales.toString()}%')
      
    ];
  }
    static List<charts.Series<OrdinalSales, String>> _createSampleData2() {
   Metodos me = new Metodos();
   List<OrdinalSales> valores = new List();
     Firestore.instance
        .collection('RankingSede')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.documents
          .map((f) => {f.data.values.map((d) {
          valores.add(new OrdinalSales(d['siglas'], double.parse(me.formatearNumero(d['porcentaje'] * 100).output.compactNonSymbol)));
           valores.sort((a, b) => b.sales.compareTo(a.sales));
          }).toList()})
          .toList();
    });
    
    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,

        data: valores,
        labelAccessorFn: (OrdinalSales sales, _) =>
              '${sales.sales.toString()}%')
      
    ];
  }

}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final double sales;

  OrdinalSales(this.year, this.sales);
}
