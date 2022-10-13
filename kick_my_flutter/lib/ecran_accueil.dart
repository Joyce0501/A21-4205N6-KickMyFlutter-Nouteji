
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kick_my_flutter/ecran_consultation.dart';
import 'package:kick_my_flutter/ecran_creation.dart';
import 'package:kick_my_flutter/lib_http.dart';
import 'package:kick_my_flutter/transfer.dart';
import 'package:kick_my_flutter/tiroir_nav.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'i18n/intl_localization.dart';


class EcranAccueil extends StatefulWidget {

  @override
  _EcranAccueilState createState() => _EcranAccueilState();
}

class _EcranAccueilState extends State<EcranAccueil> {

  HomeItemResponse homeitemresponse = HomeItemResponse();

  List<HomeItemResponse> taches = [];

  bool dialogVisible = false;

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text(Locs.of(context).trans("Chargement en cours..."))),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        dialogVisible = true;
        return alert;
      },
    );
  }

  void getHttpListTache() async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showLoaderDialog(context);
      });
      this.taches = await ListTache();
      if(dialogVisible)
        Navigator.pop(context);
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
    initializeDateFormatting("fr-FR", null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // TODO decommenter la ligne suivante
        drawer: LeTiroir(),
     //   drawer: LeTiroir(),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(Locs.of(context).trans('Accueil')),
      ),

      body:
        ListView.builder(
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
                          builder: (context) => EcranConsultation(le_parametre:this.taches[index].id),
                        ),
                      );
                    },
                    // leading: CircleAvatar(
                    //   backgroundImage: NetworkImage('http://10.0.2.2:8080/file/' + this.taches[index].photoId.toString()),
                    // ),
                    title: CircleAvatar(
                      // TODO : mettre une width par la suite
                      backgroundImage: NetworkImage('http://10.0.2.2:8080/file/' + this.taches[index].photoId.toString()),
                    //backgroundImage: NetworkImage('http://10.0.2.2:8080/file/' + this.taches[index].photoId.toString() +"?width=70"),
                    ),
                  ),
                ),

                Expanded(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EcranConsultation(le_parametre:this.taches[index].id),
                        ),
                      );
                    },
                    // leading: CircleAvatar(
                    //   backgroundImage: NetworkImage('http://10.0.2.2:8080/file/' + this.taches[index].photoId.toString()),
                    //   ),
                    title: Text( this.taches[index].name,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                  //      color: Colors.black,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EcranConsultation(le_parametre:this.taches[index].id),
                        ),
                      );
                    },

                    // leading: Icon(Icons.percent),
                    title: Text(this.taches[index].percentageDone.toString() + "%",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        //    color: Colors.red,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EcranConsultation(le_parametre:this.taches[index].id),
                        ),
                      );
                    },
                  //  leading: Icon(Icons.done_all_sharp),
                    title: Text( this.taches[index].percentageTimeSpent.toString(),
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                ),
                Expanded(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EcranConsultation(le_parametre:this.taches[index].id),
                        ),
                      );
                    },
                    title: Text(DateFormat.yMd("fr_FR").format(this.taches[index].deadline),
                      style: TextStyle(
                        fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          //  color: Colors.black,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EcranCreation(),
            ),
          );
        },
      child: const Icon(Icons.add_task),
    ),

    );
  }
}