import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gcpp_essalud/src/modelos/datos.dart';
import 'package:gcpp_essalud/src/services/firestore.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

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

  StreamSubscription<QuerySnapshot> noteSub;
  @override
  void initState() {
    super.initState();
    llenarLista('Ingresos');
    llenarListaDetalle('Ingresos Operativos');
    titulo = 'Ingresos Operativos';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
        child: ListView(
          children: <Widget>[
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

  FlutterMoneyFormatter formatearNumero(double variable) {
    return FlutterMoneyFormatter(amount: variable.toDouble());
  }

  llenarLista(String variable) {
    lista = new List();
    noteSub?.cancel();
    noteSub = db.getListDatos(variable).listen((QuerySnapshot snapshot) {
      List<Datos> datos = snapshot.documents
          .map((documentSnapshot) => Datos.fromMap(documentSnapshot.data))
          .toList();
      setState(() {
        this.lista = datos;
      });
    });
  }

  llenarListaDetalle(String variable) {
    detalleLista = new List();

    noteSub = db.getListDatos(variable).listen((QuerySnapshot snapshot) {
      List<Datos> datos = snapshot.documents
          .map((documentSnapshot) => Datos.fromMap(documentSnapshot.data))
          .toList();
      setState(() {
        this.detalleLista = datos;
      });
    });
  }

  @override
  void dispose() {
    noteSub?.cancel();
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
                        .collection('Ingresos')
                        .where('padre', isEqualTo: 'Ingresos Totales')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> data) {
                      if (!data.hasData) {
                        return Text('Cargando Informacion');
                      }
                      return GestureDetector(
                          child: Container(
                              child: Column(
                            children: [
                              Center(
                                  child: Text(
                                data.data.documents[0]['titulo'].toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                              new CircularPercentIndicator(
                                radius: 120.0,
                                lineWidth: 13.0,
                                animation: true,
                                percent: verificarNumero(
                                    data.data.documents[0]['porcentaje']),
                                center: new Text(
                                  formatearNumero(data.data.documents[0]['porcentaje'] * 100).output.compactNonSymbol.toString() +
                                      '%',
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                footer: new Text(
                                  formatearNumero(
                                          data.data.documents[0]['ejecucion'])
                                      .output
                                      .withoutFractionDigits
                                      .toString(),
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: Colors.purple,
                              )
                            ],
                          )),
                          onTap: () {
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
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> data) {
                      if (!data.hasData) {
                        return Text('Cargando Informacion');
                      }
                      return GestureDetector(
                          child: Container(
                              child: Column(
                            children: [
                              Center(
                                  child: Text(
                                data.data.documents[0]['titulo'].toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                              new CircularPercentIndicator(
                                radius: 120.0,
                                lineWidth: 13.0,
                                animation: true,
                                percent: verificarNumero(
                                    data.data.documents[0]['porcentaje']),
                                center: new Text(
                                    formatearNumero(data.data.documents[0]['porcentaje'] * 100).output.nonSymbol.toString() +
                                      '%',
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                footer: new Text(
                                  formatearNumero(
                                          data.data.documents[0]['ejecucion'])
                                      .output
                                      .withoutFractionDigits
                                      .toString(),
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: Colors.blue,
                              )
                            ],
                          )),
                          onTap: () {
                            llenarLista('Egresos');
                            llenarListaDetalle('Gastos Operativos');
                            titulo = 'Gastos Operativos';
                          });
                    },
                  )
                ],
              )
            ],
          ),
        ),
        height: 200,
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
          CircularPercentIndicator(
            radius: 100,
            lineWidth: 11.0,
            animation: true,
            percent: verificarNumero(item.porcentaje),
            center: new Text(
              formatearNumero((item.porcentaje * 100)).output.nonSymbol.toString() + "%",
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
            ),
            header: Text(
              item.titulo,
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 9.0),
            ),
            footer: new Text(
              formatearNumero(item.ejecucion)
                  .output
                  .withoutFractionDigits
                  .toString(),
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: Color.fromARGB(255, random.nextInt(255),
                random.nextInt(255), random.nextInt(255)),
          ),
        ]);
      }).toList(),
    );
  }

  Widget _buildCardDetalleIngresosOperativos(context) {
    return Card(
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
            child: 
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 5,5),
                      child: Text(titulo,style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0))
                    )
                   ,              
                    Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 5, 15),
                child : Column(
                  children: 
                  detalleLista.map((item){
                    return  Column(
                      children: <Widget>[
                        Text(item.titulo,
                            style: new TextStyle(fontSize: 11.0)),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 5, 5, 10),
                          child: new LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width - 100,
                            animation: true,
                            lineHeight: 16.0,
                            animationDuration: 2500,
                            percent: verificarNumero(item.porcentaje).toDouble(),
                            center: Text(
                              formatearNumero((item.porcentaje*100)).output.nonSymbol.toString()+'%',
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0)),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor:  Color.fromARGB(255, random.nextInt(255),
                random.nextInt(255), random.nextInt(255)),
                          ),
                        )
                      ],
                    );
                  }).toList())
                )]

                )));
  }
}
