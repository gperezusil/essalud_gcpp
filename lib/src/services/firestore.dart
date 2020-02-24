import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference noteCollection = Firestore.instance.collection('Ingresos');

class CloudService{
    static final CloudService _instance = new CloudService.internal();

  factory CloudService() => _instance;
 
  CloudService.internal();

 
     Stream<QuerySnapshot> listarDatos(String colec,{int offset, int limit}) {
    CollectionReference coleccion = Firestore.instance.collection(colec);
    Stream<QuerySnapshot> snapshots = coleccion.snapshots();
 
  
    return snapshots;
  }

    Future<List<dynamic>> listarDatosPorColeccion(String coleccion) async
  {
      List<dynamic> aux = new List();
      
        listarDatos(coleccion)
        .listen((QuerySnapshot snapshot) {
            snapshot.documents.map((f){
              f.data.values.map((d){
               aux.add(d);     
                }).toList();
              }).toList();
    });
   
    return aux;
  }

  Future<String> convertirFecha(String aux) async{
  
  return aux;

}
Future<List<dynamic>> convertir(List<dynamic> aux) async{
  
  return aux;

}
Future<List<dynamic>> vacio() async{
  List<dynamic> aux = new List();
  return aux;

}



}