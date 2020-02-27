import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:gcpp_essalud/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginProvider {
  final String _firebaseToken = 'AIzaSyCfqKEmVZG_CdY5sSBwt9xXV2IIAz8wXrQ';
  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=$_firebaseToken',
        body: json.encode(authData));

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];
      _prefs.email = decodedResp['email'];
      _prefs.nombre = decodedResp['displayName'];

      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }
  }

  Future<Map<String, dynamic>> login2(String email, String pass) async {
    Map<String, dynamic> decodedResp;
    AuthResult user;
    try {
      user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
      await user.user.getIdToken(refresh: true).then((d)=>_prefs.token=d.token);
      _prefs.email = user.user.email;
      _prefs.nombre = user.user.displayName;
      return decodedResp = {
        'ok': true,
        'token': user.user.getIdToken(refresh: true).toString()
      };
    } catch (err) {
      return decodedResp = {'ok': false, 'mensaje': 'Error al iniciar Sesion'};
    } finally {
      if (user != null) {
        decodedResp = {
          'ok': true,
          'token': user.user.getIdToken(refresh: true).toString()
        };
      } else {
        decodedResp = {'ok': false, 'mensaje': 'error'};
      }
    }
  }

  Future<void> cerrarSesion()async {
    return await FirebaseAuth.instance.signOut();
  }
}
