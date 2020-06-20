import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcpp_essalud/src/modelos/redes.dart';
import 'package:gcpp_essalud/src/util/metodos.dart';
import 'package:gcpp_essalud/src/pages/detalleRed.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:location/location.dart';
class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final Location location = Location();
  PermissionStatus _permissionGranted;
  LocationData _location;
  String _error='ee';
  GoogleMapController _controller;
  List<Redes> redes;
  List<Widget> details = [];
  PanelController _pc = new PanelController();
  Metodos me = new Metodos();
  Redes buscarDireccion;

  Widget wid;
  var data;



  Future<void>    _checkPermissions() async {
    final PermissionStatus permissionGrantedResult =
        await location.hasPermission();
      if(permissionGrantedResult!=PermissionStatus.granted){
          _requestPermission();
      }
       setState(() {
          _permissionGranted=permissionGrantedResult;
      });
  }

   Future<void> _requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestedResult =
          await location.requestPermission();
      setState(() {
        _permissionGranted = permissionRequestedResult;
      });
      if (permissionRequestedResult != PermissionStatus.granted) {
        return;
      }
    }
  }
  Future<LocationData> _getLocation() async {
      _location = await location.getLocation();

      return  _location;
    
  }
  

loadJsonData() async {
    String jsonText = await rootBundle.loadString('local/redes.json');
    setState(() {
      data = json.decode(jsonText);
      redes = List();
      for (int i = 0; i < data.length; i++) {
        redes.add(new Redes(data[i]['DEPARTAM'].toString(),
            data[i]['coordinates'][0], data[i]['coordinates'][1]));
      }
      redes.sort((a,b)=>a.nomRed.compareTo(b.nomRed));
    });
  
  }


  @override
  void initState() {
    super.initState();
    _checkPermissions();
   loadJsonData();
    details.add(DetalleRed(red: 'TOTAL'));
  
  }

  @override
  Widget build(BuildContext context) {
    if(_permissionGranted==PermissionStatus.granted){
            return Scaffold(
        body: FutureBuilder(
            future: _getLocation(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: new CircularProgressIndicator());
              }
             return _mapWidget(context,snapshot);
            }));
    }else{
     
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Se requiere ubicacion para mostrar esta informacion.'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton.icon(
                icon: Icon(Icons.location_on,color: Colors.white,),
                onPressed: () {
                  _checkPermissions();
                },
                color: Colors.blue,
                label: Text("Permitir Ubicacion", style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      );
    }

  }

  Widget _panel(context) {
    return SingleChildScrollView(
        child: Column(
          children: details,
        ),
    );
  }



  Widget _mapWidget(context,AsyncSnapshot<dynamic> datos) {
    return SlidingUpPanel(
      maxHeight:MediaQuery.of(context).size.height * .70 ,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
                target: LatLng(datos.data.latitude, datos.data.longitude),
                zoom: 5.0),
            mapType: MapType.normal,
            markers: {
              for (Redes red in redes)
                if (red.nomRed.length > 0)
                  Marker(
                    markerId: MarkerId(red.nomRed),
                    position: LatLng(red.longuitud, red.latitude),
                    onTap: () {
                      this.setState(() {
                        details.clear();
                        details.add(DetalleRed(red: red.nomRed));
                        _pc.open();
                   
                      });
                    },
                  )
            },
            myLocationButtonEnabled: false,
            rotateGesturesEnabled: false,
          ),
          Positioned(
              top: 15.0,
              right: 15.0,
              left: 15.0,
              child: Center(
                  child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: DropdownButton<Redes>(
                    value: buscarDireccion,
                    hint: Text("Seleccione Red"),
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    onChanged: (Redes data) {
                      setState(() {
                        buscarDireccion = data;
                        _controller.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                target: LatLng(buscarDireccion.longuitud,
                                    buscarDireccion.latitude),
                                zoom: 10.0)));
                              details.clear();
                        details.add(DetalleRed(red: buscarDireccion.nomRed));
                        _pc.open();

                      });
                    },
                    items: redes.map<DropdownMenuItem<Redes>>((Redes valor) {
                      return DropdownMenuItem<Redes>(
                        value: valor,
                        child: Text(valor.nomRed),
                      );
                    }).toList(),
                  ),
                ),
              )))
        ],
      ),
      panel: _panel(context),
      borderRadius: border(),
      controller: _pc,
      backdropEnabled: true,
      parallaxEnabled: true,
      parallaxOffset: .5,
      defaultPanelState: PanelState.OPEN,
    );
  }

  BorderRadiusGeometry border() {
    return BorderRadius.only(
      topLeft: Radius.circular(40.0),
      topRight: Radius.circular(40.0),
    );
  }

  void onMapCreated(controller) async {
    setState(() {
      _controller = controller;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
