import 'package:flutter/material.dart';
import 'package:gcpp_essalud/src/pages/first.dart';
import 'package:gcpp_essalud/src/pages/inversiones.dart';
import 'package:gcpp_essalud/src/pages/material.dart';
import 'package:gcpp_essalud/src/pages/second.dart';
import 'package:gcpp_essalud/src/pages/sede.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
 
class HomePage extends StatefulWidget {
  _HomeState createState()=>_HomeState();
}

class _HomeState extends State<HomePage>{
   List<ScreenHiddenDrawer> items = new List();
@override
  void initState() {
    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: 'Institucional',
          baseStyle:
          TextStyle( color: Colors.white.withOpacity(0.8), 
          fontSize: 16.0  ),
          colorLineSelected: Colors.white,
        ),
        FirstPage()));

    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: 'Redes Asistenciales',
          baseStyle: TextStyle( color: Colors.white.withOpacity(0.8), fontSize: 16.0 ),
          colorLineSelected: Colors.white,
          
        ),
        SecondPage()));
          items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: 'Material Estrategico',
          baseStyle: TextStyle( color: Colors.white.withOpacity(0.8), fontSize: 16.0 ),
          colorLineSelected: Colors.teal,
        ),
        MaterialEstrategico()));
          items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: 'Sede Central',
          baseStyle: TextStyle( color: Colors.white.withOpacity(0.8), fontSize: 16.0 ),
          colorLineSelected: Colors.teal,
        ),
        SedeCentral()));
           items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: 'Inversiones',
          baseStyle: TextStyle( color: Colors.white.withOpacity(0.8), fontSize: 16.0 ),
          colorLineSelected: Colors.teal,
        ),
        InversionesPage()));
          

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
     return WillPopScope(
       onWillPop: ()async =>false,
       child: HiddenDrawerMenu(
             backgroundColorMenu: Colors.blue,
      backgroundColorAppBar: Colors.blue,
      screens: items,
        //    typeOpen: TypeOpen.FROM_RIGHT,
           enableScaleAnimin: true,
          enableCornerAnimin: true,
         slidePercent: 70.0,
          verticalScalePercent: 90.0,
         contentCornerRadius: 40.0,
        //    iconMenuAppBar: Icon(Icons.menu),
        //    backgroundContent: DecorationImage((image: ExactAssetImage('assets/bg_news.jpg'),fit: BoxFit.cover),
           whithAutoTittleName: true,
           //styleAutoTittleName: TextStyle(color: Colors.red),
        //    actionsAppBar: <Widget>[],
        //    backgroundColorContent: Colors.blue,
           elevationAppBar: 4.0,
        //    tittleAppBar: Center(child: Icon(Icons.ac_unit),),
        //    enableShadowItensMenu: true,
        
    ));
  }


}