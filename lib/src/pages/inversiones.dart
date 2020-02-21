import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:gcpp_essalud/src/util/metodos.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class InversionesPage extends StatefulWidget {
  @override
  _InversionesPageState createState() => _InversionesPageState();
}

class _InversionesPageState extends State<InversionesPage> {
  String rubro1, rubro2;
  Color colorInversiones;
  final f = new DateFormat('dd-MM-yyyy');
  final form = new DateFormat('dd/MM/yyyy');
  Metodos me = new Metodos();
  List<String> anno;
  String annoSeleccionado;
  @override
  void initState() {
    super.initState();
    colorInversiones = Colors.blueGrey;
    annoSeleccionado = '2020';
    rubro1 = '3.1.1  Proyectos de Inversión';
    rubro2 = 'Obras';
    anno = new List();
    anno.add('2020');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
        child: ListView(
          children: <Widget>[
            _builCombo(context),
            SizedBox(height: 1),
            _buildCardIngresos(context),
            SizedBox(height: 20),
            _buildCardEgresos(context),
            SizedBox(height: 20),
            _buildCardDetalleIngresosOperativos(context),
            SizedBox(height: 20),
            _buildetalle(context),
            SizedBox(height: 20),
            _buildetalledetalle(context)
          ],
        ),
      ),
    ));
  }

  FlutterMoneyFormatter formatearNumero(double variable) {
    return FlutterMoneyFormatter(amount: variable.toDouble());
  }

  @override
  void dispose() {
    super.dispose();
  }

  num verificarNumero(num numero) {
    if (1 - numero < 0) {
      return 0.99;
    } else {
      return numero;
    }
  }

  Widget _buildCardIngresos(context) {
    return Card(
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('Inversiones')
                        .where('red', isEqualTo: 'Total Gastos')
                        .where('rubro', isEqualTo: 'Total Gastos de Capital')
                        .where('anno', isEqualTo: annoSeleccionado)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> data) {
                      if (!data.hasData) {
                        return Text('Cargando Informacion');
                      }
                      return Container(
                          child: Column(
                              children: data.data.documents.map((item) {
                        return Column(
                          children: <Widget>[
                            new CircularPercentIndicator(
                              radius: 120.0,
                              lineWidth: 13.0,
                              animation: true,
                              percent: verificarNumero(item.data['porcentaje']),
                              center: new Text(
                                formatearNumero(item.data['porcentaje'] * 100)
                                        .output
                                        .compactNonSymbol
                                        .toString() +
                                    '%',
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              header: Text(item.data['rubro'].toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                              footer: new Text(
                                formatearNumero(item.data['ejecucion'])
                                    .output
                                    .withoutFractionDigits
                                    .toString(),
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: colorInversiones,
                            ),
                            SizedBox(height: 5),
                            Text(
                              me
                                  .formatearNumero(item.data['pia'])
                                  .output
                                  .withoutFractionDigits
                                  .toString(),
                              style:
                                  TextStyle(fontSize: 17, color: Colors.grey),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "al " +
                                  form.format(
                                      f.parse(item.data['fecha']).toLocal()),
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        );
                      }).toList()));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        height: 250,
      ),
    );
  }

  Widget _buildCardEgresos(context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 20.0, // gap between adjacent chips
      runSpacing: 8.0, // gap between lines
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('Inversiones')
              .where('red', isEqualTo: 'Total Gastos de Capital')
              .where('anno', isEqualTo: annoSeleccionado)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
            if (!data.hasData) {
              return Text('Cargando Informacion');
            }
            return Container(
                child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20.0, // gap between adjacent chips
                    runSpacing: 8.0,
                    children: data.data.documents.map((item) {
                      return Column(
                        children: <Widget>[
                          new CircularPercentIndicator(
                            radius: 100.0,
                            lineWidth: 11.0,
                            animation: true,
                            percent: verificarNumero(item.data['porcentaje']),
                            center: new Text(
                              formatearNumero(item.data['porcentaje'] * 100)
                                      .output
                                      .compactNonSymbol
                                      .toString() +
                                  '%',
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                            header: Text(item.data['rubro'].toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                )),
                            footer: new Text(
                              formatearNumero(item.data['ejecucion'])
                                  .output
                                  .withoutFractionDigits
                                  .toString(),
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15.0),
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: Colors.deepOrangeAccent,
                          ),
                          SizedBox(height: 5),
                          Text(
                            me
                                .formatearNumero(item.data['pia'])
                                .output
                                .withoutFractionDigits
                                .toString(),
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      );
                    }).toList()));
          },
        )
      ],
    );
  }

  Widget _builCombo(context) {
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

  Widget _buildCardDetalleIngresosOperativos(context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 20.0, // gap between adjacent chips
      runSpacing: 8.0, // gap between lines
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('Inversiones')
              .where('red', isEqualTo: '3.1 Presupuesto de Inversiones')
              .where('anno', isEqualTo: annoSeleccionado)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
            if (!data.hasData) {
              return Text('Cargando Informacion');
            }
            return Column(
              children: <Widget>[
                Text(
                  '3.1 Presupuesto de Inversiones  -FBK',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Container(
                    child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 20.0, // gap between adjacent chips
                        runSpacing: 8.0,
                        children: data.data.documents.map((item) {
                          return Column(
                            children: <Widget>[
                              GestureDetector(
                                child: Column(
                                  children: <Widget>[
                                    new CircularPercentIndicator(
                                      radius: 90.0,
                                      lineWidth: 9.0,
                                      animation: true,
                                      percent: verificarNumero(
                                          item.data['porcentaje']),
                                      center: new Text(
                                        formatearNumero(
                                                    item.data['porcentaje'] *
                                                        100)
                                                .output
                                                .compactNonSymbol
                                                .toString() +
                                            '%',
                                        style: new TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0),
                                      ),
                                      header:
                                          Text(item.data['rubro'].toString(),
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              )),
                                      footer: new Text(
                                        formatearNumero(item.data['ejecucion'])
                                            .output
                                            .withoutFractionDigits
                                            .toString(),
                                        style: new TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0),
                                      ),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: Colors.blue,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      me
                                          .formatearNumero(item.data['pia'])
                                          .output
                                          .withoutFractionDigits
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    rubro1 = item.data['rubro'];
                                    if (item.data['rubro'] ==
                                        '3.1.1  Proyectos de Inversión') {
                                      rubro2 = 'Obras';
                                    } else {
                                      rubro2 = 'Gastos de Capital Diversos';
                                    }
                                  });
                                },
                              )
                            ],
                          );
                        }).toList()))
              ],
            );
          },
        )
      ],
    );
  }

  Widget _buildetalle(context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 20.0, // gap between adjacent chips
      runSpacing: 8.0, // gap between lines
      children: [
        Text(
          rubro1,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('Inversiones')
              .where('red', isEqualTo: rubro1)
              .where('anno', isEqualTo: annoSeleccionado)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
            if (!data.hasData) {
              return Text('Cargando Informacion');
            }
            data.data.documents.sort((a, b) => a.data['rubro']
                .toString()
                .compareTo(b.data['rubro'].toString()));
            return Container(
                child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20.0, // gap between adjacent chips
                    runSpacing: 8.0,
                    children: data.data.documents.map((item) {
                      return Column(
                        children: <Widget>[
                          GestureDetector(
                            child: Column(
                              children: <Widget>[
                                new CircularPercentIndicator(
                                  radius: 80.0,
                                  lineWidth: 9.0,
                                  animation: true,
                                  percent:
                                      verificarNumero(item.data['porcentaje']),
                                  center: new Text(
                                    formatearNumero(
                                                item.data['porcentaje'] * 100)
                                            .output
                                            .compactNonSymbol
                                            .toString() +
                                        '%',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0),
                                  ),
                                  header: Text(item.data['rubro'].toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  footer: new Text(
                                    formatearNumero(item.data['ejecucion'])
                                        .output
                                        .withoutFractionDigits
                                        .toString(),
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0),
                                  ),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: Colors.green,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  me
                                      .formatearNumero(item.data['pia'])
                                      .output
                                      .withoutFractionDigits
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                rubro2 = item.data['rubro'];
                              });
                            },
                            onDoubleTap: () {
                              if (item.data['rubro'] == 'Obras') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute<Null>(
                                      builder: (BuildContext context) {
                                        return MyWiget2();
                                      },
                                      fullscreenDialog: true,
                                    ));
                              }
                            },
                          )
                        ],
                      );
                    }).toList()));
          },
        )
      ],
    );
  }

  Widget _buildetalledetalle(context) {
    return Column(
      children: <Widget>[
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('Inversiones')
              .where('red', isEqualTo: rubro1)
              .where('rubro', isEqualTo: rubro2)
              .where('anno', isEqualTo: annoSeleccionado)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
            if (!data.hasData) {
              return Center(child: new CircularProgressIndicator());
            }
            return Wrap(
              children: data.data.documents.map((item) {
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
                                  .formatearNumero(item.data['reserva'])
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
                );
              }).toList(),
            );
          },
        )
      ],
    );
  }
}

