
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gcpp_essalud/src/services/firestore.dart';

import 'package:gcpp_essalud/src/util/metodos.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
  Future<List<dynamic>> datos;
  CloudService cloud = new CloudService();
  List<dynamic> prueba = new List();
  List<dynamic> prueba2 = new List();
  List<dynamic> prueba3 = new List();
  List<dynamic> prueba4 = new List();
  List<dynamic> prueba5 = new List();
  @override
  void initState() {
    super.initState();
    listar();
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

   listar() async {
   cloud.listarDatos('PruebaInversiones').listen((QuerySnapshot snapshot) {
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
                   FutureBuilder(
                      future: datos,
                      builder: (BuildContext context,
                          AsyncSnapshot data) {
                        if (!data.hasData) {
                          return Center(child: new CircularProgressIndicator());
                        }
                        prueba = data.data.where((f)=>f['red']=='Total Gastos' 
                        && f['anno']==annoSeleccionado
                        && f['rubro']=='Total Gastos de Capital').toList();
                      return Container(
                          child: Column(
                              children:prueba.map((item) {
                        return Column(
                          children: <Widget>[
                            new CircularPercentIndicator(
                              radius: 120.0,
                              lineWidth: 13.0,
                              animation: true,
                              percent: verificarNumero(item['porcentaje']),
                              center: new Text(
                                me.formatearNumero(item['porcentaje'] * 100)
                                        .output
                                        .compactNonSymbol
                                        .toString() +
                                    '%',
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              header: Text(item['rubro'].toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                              footer: new Text(
                                me.formatearNumero(item['ejecucion'])
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
                                  .formatearNumero(item['pia'])
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
                                      f.parse(item['fecha']).toLocal()),
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
       FutureBuilder(
                      future: datos,
                      builder: (BuildContext context,
                          AsyncSnapshot data) {
                        if (!data.hasData) {
                          return Center(child: new CircularProgressIndicator());
                        }
                        prueba2 = data.data.where((f)=>
                        f['anno']==annoSeleccionado
                        && f['red']=='Total Gastos de Capital').toList();
                        prueba2.sort((a,b)=>a['rubro'].toString().compareTo(b['rubro'].toString()));
            return Container(
                child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20.0, // gap between adjacent chips
                    runSpacing: 8.0,
                    children: prueba2.map((item) {
                      return Column(
                        children: <Widget>[
                          new CircularPercentIndicator(
                            radius: 100.0,
                            lineWidth: 11.0,
                            animation: true,
                            percent: verificarNumero(item['porcentaje']),
                            center: new Text(
                              me.formatearNumero(item['porcentaje'] * 100)
                                      .output
                                      .compactNonSymbol
                                      .toString() +
                                  '%',
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                            header: Text(item['rubro'].toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                )),
                            footer: new Text(
                              me.formatearNumero(item['ejecucion'])
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
                                .formatearNumero(item['pia'])
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
         FutureBuilder(
                      future: datos,
                      builder: (BuildContext context,
                          AsyncSnapshot data) {
                        if (!data.hasData) {
                          return Center(child: new CircularProgressIndicator());
                        }
                        prueba3 = data.data.where((f)=>
                        f['anno']==annoSeleccionado
                        && f['red']=='3.1 Presupuesto de Inversiones').toList();
                        prueba3.sort((a,b)=>a['rubro'].toString().compareTo(b['rubro'].toString()));
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
                        children: prueba3.map((item) {
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
                                          item['porcentaje']),
                                      center: new Text(
                                        me.formatearNumero(
                                                    item['porcentaje'] *
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
                                          Text(item['rubro'].toString(),
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              )),
                                      footer: new Text(
                                        me.formatearNumero(item['ejecucion'])
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
                                          .formatearNumero(item['pia'])
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
                                    rubro1 = item['rubro'];
                                    if (item['rubro'] ==
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
        FutureBuilder(
                      future: datos,
                      builder: (BuildContext context,
                          AsyncSnapshot data) {
                        if (!data.hasData) {
                          return Center(child: new CircularProgressIndicator());
                        }
                        prueba4 = data.data.where((f)=>
                        f['anno']==annoSeleccionado
                        && f['red']==rubro1).toList();
                        prueba4.sort((a,b)=>a['rubro'].toString().compareTo(b['rubro'].toString()));
            return Container(
                child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20.0, // gap between adjacent chips
                    runSpacing: 8.0,
                    children: prueba4.map((item) {
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
                                      verificarNumero(item['porcentaje']),
                                  center: new Text(
                                    me.formatearNumero(
                                                item['porcentaje'] * 100)
                                            .output
                                            .compactNonSymbol
                                            .toString() +
                                        '%',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0),
                                  ),
                                  header: Text(item['rubro'].toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  footer: new Text(
                                    me.formatearNumero(item['ejecucion'])
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
                                      .formatearNumero(item['pia'])
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
                                rubro2 = item['rubro'];
                              });
                            },
                            onDoubleTap: () {
                              if (item['rubro'] == 'Obras') {
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
         FutureBuilder(
                      future: datos,
                      builder: (BuildContext context,
                          AsyncSnapshot data) {
                        if (!data.hasData) {
                          return Center(child: new CircularProgressIndicator());
                        }
                        prueba5 = data.data.where((f)=>
                        f['anno']==annoSeleccionado
                        && f['red']==rubro1
                        && f['rubro']==rubro2).toList();
                        prueba5.sort((a,b)=>a['rubro'].toString().compareTo(b['rubro'].toString()));
            return Wrap(
              children: prueba5.map((item) {
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
  Future<List<dynamic>> resultado;
  String nomRed;
   CloudService cloud = new CloudService();
  @override
  @override
  void initState() {
    super.initState();
    nomRed='LIMA';
    listar();
    resultado = cloud.listarDatosPorColeccion('Obras');
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


   listar() async {
    List<String> aux = new List();
    valores = new List();
    resultado = cloud.listarDatosPorColeccion('Obras');
    await new Future.delayed(new Duration(seconds: 1));
    resultado.then((f)=>f.map((f){
      setState(() {
          aux.add(f['red']);
      valores = aux.toSet().toList();
      });
     }).toList());
        
    await new Future.delayed(new Duration(seconds: 2));
      
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
            future: resultado,
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
                            ),       SizedBox(height: 5),
                                Text(
                                  me
                                      .formatearNumero(f['pia'])
                                      .output
                                      .withoutFractionDigits
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                    
                    ],
                  );
                }).toList()
              );
            }));
  }
}
