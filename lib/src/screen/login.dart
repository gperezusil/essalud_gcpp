import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:gcpp_essalud/src/modelos/login_provider.dart';
import 'package:gcpp_essalud/src/pages/home.dart';


class LoginPage extends StatelessWidget {
  final usuarioProvider = new LoginProvider();

  Duration get loginTime => Duration(milliseconds: 2250);
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'GCPP',
      onLogin: _authUser,
      onSignup: _authUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
      },
      messages: LoginMessages(
          usernameHint: 'Correo',
          passwordHint: 'Contraseña',
          loginButton: 'Ingresar',
          signupButton: 'Registrar',
          forgotPasswordButton: '¿Olvidaste la Contraseña ?'),
      //onRecoverPassword: _recoverPassword,
      theme: LoginTheme(
        titleStyle: TextStyle(
          color: Colors.white,
          fontFamily: 'Quicksand',
          letterSpacing: 4,
        ),
      ),
    );
  }

  Future<String> _authUser(LoginData data) async {
    Map info = await usuarioProvider.login(data.name, data.password); 
    
      if (info['ok']) {
        return null;
      } else {
        return info['mensaje'];
      }
    
  }


}
