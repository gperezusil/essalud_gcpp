import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../modelos/login_provider.dart';
import '../pages/home.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final usuarioProvider = new LoginProvider();
  String variable;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: obtener(),
      builder: (BuildContext context, AsyncSnapshot data) {
        if (!data.hasData) {
          return Scaffold(
      backgroundColor: Colors.grey[200],
      body :Center(child: new CircularProgressIndicator()));
          
          
        }
        return MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            debugShowCheckedModeBanner: false,
            title: 'Ejecucion Presupuestal',
            home: (data.data)?HomePage():cambiarPass(context));
      },
    );
  }

  Future<bool> obtener() async {
    return await usuarioProvider.obtenerEstado();
  }



  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {},
  );
  InputDecoration inputDecoration4 = InputDecoration(
    hintText: 'Contraseña',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    fillColor: Colors.grey[100],
    filled: true,
    suffixIcon: Icon(
      Icons.announcement,
      color: Colors.black,
    ),
  );

  Widget cambiarPass(context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Cambio de Contraseña'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          heightFactor: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Bienvenido al Aplicativo de Ejecucion Presupuestal",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                  decoration: inputDecoration4,
                  obscureText: true,
                  onChanged: (value) {
                    this.variable = value;
                  }),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                child: Text(
                  "Cambiar Contraseña",
                  style: TextStyle(fontSize: 20),
                ),
                color: Colors.blue,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.all(10),
                splashColor: Colors.blueAccent,
                onPressed: () {
                  if (this.variable != null && this.variable.length > 6) {
                    usuarioProvider
                        .cambiarContrasena(this.variable)
                        .whenComplete(() {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
