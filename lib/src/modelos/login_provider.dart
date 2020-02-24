import 'package:gcpp_essalud/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class LoginProvider{
    final String _firebaseToken = 'AIzaSyCfqKEmVZG_CdY5sSBwt9xXV2IIAz8wXrQ';
     final _prefs = new PreferenciasUsuario();


    Future<Map<String, dynamic>> login( String email, String password) async {

    final authData = {
      'email'    : email,
      'password' : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=$_firebaseToken',
      body: json.encode( authData )
    );

    Map<String, dynamic> decodedResp = json.decode( resp.body );


    if ( decodedResp.containsKey('idToken') ) {
      
      _prefs.token = decodedResp['idToken'];

      return { 'ok': true, 'token': decodedResp['idToken'] };
    } else {
      return { 'ok': false, 'mensaje': decodedResp['error']['message'] };
    }

  }
}