import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gcpp_essalud/src/modelos/datos.dart';
import 'package:gcpp_essalud/src/services/firestore.dart';
import 'package:gcpp_essalud/src/util/metodos.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List<Datos> lista;
  List<Datos> detalleLista;
  String titulo;
  Random random = new Random();
  CloudService db = new CloudService();
  Color colorRubroIngresos;
  Color colorRubroEgresos;
  final f = new DateFormat('dd-MM-yyyy');
  final form = new DateFormat('dd/MM/yyyy');
  StreamSubscription<QuerySnapshot> noteSub;
  Metodos me = Metodos();
  List<String> anno;
  String annoSeleccionado;
  List<Widget> details = [];
  @override
  void initState() {
    getPermision();
    super.initState();
    colorRubroIngresos = Colors.purple;
    colorRubroEgresos = Colors.lime[50];
    annoSeleccionado = '2020';
    llenarLista('Ingresos');
    llenarListaDetalle('Ingresos Operativos');
    titulo = 'Ingresos Operativos';
    anno = new List();
    anno.add('2019');
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
            _buildCardDetalleIngresosOperativos(context)
          ],
        ),
      ),
    ));
  }

  llenarLista(String variable) {
    lista = new List();
    noteSub?.cancel();
    noteSub = db
        .getListDatos(variable, annoSeleccionado)
        .listen((QuerySnapshot snapshot) {
      List<Datos> datos = snapshot.documents
          .map((documentSnapshot) => Datos.fromMap(documentSnapshot.data))
          .toList();

      setState(() {
        datos.sort((a, b) => a.titulo.compareTo(b.titulo));
        this.lista = datos;
      });
    });
  }

  llenarListaDetalle(String variable) {
    detalleLista = new List();

    noteSub = db
        .getListDatos(variable, annoSeleccionado)
        .listen((QuerySnapshot snapshot) {
      List<Datos> datos = snapshot.documents
          .map((documentSnapshot) => Datos.fromMap(documentSnapshot.data))
          .toList();
      setState(() {
        datos.sort((a, b) => a.titulo.compareTo(b.titulo));
        this.detalleLista = datos;
      });
    });
  }

  @override
  void dispose() {
    noteSub?.cancel();
    super.dispose();
  }

  Future<void> getPermision() async {
    PermissionStatus permision = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (permision == PermissionStatus.denied) {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.locationAlways]);
    }
    var geolocator = Geolocator();

    GeolocationStatus geolocationStatus =
        await geolocator.checkGeolocationPermissionStatus();

    switch (geolocationStatus) {
      case GeolocationStatus.denied:
        break;
      case GeolocationStatus.disabled:
        break;
      case GeolocationStatus.restricted:
        break;
      case GeolocationStatus.unknown:
        break;
      case GeolocationStatus.granted:

      //_getCurrentLocation();
    }
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
                        .collection('Ingresos')
                        .where('padre', isEqualTo: 'Ingresos Totales')
                        .where('anno', isEqualTo: annoSeleccionado)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> data) {
                      if (!data.hasData) {
                        return Text('Cargando Informacion');
                      }
                      return GestureDetector(
                          child: Container(
                              child: Column(
                                  children: data.data.documents.map((item) {
                            return Column(
                              children: <Widget>[
                                new CircularPercentIndicator(
                                  radius: 120.0,
                                  lineWidth: 13.0,
                                  animation: true,
                                  percent:
                                      verificarNumero(item.data['porcentaje']),
                                  center: new Text(
                                    me
                                            .formatearNumero(
                                                item.data['porcentaje'] * 100)
                                            .output
                                            .compactNonSymbol
                                            .toString() +
                                        '%',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                  header: Text(item.data['titulo'].toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )),
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
                                  progressColor: colorRubroIngresos,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  me
                                      .formatearNumero(item.data['pia'])
                                      .output
                                      .withoutFractionDigits
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.grey),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "al " +
                                      form.format(f
                                          .parse(item.data['fecha'])
                                          .toLocal()),
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            );
                          }).toList())),
                          onTap: () {
                            colorRubroIngresos = Colors.purple;
                            colorRubroEgresos = Colors.lime[50];
                            llenarLista('Ingresos');
                            llenarListaDetalle('Ingresos Operativos');
                            titulo = 'Ingresos Operativos';
                          });
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('Ingresos')
                        .where('padre', isEqualTo: 'Egresos Totales')
                        .where('anno', isEqualTo: annoSeleccionado)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> data) {
                      if (!data.hasData) {
                        return Text('Cargando Informacion');
                      }
                      return GestureDetector(
                          child: Container(
                              child: Column(
                            children: data.data.documents.map((item) {
                              return Column(
                                children: <Widget>[
                                  new CircularPercentIndicator(
                                    radius: 120.0,
                                    lineWidth: 13.0,
                                    animation: true,
                                    percent: verificarNumero(
                                        item.data['porcentaje']),
                                    center: new Text(
                                      me
                                              .formatearNumero(
                                                  item.data['porcentaje'] * 100)
                                              .output
                                              .nonSymbol
                                              .toString() +
                                          '%',
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0),
                                    ),
                                    header: Text(item.data['titulo'].toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    footer: new Text(
                                      me
                                          .formatearNumero(
                                              item.data['ejecucion'])
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
                                        .formatearNumero(item.data['pia'])
                                        .output
                                        .withoutFractionDigits
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.grey),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "al " +
                                        form.format(f
                                            .parse(item.data['fecha'])
                                            .toLocal()),
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              );
                            }).toList(),
                          )),
                          onTap: () {
                            colorRubroEgresos = Colors.blue;
                            colorRubroIngresos = Colors.lime[50];
                            llenarLista('Egresos');
                            llenarListaDetalle('Gastos Operativos');
                            titulo = 'Gastos Operativos';
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
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 20.0, // gap between adjacent chips
      runSpacing: 8.0, // gap between lines
      children: lista.map((item) {
        return new Wrap(children: <Widget>[
          Column(
            children: <Widget>[
              CircularPercentIndicator(
                radius: 100,
                lineWidth: 11.0,
                animation: true,
                percent: verificarNumero(item.porcentaje),
                center: new Text(
                  me
                          .formatearNumero((item.porcentaje * 100))
                          .output
                          .nonSymbol
                          .toString() +
                      "%",
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12.0),
                ),
                header: Text(
                  item.titulo,
                  style:
                      new TextStyle(fontWeight: FontWeight.bold, fontSize: 9.0),
                ),
                footer: new Text(
                  me
                      .formatearNumero(item.ejecucion)
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
                    .formatearNumero(item.pia)
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
                llenarLista('Ingresos');
                llenarListaDetalle('Ingresos Operativos');
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
                      Text(item.titulo, style: new TextStyle(fontSize: 11.0)),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 5, 5, 10),
                        child: new LinearPercentIndicator(
                          width: MediaQuery.of(context).size.width - 100,
                          animation: true,
                          lineHeight: 16.0,
                          animationDuration: 2500,
                          percent: verificarNumero(item.porcentaje).toDouble(),
                          center: Text(
                              me
                                      .formatearNumero((item.porcentaje * 100))
                                      .output
                                      .nonSymbol
                                      .toString() +
                                  '%',
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12.0)),
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
  }
}

class MyWiget2 extends StatefulWidget {
  final List<Datos> datos;
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
        body: Container(color: Colors.white,
        
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
                    columns: [
                      DataColumn(label: Text("Rubro",style: TextStyle(fontWeight:FontWeight.bold ))),
                      DataColumn(label: Text("Pia",style: TextStyle(fontWeight:FontWeight.bold ))),
                      DataColumn(label: Text("Ejecucion",style: TextStyle(fontWeight:FontWeight.bold ))),
                       DataColumn(label: Text("%",style: TextStyle(fontWeight:FontWeight.bold ))),
                    ],
                    rows: widget.datos.map((f){
                      return DataRow(
                        cells: [
                        DataCell(Text(f.titulo)),
                        DataCell(Text(me
                            .formatearNumero(f.pia)
                            .output
                            .withoutFractionDigits
                            .toString())),
                        DataCell(Text(me
                            .formatearNumero(f.ejecucion)
                            .output
                            .withoutFractionDigits
                            .toString())),
                        DataCell(Text(me.formatearNumero(f.porcentaje * 100).output
                                      .nonSymbol.toString() +
                                        '%')),
                      ]);
                    }).toList(),
                    sortColumnIndex: 0,
                    sortAscending: true,
                  ))

        ),
          
        );
  }
}
