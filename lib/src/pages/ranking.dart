import 'dart:async';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gcpp_essalud/src/services/firestore.dart';
import 'package:gcpp_essalud/src/util/metodos.dart';
import 'package:intl/intl.dart';

class RankingChart extends StatefulWidget {

    @override
  _RankingChartState createState() => _RankingChartState();
}

class _RankingChartState extends State<RankingChart> {
  final f = new DateFormat('dd-MM-yyyy');
  final form = new DateFormat('dd/MM/yyyy');
  List<charts.Series<OrdinalSales, String>> _seriesDataRedes; 
  List<charts.Series<OrdinalSales, String>> _seriesDataSede; 
  StreamSubscription<QuerySnapshot> noteSub;
  Future<List<dynamic>> datos;
  Future<List<dynamic>> datosSede;
  List<OrdinalSales> prueba;
  List<OrdinalSales> prueba2;
  String annoSeleccionado;
  CloudService cloud = new CloudService();
     Metodos me = new Metodos();
  @override
  void initState() {
    super.initState();
    annoSeleccionado ='2020';
       listar();
    
  }
   @override
  void dispose() {
    noteSub?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    String fechota;
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
                     SizedBox(height: 10),
                     _builCombo(context),
                     SizedBox(height: 10),
                    Text("Raking de Redes Asistenciales",
                     style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0)),
                                       SizedBox(height: 5),
                    Expanded(
                      child: Container(
                        child: 
                        Padding( 
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child:
                       
                    FutureBuilder(
                    future: datos,
                    builder: (BuildContext context, AsyncSnapshot data) {
                      if (!data.hasData) {
                        return Text('Cargando Informacion');
                      }
                       _seriesDataRedes = List<charts.Series<OrdinalSales, String>>();
                      prueba = data.data
                          .where((f) =>f.anno == annoSeleccionado)
                          .toList();
                      prueba.map((response)=>{
                        fechota=response.fecha
                      }).toList();    
                             _seriesDataRedes.add(
                            charts.Series<OrdinalSales, String>(
                             id: 'Sales',
                            domainFn: (OrdinalSales sales, _) => sales.year,
                           measureFn: (OrdinalSales sales, _) => sales.sales,
                            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                           data: prueba,
                           labelAccessorFn: (OrdinalSales sales, _) =>'${sales.sales.toString()}%'));
                      return charts.BarChart(
                      _seriesDataRedes,
                      vertical: false,
                      animate: true,
                      behaviors: [
        new charts.ChartTitle(form.format(f.parse(fechota).toLocal()),
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea,
            // Set a larger inner padding than the default (10) to avoid
            // rendering the text too close to the top measure axis tick label.
            // The top tick label may extend upwards into the top margin region
            // if it is located at the top of the draw area.
            innerPadding: 18)],
                      animationDuration: Duration(seconds: 3),
                       barRendererDecorator: new charts.BarLabelDecorator<String>(),

                    );
                    },
                  )
                    ))),
                    Text("Raking de Sede Central",
                     style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0)),
                                       SizedBox(height: 5),
                    Expanded(
                      child: Container(
                        child: 
                        Padding( 
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child:
                       
                    FutureBuilder(
                    future: datosSede,
                    builder: (BuildContext context, AsyncSnapshot data) {
                      if (!data.hasData) {
                        return Text('Cargando Informacion');
                      }
                    _seriesDataSede = List<charts.Series<OrdinalSales, String>>();
                      prueba2 = data.data
                          .where((f) =>f.anno == annoSeleccionado)
                          .toList();
                             _seriesDataSede.add(
                            charts.Series<OrdinalSales, String>(
                             id: 'Sales',
                            domainFn: (OrdinalSales sales, _) => sales.year,
                           measureFn: (OrdinalSales sales, _) => sales.sales,
                            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                           data: prueba2,
                           labelAccessorFn: (OrdinalSales sales, _) =>'${sales.sales.toString()}%'));
                      return charts.BarChart(
                      _seriesDataSede,
                      vertical: false,
                      animate: true,
                                                  behaviors: [
        new charts.ChartTitle(
          form.format(f.parse(fechota).toLocal()),
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea,
            // Set a larger inner padding than the default (10) to avoid
            // rendering the text too close to the top measure axis tick label.
            // The top tick label may extend upwards into the top margin region
            // if it is located at the top of the draw area.
            innerPadding: 18)],
                      animationDuration: Duration(seconds: 3),
                       barRendererDecorator: new charts.BarLabelDecorator<String>(),

                    );
                    },
                  )
                    ))),
                  ],
                ))));}));
  }
listar() async{
  
    noteSub?.cancel();
   noteSub= cloud.listarDatos('RankingRedes').listen((QuerySnapshot snapshot) {
   List<OrdinalSales> valores = new List();
   
            snapshot.documents.map((f){
              f.data.values.map((d){
               valores.add(new OrdinalSales(d['red'],double.parse(me.formatearNumero(d['porcentaje'] * 100).output.compactNonSymbol),d['anno'],d['fecha']));
               valores.sort((a, b) => b.sales.compareTo(a.sales));
                }).toList();
                setState(() {
                datos = cloud.convertir(valores); 
              });
              }).toList();
              
    });

noteSub= cloud.listarDatos('RankingSede').listen((QuerySnapshot snapshot) {
   List<OrdinalSales> valores = new List();
            snapshot.documents.map((f){
              f.data.values.map((d){
               valores.add(new OrdinalSales(d['siglas'],double.parse(me.formatearNumero(d['porcentaje'] * 100).output.compactNonSymbol),d['anno'],d['fecha']));
               valores.sort((a, b) => b.sales.compareTo(a.sales));
                }).toList();
                setState(() {
                datosSede = cloud.convertir(valores); 
              });
              }).toList();
              
    });

}
 Widget _builCombo(context) {
    var anno = ['2019', '2020'];
    return  
    Center(child:DropdownButton(
            hint: Text("Seleccione Año"),
            value: annoSeleccionado,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black, fontSize: 15),
            onChanged: (String ge) {
              setState(() {
                annoSeleccionado=ge;
              });
            },
            items: anno.map((String valor) {
              return DropdownMenuItem<String>(
                value: valor,
                child: Text(
                  valor,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              );
            }).toList()));
  }
  }


/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final double sales;
  final String anno;
  final String fecha;
  OrdinalSales(this.year, this.sales,this.anno,this.fecha);
}
