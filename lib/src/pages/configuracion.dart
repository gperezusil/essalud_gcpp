import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcpp_essalud/src/modelos/login_provider.dart';
import 'package:gcpp_essalud/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:gcpp_essalud/src/screen/login.dart';

class Configuracion extends StatefulWidget {
 
  @override
  _ConfiguracionState createState() => _ConfiguracionState();
}

class _ConfiguracionState extends State<Configuracion> {
 final prefs = new PreferenciasUsuario();
 final usuarioProvider = new LoginProvider();
 double iconSize = 40;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 5, 5),
              child: Column(
                children:<Widget>[
                   Text('Datos Personales del Usuario',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18 
                      ),),
                        SizedBox(height: 20,),
           Table(
                border: TableBorder.symmetric(),
                columnWidths: {0: FractionColumnWidth(.2), 1: FractionColumnWidth(.8)},
                children: [
                  TableRow( children: [
                    Column(children:[
                      Text('Nombre',style: TextStyle(
                        fontWeight: FontWeight.bold 
                      ),),
                      SizedBox(height: 20,),
                       Text('Correo',style:TextStyle(
                        fontWeight: FontWeight.bold )),
                       
                    ]),
                    Column(children:[
                      Text(prefs.nombre),
                       SizedBox(height: 20,),
                      Text(prefs.email),
              
                    ]),
                  ]),
                ],
    ),
     SizedBox(height: 20,),
    RaisedButton(
  child: Text("Cerrar Sesion"),
  color: Colors.blue,
  textColor: Colors.white,
  disabledColor: Colors.grey,
  disabledTextColor: Colors.black,
  padding: EdgeInsets.all(8.0),
  splashColor: Colors.blueAccent,
  onPressed : () {
      prefs.email='';
      prefs.nombre='';
      prefs.token='';
        usuarioProvider.cerrarSesion().whenComplete((){
 Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginPage()));
        });
      
   },
),])));
  }
}