import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gcpp_essalud/src/preferencias_usuario/preferencias_usuario.dart';


class LoginProvider {
  final _prefs = new PreferenciasUsuario();
  final bool estado=false;

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

  Future<void> cambiarContrasena(String pass) async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    //Pass in the password to updatePassword.
    user.updatePassword(pass).then((_){
      Firestore.instance.collection('Usuarios').document(user.uid).updateData({'emailVerified':true});
    }).catchError((error){
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }

  Future<void> cerrarSesion()async {
    return await FirebaseAuth.instance.signOut();
  }

  Future<bool> obtenerEstado()async {
    bool estado=false;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
     await Firestore.instance.collection('Usuarios').document(user.uid).get().then((onValue){
           estado=  onValue.data['emailVerified'] as bool; 
     });
     return estado;
  }
}
