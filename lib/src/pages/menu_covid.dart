import 'package:flutter/material.dart';

class MenuCovidPage extends StatefulWidget {
  @override
  _MenuCovidPageState createState() => _MenuCovidPageState();
}

class _MenuCovidPageState extends State<MenuCovidPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            new RaisedButton(
              textColor: Theme.of(context).accentColor,
              color: Colors.red,
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                "Subtract",
              ),
            ),
            new RaisedButton(
              textColor: Theme.of(context).accentColor,
              color: Colors.red,
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                "Subtract",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
