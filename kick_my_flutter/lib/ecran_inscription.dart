
import 'package:flutter/material.dart';
import 'package:kick_my_flutter/ecran_connexion.dart';
import 'package:dio/dio.dart';
import 'package:kick_my_flutter/transfer.dart';

import 'ecran_accueil.dart';
import 'lib_http.dart';

class EcranInscription extends StatefulWidget {

  @override
  _EcranInscriptionState createState() => _EcranInscriptionState();
}

class _EcranInscriptionState extends State<EcranInscription> {

  String nomInscription = "";
  String passwordInscription = "";
  String confirmationpassword = "";

  inscription() async {

    if(passwordInscription.toString() == confirmationpassword.toString() )
    {
      try {
        SignupRequest req = SignupRequest();
        req.username = nomInscription;
        req.password = passwordInscription;

        var reponse = await signup(req);


        print(reponse);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EcranConnexion(),
          ),
        );

      } on DioError catch(e) {
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


     else{
      // try {
      //   SignupRequest req = SignupRequest();
      //   req.username = nomInscription;
      //   req.password = passwordInscription;
      //
      //   var reponse = await signup(req);
      //
      //
      //   print(reponse);
      //
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => EcranAccueil(),
      //     ),
      //   );
      //
      // } on DioError catch(e) {
      //   print(e);
      //   String message = e.response!.data;
      //   if (message == "BadCredentialsException") {
      //     print('login deja utilise');
      //   } else {
      //     print('autre erreurs');
      //
      //     ScaffoldMessenger.of(context).showSnackBar(
      //         SnackBar(
      //             content: Text('Erreur authentification')
      //         )
      //     );
      //   }
      //
      // }

        ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
             content: Text('Les mots de passe ne sont pas identiques')
        )
    );
   } // fin de mon else
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
        title: Text('Inscription'),
      ),
      body: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Inscription", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50)),

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
                nomInscription = nom;
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
              onChanged: (password) {
                passwordInscription = password;
              },
              obscureText: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(50),
            child: TextFormField(
              decoration: InputDecoration(labelText: "Confirmaton du mot de passe",
                  labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Colors.grey
                    ),
                  )),
              obscureText: true,
              onChanged: (passwordconfirmation) {
                confirmationpassword = passwordconfirmation;
              },
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Expanded(
              //     child: MaterialButton(
              //       child: Text('Connexion'),
              //       color: Colors.blue,
              //       onPressed: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => EcranConnexion(),
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  child: MaterialButton(
                    child: Text('Inscription'),
                    color: Colors.blue,
                    onPressed:
                        // () {
                      // if(confirmationpassword.toString().isEmpty && confirmationpassword.toString() != passwordInscription.toString() )
                      // {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(
                      //           content: Text('Les mots de passe ne sont pas identiques')
                      //       )
                      //   );
                      // }
                    inscription,

               //  }

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