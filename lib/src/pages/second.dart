import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gcpp_essalud/src/modelos/redes.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  GoogleMapController _controller;
  List<Redes> redes;
  Position position;
  Widget _child;
  List<Widget> details = [];
  PanelController _pc = new PanelController();
  String titulo ='Todas las Redes';
  var data;

  loadJsonData() async {
    String jsonText = await rootBundle.loadString('local/redes.json');
    setState(() {
      data = json.decode(jsonText);
      redes = List();
      for (int i = 0; i < data.length; i++) {
        redes.add(new Redes(data[i]['DEPARTAM'].toString(),
            data[i]['coordinates'][0], data[i]['coordinates'][1]));
      }
    });
  }

  Future<void> getPermision() async {
    PermissionStatus permision = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (permision == PermissionStatus.denied) {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.locationAlways]);
    }
    var geolocator = Geolocator();

    GeolocationStatus geolocationStatus =
        await geolocator.checkGeolocationPermissionStatus();

    switch (geolocationStatus) {
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

  void showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void initState() {
    loadJsonData();
    getPermision();
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _child,
    );
  }

  void _getCurrentLocation() async {
    Position res = await Geolocator().getCurrentPosition();
    setState(() {
      position = res;
      _child = _mapWidget();
    });
  }

  Widget _mapWidget() {
    return Stack(
      children: <Widget>[
        GoogleMap(
          mapType: MapType.normal,
          markers: {
            for (Redes re in redes)
              if (re.nomRed.length > 0)
                Marker(
                  markerId: MarkerId(re.nomRed),
                  position: LatLng(re.longuitud, re.latitude),
                  onTap: () {
                    this.setState(() {
                      this.titulo=re.nomRed;
                      _pc.open();});
                  },
                )
          },
          myLocationButtonEnabled: true,
          initialCameraPosition: CameraPosition(
              target: LatLng(position.latitude, position.longitude), zoom: 5.0),
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
        ),
        slider()
      ],
    );
  }

  Widget slider() {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(40.0),
      topRight: Radius.circular(40.0),
    );

    return SlidingUpPanel(
      panel: Center(
        child: Text(this.titulo),
      ),
      borderRadius: radius,
      controller: _pc,
    );
  }
}
