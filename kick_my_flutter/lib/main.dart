import 'package:flutter/material.dart';
import 'package:kick_my_flutter/ecran_connexion.dart';
import 'package:kick_my_flutter/ecran_inscription.dart';
import 'package:dio/dio.dart';

void main() {runApp(MyApp());}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EcranConnexion(),
      routes: routes(),
    );
  }

  Map<String, WidgetBuilder> routes() {
    return {
      '/ecranconnexion': (context) => EcranConnexion(),
      '/ecraninscription': (context) => EcranInscription(),
   //   '/ecranaccueil': (context) => EcranAccueil(),
    };
  }
}