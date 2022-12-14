import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kick_my_flutter/ecran_connexion.dart';
import 'package:kick_my_flutter/ecran_creation.dart';
import 'package:kick_my_flutter/lib_http.dart';
import 'package:kick_my_flutter/transfer.dart';

import 'ecran_accueil.dart';
import 'i18n/intl_localization.dart';


class LeTiroir extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => LeTiroirState();
}

class LeTiroirState extends State<LeTiroir> {

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text( Locs.of(context).trans ("Deconnexion en cours..." ))),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  deconnexion() async {
    try {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showLoaderDialog(context);
        });
      var reponse = await signout();
      print(reponse);
      Navigator.pop(context);


        Navigator.of(context)
          .pushNamedAndRemoveUntil('/ecranconnexion', (Route<dynamic> route) => false);
    }
    on DioError catch(e) {
      print(e);
      Navigator.of(context).pop();
      if(e.response == null)
      {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            // title: const Text('AlertDialog Title'),
            content:  Text(Locs.of(context).trans("Erreur réseau")),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      else{
        String message = e.response!.data;
        Navigator.of(context).pop();
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
          title: Text(Locs.of(context).trans('Accueil')),
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
          title: Text(Locs.of(context).trans('Ajout de taches')),
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
          title: Text(Locs.of(context).trans('Deconnexion')),
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
