import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gcpp_essalud/src/services/firestore.dart';
import 'package:gcpp_essalud/src/util/metodos.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DetalleRed extends StatefulWidget {
  final String red;
  const DetalleRed({Key key, this.red}) : super(key: key);
  static Route<dynamic> route(red) {
    return MaterialPageRoute(
      builder: (context) => DetalleRed(red: red),
    );
  }

  @override
  _DetalleRedState createState() => _DetalleRedState();
}

class _DetalleRedState extends State<DetalleRed> {
  final f = new DateFormat('dd-MM-yyyy');
  final form = new DateFormat('dd/MM/yyyy');
  String annoSeleccionado = '2021';
  String rubro = 'BIENES';
  Metodos me = new Metodos();
  static CloudService cloud = new CloudService();
  List<dynamic> prueba = new List();
  List<dynamic> prueba2 = new List();
  List<dynamic> prueba3 = new List();
  Future<List<dynamic>> datos;

  @override
  void initState() {
    super.initState();
    listar();
  }

  @override
  Widget build(BuildContext context) {
    String red = widget.red;
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          _builCombo(context),
          Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 5, 5),
              child: Text(red,
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0)),
            ),
          ),
          FutureBuilder(
            future: datos,
            builder: (BuildContext context, AsyncSnapshot data) {
              if (!data.hasData) {
                return Center(child: new CircularProgressIndicator());
              }
              prueba = data.data
                  .where((f) =>
                      f['red'] == red &&
                      f['anno'] == annoSeleccionado &&
                      f['rubro'] == 'SUB-TOTAL')
                  .toList();
              return GestureDetector(
                child: Container(
                    child: Column(
                  children: prueba.map((item) {
                    return Column(
                      children: <Widget>[
                        new CircularPercentIndicator(
                          radius: 130.0,
                          lineWidth: 15.0,
                          animation: true,
                          percent: me.verificarNumero2(item['porcentaje']),
                          center: new Text(
                            me
                                    .formatearNumero(item['porcentaje'] * 100)
                                    .output
                                    .compactNonSymbol
                                    .toString() +
                                '%',
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                          footer: new Text(
                            me
                                .formatearNumero(item['ejecucion'])
                                .output
                                .withoutFractionDigits
                                .toString(),
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.0),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.green,
                        ),
                        SizedBox(height: 5),
                        Text(
                          me
                              .formatearNumero(item['pia'])
                              .output
                              .withoutFractionDigits
                              .toString(),
                          style: TextStyle(fontSize: 17, color: Colors.grey),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "al " + form.format(f.parse(item['fecha']).toLocal()),
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    );
                  }).toList(),
                )),
              );
            },
          ),
          SizedBox(height: 20),
          detalleRedes(context, red),
          SizedBox(height: 20),
          detalleRedesCompromisos(red, context)
        ],
      ),
    );
  }

  listar() async {
    cloud.listarDatos('PruebaRedes').listen((QuerySnapshot snapshot) {
      List<dynamic> aux = new List();

      snapshot.documents.map((f) {
        f.data.values.map((d) {
          aux.add(d);
        }).toList();
        setState(() {
          datos = cloud.convertir(aux);
        });
      }).toList();
    });
  }

  Widget _builCombo(context) {
    var anno = ['2019', '2020', '2021'];
    return Center(
        child: DropdownButton(
            hint: Text("Seleccione Año"),
            value: annoSeleccionado,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black, fontSize: 15),
            onChanged: (String ge) {
              setState(() {
                annoSeleccionado = ge;
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

  Widget detalleRedes(context, String red) {
    return Wrap(
      children: <Widget>[
        FutureBuilder(
          future: datos,
          builder: (BuildContext context, AsyncSnapshot data) {
            if (!data.hasData) {
              return Center(child: new CircularProgressIndicator());
            }
            prueba2 = data.data
                .where((f) =>
                    f['red'] == red &&
                    f['anno'] == annoSeleccionado &&
                    f['rubro'] != 'SUB-TOTAL')
                .toList();
            prueba2.sort((a, b) =>
                a['rubro'].toString().compareTo(b['rubro'].toString()));
            return Column(children: <Widget>[
              Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20.0, // gap between adjacent chips
                  runSpacing: 8.0,
                  children: prueba2.map((item) {
                    return new Wrap(children: <Widget>[
                      GestureDetector(
                        child: Column(
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
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
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
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: Colors.blue,
                            ),
                            SizedBox(height: 5),
                            Text(
                              me
                                  .formatearNumero(item['pia'])
                                  .output
                                  .withoutFractionDigits
                                  .toString(),
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
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

  detalleRedesCompromisos(String red, context) {
    return Column(
      children: <Widget>[
        FutureBuilder(
          future: datos,
          builder: (BuildContext context, AsyncSnapshot data) {
            if (!data.hasData) {
              return Center(child: new CircularProgressIndicator());
            }
            prueba3 = data.data
                .where((f) =>
                    f['red'] == red &&
                    f['anno'] == annoSeleccionado &&
                    f['rubro'] == rubro)
                .toList();
            return Wrap(
              children: prueba3.map<Widget>((item) {
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
                                  .formatearNumero(item['reserva'])
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
                                        .formatearNumero(item['comprometido'])
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
                );
              }).toList(),
            );
          },
        )
      ],
    );
  }
}
