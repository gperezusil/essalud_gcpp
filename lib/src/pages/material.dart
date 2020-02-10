import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:gcpp_essalud/src/util/metodos.dart';
import 'package:intl/intl.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';

class MaterialEstrategico extends StatefulWidget {
  @override
  _MaterialEstrategicoState createState() => _MaterialEstrategicoState();
}

class _MaterialEstrategicoState extends State<MaterialEstrategico> {
  Metodos me = new Metodos();
  String gerencia = 'TOTAL';
  Random random = new Random();
  String rubro;
  final f = new DateFormat('dd-MM-yyyy');
  final form = new DateFormat('dd/MM/yyyy');
  String annoSeleccionado='2020';
  @override
  void initState() { 
    super.initState();
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
                                        value: gerencia,
                                        hint: Text("Seleccione Red"),
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                        onChanged: (String ge) {
                                          setState(() {
                                            gerencia = ge;
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
                                                        StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('Material')
                              .where('red', isEqualTo: gerencia)
                              .where('rubro', isEqualTo: 'SUB-TOTAL')
                              .where('anno',isEqualTo: annoSeleccionado)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> data) {
                            if (!data.hasData) {
                              return Center(
                                  child: new CircularProgressIndicator());
                            }
                            return GestureDetector(
                              child: Container(
                                  child: Column(
                                children: data.data.documents.map((item){
                                  return Column(
                                    children: <Widget>[
                                                                       new CircularPercentIndicator(
                                    radius: 130.0,
                                    lineWidth: 15.0,
                                    animation: true,
                                    percent: me.verificarNumero(
                                       item.data['porcentaje']),
                                    center: new Text(
                                      me
                                              .formatearNumero(
                                                  item.data
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
                                     item.data['red'],
                                      style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    footer: new Text(
                                      me
                                          .formatearNumero(item.data['ejecucion'])
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
                                           item.data['pia'])
                                      .output
                                      .withoutFractionDigits
                                      .toString(),style: TextStyle(fontSize: 17,
                                color:Colors.grey
                              ),),
                                  SizedBox(height: 10),
                              Text("al " + form.format(f.parse(item.data['fecha']).toLocal()),style: TextStyle(
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
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('Material')
              .where('red', isEqualTo: gerencia)
              .where('rubro',
                  whereIn: ['CENTRALIZADA', 'DELEGADA', 'LOCAL'])
                  .where('anno',isEqualTo: annoSeleccionado).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
            if (!data.hasData) {
              return Center(child: new CircularProgressIndicator());
            }

            data.data.documents.sort((a, b) => a.data['rubro']
                .toString()
                .compareTo(b.data['rubro'].toString()));
            return Column(children: <Widget>[
              Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20.0, // gap between adjacent chips
                  runSpacing: 8.0,
                  children: data.data.documents.map((item) {
                    return new Wrap(children: <Widget>[
                      GestureDetector(
                        child: 
                        Column(
                          children: <Widget>[
                                                    CircularPercentIndicator(
                          radius: 90.0,
                          lineWidth: 10.0,
                          animation: true,
                          percent: me.verificarNumero(item.data['porcentaje']),
                          center: new Text(
                            me
                                    .formatearNumero(
                                        item.data['porcentaje'] * 100)
                                    .output
                                    .nonSymbol
                                    .toString() +
                                '%',
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14.0),
                          ),
                          header: Text(
                            me.mayuscula(
                                item.data['rubro'].toString().toLowerCase()),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          footer: new Text(
                            me
                                .formatearNumero(item.data['ejecucion'])
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
                                           item.data['pia'])
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
                            rubro = item.data['rubro'];
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
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('Material')
              .where('red', isEqualTo: gerencia)
              .where('rubro', isEqualTo: rubro)
              .where('anno',isEqualTo: annoSeleccionado)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
            if (!data.hasData) {
              return Center(child: new CircularProgressIndicator());
            }
            return Wrap(
              children: data.data.documents.map((item){
                  return Column(
                    children: <Widget>[
                Center(
                  child: Text(item.data['rubro'],
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
                              .formatearNumero(item.data['solped'])
                              .output
                              .withoutFractionDigits
                              .toString())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("Pedidos")),
                          DataCell(Text(me
                              .formatearNumero(item.data['pedido'])
                              .output
                              .withoutFractionDigits
                              .toString())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("Reservas")),
                          DataCell(Text(me
                              .formatearNumero(
                                 item.data['reserva'])
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
                                        item.data['comprometido'])
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