class MyWiget2 extends StatefulWidget {
  @override
  _MyWiget2State createState() => _MyWiget2State();
}

class _MyWiget2State extends State<MyWiget2> {
  Metodos me = Metodos();
  List<String> valores;
  List<dynamic> resultado;
  String nomRed;
  @override
  @override
  void initState() {
    super.initState();
    nomRed='LIMA';
    listar();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Detalle")),
        body: Container(
            color: Colors.white,
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                _builCombo(context),
                _buildObras(context)
              ],
            ))));
  }

  Future<List<dynamic>> listar() async {
    List<String> aux = new List();
    valores = new List();
    resultado = new List();
    Firestore.instance
        .collection('Obras')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.documents
          .map((f) => {
                f.data.values.map((d) {
                  setState(() {
                    aux.add(d['red']);
                    valores = aux.toSet().toList();
                    resultado.add(d);
                  });
                }).toList()
              })
          .toList();
    });

    return resultado;
  }

  Widget _builCombo(context) {
    return Center(
        child: DropdownButton<String>(
            hint: Text("Seleccione Departamento"),
            value: nomRed,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black, fontSize: 15),
            onChanged: (String ge) {
              setState(() {
                nomRed = ge;
              });
            },
            items: valores.map<DropdownMenuItem<String>>((String valor) {
              return DropdownMenuItem<String>(
                value: valor,
                child: Text(
                  valor,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              );
            }).toList()));
  }

  Widget _buildObras(context) {
    List<dynamic> prueba = new List();
    return Center(
        child: FutureBuilder(
            future: listar(),
            builder: (BuildContext context, AsyncSnapshot data) {
              if (data.data == null) {
                return Text("Sin datos");
              }
              prueba = data.data.where((f)=>f['red']==nomRed).toList();
              return Column(
                children: prueba.map<Widget>((f){
                  return Column(
                    children: <Widget>[
                        SizedBox(height: 20),
                    new CircularPercentIndicator(
                              radius: 120.0,
                              lineWidth: 13.0,
                              animation: true,
                              percent: me.verificarNumero(f['porcentaje']),
                              center: new Text(
                                me.formatearNumero(f['porcentaje'] * 100)
                                        .output
                                        .compactNonSymbol
                                        .toString() +
                                    '%',
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              header: Text(f['nombreObra'].toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),textAlign: TextAlign.center,),
                              footer: new Text(
                                me.formatearNumero(f['ejecucion'])
                                    .output
                                    .withoutFractionDigits
                                    .toString(),
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: Colors.lightGreen,
                            )
                    
                    ],
                  );
                }).toList()
              );
            }));
  }
}
