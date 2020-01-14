import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference noteCollection = Firestore.instance.collection('Ingresos');

class CloudService{
    static final CloudService _instance = new CloudService.internal();
 
  factory CloudService() => _instance;
 
  CloudService.internal();

    Stream<QuerySnapshot> getListDatos(String variable,{int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = 
    noteCollection.where('padre',isEqualTo: variable ).orderBy('ejecucion',descending: true)
    .snapshots();
 
    
  
    return snapshots;
  }
}