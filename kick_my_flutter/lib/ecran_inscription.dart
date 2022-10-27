
import 'package:flutter/material.dart';
import 'package:kick_my_flutter/ecran_connexion.dart';
import 'package:dio/dio.dart';
import 'package:kick_my_flutter/transfer.dart';

import 'ecran_accueil.dart';
import 'i18n/intl_localization.dart';
import 'lib_http.dart';

class EcranInscription extends StatefulWidget {

  @override
  _EcranInscriptionState createState() => _EcranInscriptionState();
}

class _EcranInscriptionState extends State<EcranInscription> {

  String nomInscription = "";
  String passwordInscription = "";
  String confirmationpassword = "";

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text( Locs.of(context).trans ("Inscription en cours..." ))),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  inscription() async {

    if(passwordInscription.toString() == confirmationpassword.toString() )
    {
      try {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showLoaderDialog(context);
        });
        SignupRequest req = SignupRequest();
        req.username = nomInscription;
        req.password = passwordInscription;
        var reponse = await signup(req);
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
        else if(message == "UsernameTooShort")
        {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              // title: const Text('AlertDialog Title'),
              content:  Text(Locs.of(context).trans('Nom utilisateur trop court')),
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
        else if(message == "UsernameAlreadyTaken")
        {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              // title: const Text('AlertDialog Title'),
              content:  Text(Locs.of(context).trans('Nom utilisateur deja pris')),
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
        else if(message == "PasswordTooShort")
        {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              // title: const Text('AlertDialog Title'),
              content:  Text(Locs.of(context).trans('Mot de passe trop court')),
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
     else{
    //     ScaffoldMessenger.of(context).showSnackBar(
    //      SnackBar(
    //          content: Text('Les mots de passe ne sont pas identiques')
    //     )
    // );
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            // title: const Text('AlertDialog Title'),
            content:  Text(Locs.of(context).trans('Les mots de passe ne sont pas identiques')),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
   } // fin de mon else
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(Locs.of(context).trans('Inscription')),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            return buildPaysage();
          } else {
            return buildPortrait();
          }
        },
      ),
    );
  }
  
  Widget buildPortrait() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // TODO decommenter la ligne suivante
    //  drawer: LeTiroir(),
    //   appBar: AppBar(
    //     // Here we take the value from the MyHomePage object that was created by
    //     // the App.build method, and use it to set our appbar title.
    //     title: Text(Locs.of(context).trans('Inscription')),
    //   ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Inscription", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50)),

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
                  nomInscription = nom;
                }
              ),
            ),

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
                onChanged: (password) {
                  passwordInscription = password;
                },
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50),
              child: TextFormField(
                decoration: InputDecoration(labelText: Locs.of(context).trans('Confirmaton du mot de passe'),
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

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    child: MaterialButton(
                      child: Text(Locs.of(context).trans('Inscription')),
                      color: Colors.blue,
                      onPressed:
                      inscription,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaysage() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // TODO decommenter la ligne suivante
      //  drawer: LeTiroir(),
      //   appBar: AppBar(
      //     // Here we take the value from the MyHomePage object that was created by
      //     // the App.build method, and use it to set our appbar title.
      //     title: Text(Locs.of(context).trans('Inscription')),
      //   ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Inscription", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50)),

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
                    nomInscription = nom;
                  }
              ),
            ),

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
                onChanged: (password) {
                  passwordInscription = password;
                },
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50),
              child: TextFormField(
                decoration: InputDecoration(labelText: Locs.of(context).trans('Confirmaton du mot de passe'),
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

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    child: MaterialButton(
                      child: Text(Locs.of(context).trans('Inscription')),
                      color: Colors.blue,
                      onPressed:
                      inscription,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget buildPaysage() {
  //   return Scaffold(
  //     resizeToAvoidBottomInset: false,
  //     // TODO decommenter la ligne suivante
  //     //  drawer: LeTiroir(),
  //     //   appBar: AppBar(
  //     //     // Here we take the value from the MyHomePage object that was created by
  //     //     // the App.build method, and use it to set our appbar title.
  //     //     title: Text(Locs.of(context).trans('Inscription')),
  //     //   ),
  //     body:
  //        Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Text("Inscription", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50)),
  //
  //         //  Padding(
  //          //   padding: const EdgeInsets.all(50),
  //           //  child:
  //             TextFormField(
  //                 decoration: InputDecoration(labelText: Locs.of(context).trans('Nom'),
  //                     labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
  //                     enabledBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                       borderSide: BorderSide(
  //                           color: Colors.grey
  //                       ),
  //                     )),
  //                 onChanged: (nom) {
  //                   nomInscription = nom;
  //                 }
  //             ),
  //          // ),
  //
  //         //  Padding(
  //          //   padding: const EdgeInsets.all(50),
  //           //  child:
  //             TextFormField(
  //               decoration: InputDecoration(labelText: Locs.of(context).trans('Mot de passe'),
  //                   labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
  //                   enabledBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(10),
  //                     borderSide: BorderSide(
  //                         color: Colors.grey
  //                     ),
  //                   )),
  //               onChanged: (password) {
  //                 passwordInscription = password;
  //               },
  //               obscureText: true,
  //             ),
  //         //  ),
  //        //   Padding(
  //           //  padding: const EdgeInsets.all(50),
  //           //  child:
  //             TextFormField(
  //               decoration: InputDecoration(labelText: Locs.of(context).trans('Confirmaton du mot de passe'),
  //                   labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
  //                   enabledBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(10),
  //                     borderSide: BorderSide(
  //                         color: Colors.grey
  //                     ),
  //                   )),
  //               obscureText: true,
  //               onChanged: (passwordconfirmation) {
  //                 confirmationpassword = passwordconfirmation;
  //               },
  //             ),
  //        //   ),
  //
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Expanded(
  //                   child: MaterialButton(
  //                     child: Text(Locs.of(context).trans('Inscription')),
  //                     color: Colors.blue,
  //                     onPressed:
  //                     inscription,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     );
  // }
}