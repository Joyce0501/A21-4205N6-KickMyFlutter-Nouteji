
import 'package:flutter/material.dart';
import 'package:kick_my_flutter/ecran_inscription.dart';
import 'package:dio/dio.dart';
import 'package:kick_my_flutter/transfer.dart';

import 'lib_http.dart';

class EcranConnexion extends StatefulWidget {

  @override
  _EcranConnexionState createState() => _EcranConnexionState();
}

class _EcranConnexionState extends State<EcranConnexion> {

  String nomConnexion = "";
  String passwordConnexion = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // TODO decommenter la ligne suivante
      //  drawer: LeTiroir(),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Connexion'),
      ),
      body: Column(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Connexion", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50)),

          // const Text(
          //   'Nom',
          // ),
          Padding(
            padding: const EdgeInsets.all(50),
            child: TextFormField(
              decoration: InputDecoration(labelText: "Nom",
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
              decoration: InputDecoration(labelText: "Mot de passe",
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
                    child: Text('Connexion'),
                    color: Colors.blue,
                    onPressed: () async {

                      try {
                        SigninRequest req = SigninRequest();
                        req.username = nomConnexion;
                        req.password = passwordConnexion;
                        var reponse = await signin(req);
                        print(reponse);
                      } on DioError catch(e) {
                        print(e);
                        String message = e.response!.data;
                        if (message == "BadCredentialsException") {
                          print('login deja utilise');
                        } else {
                          print('autre erreurs');
                        }
                      }

                    },
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
                    child: Text('Inscription'),
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