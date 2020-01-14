import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
 
class SecondPage extends StatefulWidget{

@override
_SecondPageState createState()=> _SecondPageState();
}
class _SecondPageState extends State<SecondPage>{

  GoogleMapController _controller;
  Position position;
  Widget _child;

  Future<void> getPermision() async{
    PermissionStatus permision = await PermissionHandler()
    .checkPermissionStatus(PermissionGroup.location);
    if(permision==PermissionStatus.denied){
      await PermissionHandler()
            .requestPermissions([PermissionGroup.locationAlways]);
    }
var geolocator = Geolocator();

    GeolocationStatus geolocationStatus =
    await geolocator.checkGeolocationPermissionStatus();

      switch(geolocationStatus){
        case GeolocationStatus.denied:
        showToast('Acceso Denegado');
        break;
        case GeolocationStatus.disabled:
        showToast('Desactivado');
        break;
        case GeolocationStatus.restricted:
        showToast('Restricto');
        break;
        case GeolocationStatus.unknown:
        showToast('Desconocido');
        break;
        case GeolocationStatus.granted:
        showToast('Acceso Permitido');
        _getCurrentLocation();
        
              }
          }
        
          void showToast(message){
            Fluttertoast.showToast(
              msg: message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
            );
          }
@override
  void initState() {
    getPermision();
    super.initState();
  }



          @override
          Widget build(BuildContext context) {
            return Scaffold(
             body: _child,
            );
          }
        
          void _getCurrentLocation()async {
            Position res = await Geolocator().getCurrentPosition();
            setState(() {
              position = res;
              _child = _mapWidget();
                          });
                        }
                Set<Marker> _createMarker(){
                  return <Marker>[
                    Marker(markerId: MarkerId('home'),
                    position: LatLng(position.latitude, position.longitude),
                    icon: BitmapDescriptor.defaultMarker,
                    infoWindow: InfoWindow(title: "Mi posicion")
                    )
                  ].toSet();
                }
              
                Widget _mapWidget() {
                  return GoogleMap(
                    mapType: MapType.normal,
                    markers: _createMarker(),
                    initialCameraPosition: CameraPosition(
                      target: LatLng(position.latitude, position.longitude),
                      zoom: 5.0
                    ),
                    onMapCreated: (GoogleMapController controller){
                      _controller = controller;
                      
                    },
                  );
                }

}