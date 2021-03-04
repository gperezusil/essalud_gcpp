import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gcpp_essalud/src/services/firestore.dart';
import 'package:gcpp_essalud/src/util/metodos.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List<dynamic> lista;
  List<dynamic> detalleLista;
  String titulo, detalle, detalledetalle, annoSeleccionado;
  Random random = new Random();
  CloudService cloud = new CloudService();
  Color colorRubroIngresos, colorRubroEgresos;
  final f = new DateFormat('dd-MM-yyyy');
  final form = new DateFormat('dd/MM/yyyy');
  Metodos me = Metodos();
  List<String> anno;
  List<Widget> details = [];
  List<dynamic> prueba = new List();
  List<dynamic> prueba2 = new List();
  Future<List<dynamic>> datos;
  StreamSubscription<QuerySnapshot> noteSub;
  Size media;
  @override
  void initState() {
    listar();

    super.initState();
    colorRubroIngresos = Colors.purple;
    colorRubroEgresos = Colors.lime[50];
    annoSeleccionado = '2021';
    titulo = 'Ingresos Operativos';
    detalle = 'Ingresos';
    detalledetalle = 'Ingresos Operativos';
    anno = new List();
    anno.add('2019');
    anno.add('2020');
    anno.add('2021');
  }

  @override
  Widget build(BuildContext context) {
    media = MediaQuery.of(context).size;
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
            _buildCardDetalleIngresosOperativos(context)
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    noteSub?.cancel();
    super.dispose();
  }

  listar() async {
    noteSub?.cancel();
    noteSub = cloud
        .listarDatos('PruebaInstitucional')
        .listen((QuerySnapshot snapshot) {
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
                  FutureBuilder(
                    future: datos,
                    builder: (BuildContext context, AsyncSnapshot data) {
                      if (!data.hasData) {
                        return Text('Cargando Informacion');
                      }
                      prueba = data.data
                          .where((f) =>
                              f['padre'] == 'Ingresos Totales' &&
                              f['anno'] == annoSeleccionado)
                          .toList();
                      return GestureDetector(
                          child: Container(
                              child: Column(
                                  children: prueba.map((item) {
                            return Column(
                              children: <Widget>[
                                new CircularPercentIndicator(
                                  radius: 120,
                                  lineWidth: 12.0,
                                  animation: true,
                                  percent:
                                      me.verificarNumero2(item['porcentaje']),
                                  center: new Text(
                                    me
                                            .formatearNumero(
                                                item['porcentaje'] * 100)
                                            .output
                                            .compactNonSymbol
                                            .toString() +
                                        '%',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                  header: Text(item['titulo'].toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )),
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
                                  progressColor: colorRubroIngresos,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  me
                                      .formatearNumero(item['pia'])
                                      .output
                                      .withoutFractionDigits
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.grey),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "al " +
                                      form.format(
                                          f.parse(item['fecha']).toLocal()),
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            );
                          }).toList())),
                          onTap: () {
                            setState(() {
                              colorRubroIngresos = Colors.purple;
                              colorRubroEgresos = Colors.lime[50];
                              detalle = 'Ingresos';
                              detalledetalle = 'Ingresos Operativos';
                              titulo = 'Ingresos Operativos';
                            });
                          });
                    },
                  ),
                  FutureBuilder(
                    future: datos,
                    builder: (BuildContext context, AsyncSnapshot data) {
                      if (!data.hasData) {
                        return Text('Cargando Informacion');
                      }
                      prueba2 = data.data
                          .where((f) =>
                              f['padre'] == 'Egresos Totales' &&
                              f['anno'] == annoSeleccionado)
                          .toList();
                      return GestureDetector(
                          child: Container(
                              child: Column(
                            children: prueba2.map((item) {
                              return Column(
                                children: <Widget>[
                                  new CircularPercentIndicator(
                                    radius: 120,
                                    lineWidth: 12.0,
                                    animation: true,
                                    percent:
                                        me.verificarNumero(item['porcentaje']),
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
                                          fontSize: 20.0),
                                    ),
                                    header: Text(item['titulo'].toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        )),
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
                                    progressColor: colorRubroEgresos,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    me
                                        .formatearNumero(item['pia'])
                                        .output
                                        .withoutFractionDigits
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.grey),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "al " +
                                        form.format(
                                            f.parse(item['fecha']).toLocal()),
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              );
                            }).toList(),
                          )),
                          onTap: () {
                            setState(() {
                              colorRubroEgresos = Colors.blue;
                              colorRubroIngresos = Colors.lime[50];
                              detalledetalle = 'Gastos Operativos';
                              titulo = 'Gastos Operativos';
                              detalle = 'Egresos';
                            });
                          });
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
    return FutureBuilder(
        future: datos,
        builder: (BuildContext context, AsyncSnapshot data) {
          if (!data.hasData) {
            return Text('Cargando Informacion');
          }
          lista = data.data
              .where(
                  (f) => f['padre'] == detalle && f['anno'] == annoSeleccionado)
              .toList();
          lista.sort((a, b) =>
              a['titulo'].toString().compareTo(b['titulo'].toString()));
          return Wrap(
            alignment: WrapAlignment.center,
            spacing: 20.0, // gap between adjacent chips
            runSpacing: 8.0, // gap between lines
            children: lista.map((item) {
              return new Wrap(children: <Widget>[
                Column(
                  children: <Widget>[
                    CircularPercentIndicator(
                      radius: 90,
                      lineWidth: 11.0,
                      animation: true,
                      percent: me.verificarNumero(item['porcentaje']),
                      center: new Text(
                        me
                                .formatearNumero((item['porcentaje'] * 100))
                                .output
                                .nonSymbol
                                .toString() +
                            "%",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12.0),
                      ),
                      header: Text(
                        item['titulo'],
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 9.0),
                      ),
                      footer: new Text(
                        me
                            .formatearNumero(item['ejecucion'])
                            .output
                            .withoutFractionDigits
                            .toString(),
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13.0),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Color.fromARGB(255, random.nextInt(255),
                          random.nextInt(255), random.nextInt(255)),
                    ),
                    SizedBox(height: 5),
                    Text(
                      me
                          .formatearNumero(item['pia'])
                          .output
                          .withoutFractionDigits
                          .toString(),
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                )
              ]);
            }).toList(),
          );
        });
  }

  Widget _builCombo(context) {
    return Container(
        alignment: Alignment.topCenter,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 15,
        child: Center(
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
                }).toList())));
  }

  Widget _buildCardDetalleIngresosOperativos(context) {
    return FutureBuilder(
        future: datos,
        builder: (BuildContext context, AsyncSnapshot data) {
          if (!data.hasData) {
            return Text('Cargando Informacion');
          }
          detalleLista = data.data
              .where((f) =>
                  f['padre'] == detalledetalle && f['anno'] == annoSeleccionado)
              .toList();
          detalleLista.sort((a, b) =>
              a['titulo'].toString().compareTo(b['titulo'].toString()));
          return GestureDetector(
            child: Card(
                elevation: 10,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Container(
                    child: Column(children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 5, 5),
                      child: Text(titulo,
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0))),
                  Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 5, 15),
                      child: Column(
                          children: detalleLista.map((item) {
                        return Column(
                          children: <Widget>[
                            Text(item['titulo'],
                                style: new TextStyle(fontSize: 11.0)),
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 5, 5, 10),
                              child: new LinearPercentIndicator(
                                width: MediaQuery.of(context).size.width - 100,
                                animation: true,
                                lineHeight: 16.0,
                                animationDuration: 2500,
                                percent: me
                                    .verificarNumero(item['porcentaje'])
                                    .toDouble(),
                                center: Text(
                                    me
                                            .formatearNumero(
                                                (item['porcentaje'] * 100))
                                            .output
                                            .nonSymbol
                                            .toString() +
                                        '%',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0)),
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                progressColor: Color.fromARGB(
                                    255,
                                    random.nextInt(255),
                                    random.nextInt(255),
                                    random.nextInt(255)),
                              ),
                            )
                          ],
                        );
                      }).toList()))
                ]))),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return MyWiget2(datos: detalleLista);
                    },
                    fullscreenDialog: true,
                  ));
            },
          );
        });
  }
}

class MyWiget2 extends StatefulWidget {
  final List<dynamic> datos;
  const MyWiget2({Key key, this.datos}) : super(key: key);

  static Route<dynamic> route(d) {
    return MaterialPageRoute(
      builder: (context) => MyWiget2(datos: d),
    );
  }

  @override
  _MyWiget2State createState() => _MyWiget2State();
}

class _MyWiget2State extends State<MyWiget2> {
  Metodos me = Metodos();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalle")),
      body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(
                      label: Text("Rubro",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Pia",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Ejecucion",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("%",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: widget.datos.map((f) {
                  return DataRow(cells: [
                    DataCell(Text(f['titulo'])),
                    DataCell(Text(me
                        .formatearNumero(f['pia'])
                        .output
                        .withoutFractionDigits
                        .toString())),
                    DataCell(Text(me
                        .formatearNumero(f['ejecucion'])
                        .output
                        .withoutFractionDigits
                        .toString())),
                    DataCell(Text(me
                            .formatearNumero(f['porcentaje'] * 100)
                            .output
                            .nonSymbol
                            .toString() +
                        '%')),
                  ]);
                }).toList(),
                sortColumnIndex: 0,
                sortAscending: true,
              ))),
    );
  }
}
