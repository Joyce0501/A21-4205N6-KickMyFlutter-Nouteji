
import 'package:flutter/material.dart';

class EcranInscription extends StatefulWidget {

  @override
  _EcranInscriptionState createState() => _EcranInscriptionState();
}

class _EcranInscriptionState extends State<EcranInscription> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO decommenter la ligne suivante
    //  drawer: LeTiroir(),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Inscription'),
      ),
      body: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[


        ],
      ),
    );
  }
}