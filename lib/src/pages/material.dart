
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gcpp_essalud/src/services/firestore.dart';
import 'package:gcpp_essalud/src/util/metodos.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MaterialEstrategico extends StatefulWidget {
  @override
  _MaterialEstrategicoState createState() => _MaterialEstrategicoState();
}

class _MaterialEstrategicoState extends State<MaterialEstrategico> {
  Metodos me = new Metodos();
  String red = 'TOTAL';
  String rubro;
  CloudService cloud = new CloudService();
  final f = new DateFormat('dd-MM-yyyy');
  final form = new DateFormat('dd/MM/yyyy');
  String annoSeleccionado='2020';
  Future<List<dynamic>> datos;
  List<dynamic> prueba = new List();
  List<dynamic> prueba2 = new List();
  List<dynamic> prueba3 = new List();
  @override
  void initState() { 
    super.initState();
    listar();
    rubro='CENTRALIZADA';
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            child: 
            Column(
              children: <Widget>[
                              Center(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 5, 5),
                    child: Column(
                      children: <Widget>[
                        Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 20.0, // gap between adjacent chips
                            runSpacing: 8.0,
                            children: <Widget>[
                                 _builCombo(context),
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      child: DropdownButton(
                                        value: red,
                                        hint: Text("Seleccione Red"),
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                        onChanged: (String ge) {
                                          setState(() {
                                            red = ge;
                                          });
                                        },
                                        items: me.redes
                                            .map((String valor) {
                                          return DropdownMenuItem<String>(
                                            value: valor,
                                            child: Text(
                                              valor,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            ),
                                          );
                                        
                                },
                              ).toList(),
                            )),
                            Column(
                              children: <Widget>[
                      FutureBuilder(
                          future: datos,
                          builder: (BuildContext context,
                              AsyncSnapshot data) {
                            if (!data.hasData) {
                              return Center(
                                  child: new CircularProgressIndicator());
                            }
                             prueba = data.data.where((f)=>f['red']==red 
                        && f['anno']==annoSeleccionado
                        && f['rubro']=='SUB-TOTAL').toList();
                            return GestureDetector(
                              child: Container(
                                  child: Column(
                                children: prueba.map((item){
                                  return Column(
                                    children: <Widget>[
                              new CircularPercentIndicator(
                                    radius: 130.0,
                                    lineWidth: 15.0,
                                    animation: true,
                                    percent: me.verificarNumero(
                                       item['porcentaje']),
                                    center: new Text(
                                      me
                                              .formatearNumero(
                                                  item
                                                          ['porcentaje'] *
                                                      100)
                                              .output
                                              .nonSymbol
                                              .toString() +
                                          '%',
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                    header: Text(
                                     item['red'],
                                      style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    footer: new Text(
                                      me
                                          .formatearNumero(item['ejecucion'])
                                          .output
                                          .withoutFractionDigits
                                          .toString(),
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: Colors.deepOrange,
                                  ),
                                  SizedBox(height: 5),
                              Text(  me.formatearNumero(
                                           item['pia'])
                                      .output
                                      .withoutFractionDigits
                                      .toString(),style: TextStyle(fontSize: 17,
                                color:Colors.grey
                              ),),
                                  SizedBox(height: 10),
                              Text("al " + form.format(f.parse(item['fecha']).toLocal()),style: TextStyle(
                                color:Colors.grey
                              ),)
                                    ],
                                  );

                                }).toList()
                                ,
                              )),
                            );
                          },
                        ),
                        SizedBox(height: 20),
                        detalleRedes(context),
                        SizedBox(height: 20),
                        detalleRedesCompromisos(context)
                              ],
                            )
                      ],
                    )])))
              ])));
  }

  listar()  {
   cloud.listarDatos('PruebaMateriales').listen((QuerySnapshot snapshot) {
            List<dynamic> aux = new List();
            snapshot.documents.map((f){
              f.data.values.map((d){
               aux.add(d);    
                }).toList();
                setState(() {
                datos = cloud.convertir(aux); 
              });
              }).toList();
              
    });
}
  Widget _builCombo(context) {
    var anno = ['2019','2020'];
    return  
      DropdownButton(
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
            }).toList());
  }
  Widget detalleRedes(context) {
    return Wrap(
      children: <Widget>[
        FutureBuilder(
          future: datos,
          builder: (BuildContext context, AsyncSnapshot data) {
            if (!data.hasData) {
              return Center(child: new CircularProgressIndicator());
            }

             prueba2 =data.data.where((f)=>f['red']==red 
                        && f['anno']==annoSeleccionado
                        && f['rubro']!='SUB-TOTAL').toList();
            prueba2.sort((a,b)=>a['rubro'].toString().compareTo(b['rubro'].toString()));
            return Column(children: <Widget>[
              Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20.0, // gap between adjacent chips
                  runSpacing: 8.0,
                  children: prueba2.map((item) {
                    return new Wrap(children: <Widget>[
                      GestureDetector(
                        child: 
                        Column(
                          children: <Widget>[
                                                    CircularPercentIndicator(
                          radius: 90.0,
                          lineWidth: 10.0,
                          animation: true,
                          percent: me.verificarNumero(item['porcentaje']),
                          center: new Text(
                            me
                                    .formatearNumero(
                                        item['porcentaje'] * 100)
                                    .output
                                    .nonSymbol
                                    .toString() +
                                '%',
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14.0),
                          ),
                          header: Text(
                            me.mayuscula(
                                item['rubro'].toString().toLowerCase()),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          footer: new Text(
                            me
                                .formatearNumero(item['ejecucion'])
                                .output
                                .withoutFractionDigits
                                .toString(),
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10.0),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.blue,
                        ),
                            SizedBox(height: 5),
                              Text(  me.formatearNumero(
                                           item['pia'])
                                      .output
                                      .withoutFractionDigits
                                      .toString(),style: TextStyle(fontSize: 14,
                                color:Colors.grey
                              ),),
                          ],
                        )
,
                        onTap: () {
                          setState(() {
                            rubro = item['rubro'];
                          });
                        },
                      )
                    ]);
                  }).toList()),
            ]);
          },
        )
      ],
    );
  }

  detalleRedesCompromisos(context) {
    return Column(
      children: <Widget>[
        FutureBuilder(
          future: datos,
          builder: (BuildContext context, AsyncSnapshot data) {
            if (!data.hasData) {
              return Center(child: new CircularProgressIndicator());
            }
              prueba3 =data.data.where((f)=>f['red']==red 
                        && f['anno']==annoSeleccionado
                        && f['rubro']==rubro).toList();
            return Wrap(
              children: prueba3.map((item){
                  return Column(
                    children: <Widget>[
                Center(
                  child: Text(item['rubro'],
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.0)),
                ),
                Row(
                  children: <Widget>[
                    DataTable(
                      columns: [
                        DataColumn(label: Text("Tipo de Compromisos")),
                        DataColumn(label: Text("Soles"))
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text("Solicitud de Pedidos")),
                          DataCell(Text(me
                              .formatearNumero(item['solped'])
                              .output
                              .withoutFractionDigits
                              .toString())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("Pedidos")),
                          DataCell(Text(me
                              .formatearNumero(item['pedido'])
                              .output
                              .withoutFractionDigits
                              .toString())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("Reservas")),
                          DataCell(Text(me
                              .formatearNumero(
                                 item['reserva'])
                              .output
                              .withoutFractionDigits
                              .toString())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("Total",
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0))),
                          DataCell(
                            Text(
                                me
                                    .formatearNumero(
                                        item['comprometido'])
                                    .output
                                    .withoutFractionDigits
                                    .toString(),
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0)),
                          ),
                        ]),
                      ],
                      sortColumnIndex: 0,
                      sortAscending: true,
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                )
                    ],
                  ) ;
              }).toList()

              ,
            );
          },
        )
      ],
    );
  }
}
