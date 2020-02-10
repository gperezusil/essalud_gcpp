import 'package:flutter/material.dart';
import 'package:gcpp_essalud/src/pages/home.dart';
 
void main(){
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Ejecucion Presupuestal',
      home: HomePage()
    );
  }
}