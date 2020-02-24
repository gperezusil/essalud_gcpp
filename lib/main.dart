import 'package:flutter/material.dart';
import 'package:gcpp_essalud/src/pages/home.dart';
import 'package:gcpp_essalud/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:gcpp_essalud/src/screen/login.dart';
 
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
    
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      final prefs = new PreferenciasUsuario();
      print( prefs.token );
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Ejecucion Presupuestal',
      home: prefs.token!=''?HomePage():LoginPage()
    );
  }
}