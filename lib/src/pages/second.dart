import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gcpp_essalud/src/modelos/redes.dart';
import 'package:gcpp_essalud/src/util/metodos.dart';
import 'package:gcpp_essalud/src/pages/detalleRed.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  GoogleMapController _controller;
  List<Redes> redes;
  Position position;
  List<Widget> details = [];
  PanelController _pc = new PanelController();
  Metodos me = new Metodos();
  Redes buscarDireccion;

  Widget wid;
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
      redes.sort((a,b)=>a.nomRed.compareTo(b.nomRed));
    });
  
  }

 

  void showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void initState() {
    super.initState();
    loadJsonData();
    details.add(DetalleRed(red: 'TOTAL'));
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: _getCurrentLocation(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: new CircularProgressIndicator());
              }
              return _mapWidget(context);
            }));
  }

  Widget _panel(context) {
    return SingleChildScrollView(
        child: Column(
          children: details,
        ),
    );
  }

  Future<Position> _getCurrentLocation() async {
    await Geolocator().getCurrentPosition().then((response) =>position=response);
    return position;
  }

  Widget _mapWidget(context) {
    return SlidingUpPanel(
      maxHeight:MediaQuery.of(context).size.height * .70 ,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
                target: LatLng(position.latitude, position.longitude),
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
