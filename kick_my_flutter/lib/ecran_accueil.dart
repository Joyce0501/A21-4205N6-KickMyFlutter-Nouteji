
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kick_my_flutter/ecran_consultation.dart';
import 'package:kick_my_flutter/lib_http.dart';
import 'package:kick_my_flutter/transfer.dart';


class EcranAccueil extends StatefulWidget {

  @override
  _EcranAccueilState createState() => _EcranAccueilState();
}

class _EcranAccueilState extends State<EcranAccueil> {

  HomeItemResponse homeitemresponse = HomeItemResponse();

  List<HomeItemResponse> taches = [];

  void getHttpListTache() async {
    try {
      this.taches = await ListTache();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erreur reseau')
          )
      );
    }
  }

  @override
  void initState() {
    getHttpListTache();
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

      body: ListView.builder(
        itemCount: taches.length,
        scrollDirection: Axis.vertical,
        prototypeItem: ListTile(
          title: Text("hello"),
        ),

        itemBuilder: (context, index) {
          return Row(
            children: [
              Expanded(
                child: ListTile(

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EcranConsultation(le_parametre:this.taches[index].id.toString()),
                      ),
                    );
                  },

                  title: Text(this.taches[index].name),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text(this.taches[index].percentageDone.toString()),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text(this.taches[index].percentageTimeSpent.toString()),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text(this.taches[index].deadline.toString()),
                ),
              ),
              // Expanded(
              //   child: MaterialButton(
              //     child: Text('en haut'),
              //     color: Colors.blue,
              //     onPressed: () {  },
              //   ),
              // ),
            ],
          );
        },
      )

    );
  }
}