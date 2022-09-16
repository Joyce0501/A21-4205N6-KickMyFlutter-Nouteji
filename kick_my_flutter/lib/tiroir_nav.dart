import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kick_my_flutter/ecran_connexion.dart';
import 'package:kick_my_flutter/ecran_creation.dart';
import 'package:kick_my_flutter/lib_http.dart';
import 'package:kick_my_flutter/transfer.dart';

import 'ecran_accueil.dart';


class LeTiroir extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => LeTiroirState();
}

class LeTiroirState extends State<LeTiroir> {

  deconnexion() async {
    try {
      var reponse = await signout();
      print(reponse);

      Navigator.of(context)
          .pushNamedAndRemoveUntil('/ecranconnexion', (Route<dynamic> route) => false);
    }
    on DioError catch(e) {
      print(e);
      String message = e.response!.data;
      if (message == "BadCredentialsException") {
        print('login deja utilise');
      } else {
        print('autre erreurs');

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Erreur authentification')
            )
        );
      }

    }
  }

  @override
  void initState() {
  //  deconnexion();
  }


  @override
  Widget build(BuildContext context) {


    var listView = ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(height: 100,),

        ListTile(
          dense: true,
          leading: Icon(Icons.person),
          title: Text(lenom.toString()),
        ),

        ListTile(
          dense: true,
          leading: Icon(Icons.home),
          title: Text("Accueil"),
          onTap: () {
            // TODO ferme le tiroir de navigation
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EcranAccueil(),
              ),
            );
            // Then close the drawer
          },
        ),

        // TODO le tiroir de navigation ne peut pointer que vers des
        // ecran sans paramtre.
        ListTile(
          dense: true,
          leading: Icon(Icons.add_task),
          title: Text("Ajout de taches"),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EcranCreation(),
              ),
            );
            // Then close the drawer
          },
        ),

        ListTile(
          dense: true,
          leading: Icon(Icons.logout),
          title: Text("deconnexion"),
          onTap:
            //  () async {

            deconnexion,

            // Navigator.of(context).pop();
            // Navigator.push(
            //   context,
          //   MaterialPageRoute(
          //     builder: (context) => EcranConnexion(),
          //   ),
          // );
            // Then close the drawer
       //   },

        ),

      ],
    );

    return Drawer(
      child: new Container(
        color: const Color(0xFFFFFFFF),
        child: listView,
      ),
    );
  }
}
