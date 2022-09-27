
import 'package:flutter/material.dart';
import 'package:kick_my_flutter/ecran_inscription.dart';
import 'package:dio/dio.dart';
import 'package:kick_my_flutter/transfer.dart';
// import 'package:progress_dialog/progress_dialog.dart';

import 'ecran_accueil.dart';

import 'i18n/intl_localization.dart';
import 'lib_http.dart';

class EcranConnexion extends StatefulWidget {

  @override
  _EcranConnexionState createState() => _EcranConnexionState();
}

class _EcranConnexionState extends State<EcranConnexion> {

  String nomConnexion = "";
  String passwordConnexion = "";
  bool dialogVisible = false;

  // final ProgressDialog pr = ProgressDialog(context);
  // pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true/false, showLogs: true/false);

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Connexion en cours..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  connexion() async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showLoaderDialog(context);
      });
      SigninRequest req = SigninRequest();
      req.username = nomConnexion;
      req.password = passwordConnexion;
      var reponse = await signin(req);
      print(reponse);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EcranAccueil(),
        ),
      );

    } on DioError catch(e) {
      print(e);
      String message = e.response!.data;
      Navigator.of(context).pop();
      if (message == "BadCredentialsException") {
        print('login deja utilise');
      }
      else if(message == "InternalAuthenticationServiceException")
      {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            // title: const Text('AlertDialog Title'),
            content: const Text('Compte introuvable'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      else {
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // TODO decommenter la ligne suivante
      //  drawer: LeTiroir(),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(Locs.of(context).trans('Connexion')),
      ),
      body: Column(

      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(Locs.of(context).trans('Connexion'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50)),

          // const Text(
          //   'Nom',
          // ),
          Padding(
            padding: const EdgeInsets.all(50),
            child: TextFormField(
              decoration: InputDecoration(labelText: Locs.of(context).trans('Nom'),
                  labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Colors.grey
                    ),
                  )),
                onChanged: (nom) {
                  nomConnexion = nom;
                }
            ),
          ),
          // const Text(
          //   'Mot de passe',
          // ),
          Padding(
            padding: const EdgeInsets.all(50),
            child: TextFormField(
              decoration: InputDecoration(labelText: Locs.of(context).trans('Mot de passe'),
              labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey
                ),
              )),
              obscureText: true,
                onChanged: (password) {
                  passwordConnexion = password;
                }
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  child: MaterialButton(
                    child: Text(Locs.of(context).trans('Connexion')),
                    color: Colors.blue,
                    onPressed:
                      connexion,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EcranInscription(),
                        ),
                      );
                    },
                    child: Text(Locs.of(context).trans('Inscription')),
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}