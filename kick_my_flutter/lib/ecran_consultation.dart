
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kick_my_flutter/lib_http.dart';
import 'package:kick_my_flutter/transfer.dart';


class EcranConsultation extends StatefulWidget {

  final String le_parametre;

  const EcranConsultation({Key? key, required this.le_parametre}) : super(key: key);


  @override
  _EcranConsultationState createState() => _EcranConsultationState();
}

class _EcranConsultationState extends State<EcranConsultation> {


  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // TODO decommenter la ligne suivante
        //   drawer: LeTiroir(),
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('Accueil'),
        ),
        //   body: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        // children: <Widget>[
        //
        //
        // ],
        //   ),

      body: Column(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[

            ],
          ),
      );

  }
}