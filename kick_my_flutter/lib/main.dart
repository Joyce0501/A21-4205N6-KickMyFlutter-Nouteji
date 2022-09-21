import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kick_my_flutter/ecran_connexion.dart';
import 'package:kick_my_flutter/ecran_consultation.dart';
import 'package:kick_my_flutter/ecran_inscription.dart';


import 'ecran_accueil.dart';
import 'ecran_creation.dart';
import 'i18n/intl_delegate.dart';

void main() {runApp(MyApp());}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(


      // TODO enregistrer les delegate pour la traduction
      localizationsDelegates: [
        DemoDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // TODO annoncer les locales qui sont gerees
      supportedLocales: [
        const Locale('en'),
        const Locale('fr'),
      ],

    //  title: 'Flutter Demo',

      home: EcranConnexion(),
      routes: routes(),

    );
  }

  Map<String, WidgetBuilder> routes() {
    return {
      '/ecranconnexion': (context) => EcranConnexion(),
      '/ecraninscription': (context) => EcranInscription(),
      '/ecranaccueil': (context) => EcranAccueil(),
      '/ecrancreation': (context) => EcranCreation(),
      '/ecranconsultation': (context) => EcranConsultation(le_parametre: 0,),

    };
  }
}