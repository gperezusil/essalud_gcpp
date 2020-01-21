import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:gcpp_essalud/src/util/metodos.dart';
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
  DocumentSnapshot lista;
  Metodos me = new Metodos();
  @override
  Widget build(BuildContext context) {
    String red = widget.red;
    return Center(
      child: Column(
        children: <Widget>[
          Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 5, 5),
              child: Text(red,
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0)),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('Redes')
                .where('red', isEqualTo: red)
                .where('rubro', isEqualTo: 'SUB-TOTAL')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
              if (!data.hasData) {
                return Text('Cargando Informacion');
              }
              return GestureDetector(
                  child: Container(
                      child: Column(
                    children: [
                      new CircularPercentIndicator(
                        radius: 130.0,
                        lineWidth: 15.0,
                        animation: true,
                        percent: me.verificarNumero(
                            data.data.documents[0]['porcentaje']),
                        center: new Text(
                          me
                                  .formatearNumero(data.data.documents[0]
                                          ['porcentaje'] *
                                      100)
                                  .output
                                  .nonSymbol
                                  .toString() +
                              '%',
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        footer: new Text(
                          me
                              .formatearNumero(
                                  data.data.documents[0]['ejecucion'])
                              .output
                              .withoutFractionDigits
                              .toString(),
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.purple,
                      )
                    ],
                  )),
                  );
            },
          ),
          SizedBox(height: 20),
          detalleRedes(context, red),
          SizedBox(height: 20),
          detalleRedesCompromisos(context)
        ],
      ),
    );
  }
  

  Widget detalleRedes(context, String red) {
    return Wrap(
      children: <Widget>[
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('Redes')
              .where('red', isEqualTo: red)
              .where('rubro',
                  whereIn: ['PERSONAL', 'BIENES', 'SERVICIOS'])
                 .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
            if (!data.hasData) {
              return Text('Cargando Informacion');
            }
            return Column(children: <Widget>[
              Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20.0, // gap between adjacent chips
                  runSpacing: 8.0,
                  children: data.data.documents.map((item) {  
                   lista = item;
                    return new Wrap(children: <Widget>[
                      GestureDetector(
                        child: CircularPercentIndicator(
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
                        onTap: () {
                          setState(() {
                            this.lista = item;
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

  Widget detalleRedesCompromisos(BuildContext context) {

    if(lista==null){
      return Text("Cargando Informacion");
    }
    return Container(
        child: Column(
          children: [
            Text(this.lista['rubro'],
           style: new TextStyle(
           fontWeight: FontWeight.bold, fontSize: 15.0)),
           SizedBox(height: 10),
      Wrap(
        children: <Widget>[
          Row(
            children: <Widget>[
                      DataTable(
          columns: [
            DataColumn(
              label: Text("Tipo de Compromisos")),
            DataColumn(label: Text("Soles"))],
          rows: [
          DataRow(cells: [
          DataCell(Text("Solicitud de Pedidos")),
          DataCell(Text(me.formatearNumero(this.lista.data['solped']).output.withoutFractionDigits.toString())),]),
          DataRow(cells: [DataCell(Text("Pedidos")),
          DataCell(Text(me.formatearNumero(this.lista.data['pedido']).output.withoutFractionDigits.toString())),]),
          DataRow(cells: [DataCell(Text("Reservas")),
          DataCell(Text(me.formatearNumero(this.lista.data['reserva']).output.withoutFractionDigits.toString())),
          ]),
          DataRow(cells: [DataCell(Text("Total",style: new TextStyle(
           fontWeight: FontWeight.bold, fontSize: 15.0))),
          DataCell(Text(me.formatearNumero(this.lista.data['comprometido']).output.withoutFractionDigits.toString(),
          style: new TextStyle(
           fontWeight: FontWeight.bold, fontSize: 15.0)),
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
      ),
    ]));
  }
}
