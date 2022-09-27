
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kick_my_flutter/lib_http.dart';
import 'package:kick_my_flutter/tiroir_nav.dart';
import 'package:kick_my_flutter/transfer.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'i18n/intl_localization.dart';


class EcranConsultation extends StatefulWidget {

  final int le_parametre;

  const EcranConsultation({Key? key, required this.le_parametre}) : super(key: key);


  @override
  _EcranConsultationState createState() => _EcranConsultationState();
}

const int POURCENT_NON_MODIFIE = -1;

class _EcranConsultationState extends State<EcranConsultation> {

   int nouveaupourcentage = POURCENT_NON_MODIFIE;

  TaskDetailResponse taskdetailresponse = TaskDetailResponse();

   showLoaderDialog(BuildContext context){
     AlertDialog alert=AlertDialog(
       content: new Row(
         children: [
           CircularProgressIndicator(),
           Container(margin: EdgeInsets.only(left: 7),child:Text( Locs.of(context).trans ("Changement en cours..." ))),
         ],),
     );
     showDialog(barrierDismissible: false,
       context:context,
       builder:(BuildContext context){
         return alert;
       },
     );
   }

   showLoaderDialogConsultation(BuildContext context){
     AlertDialog alert=AlertDialog(
       content: new Row(
         children: [
           CircularProgressIndicator(),
           Container(margin: EdgeInsets.only(left: 7),child:Text( Locs.of(context).trans ("Chargement des détails..." ))),
         ],),
     );
     showDialog(barrierDismissible: false,
       context:context,
       builder:(BuildContext context){
         return alert;
       },
     );
   }

   void getHttpdetailTache(int idtache) async {
    try{
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showLoaderDialogConsultation(context);
      });
      this.taskdetailresponse = await taskdetail(idtache);
      Navigator.pop(context);
      setState(() {});
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erreur reseau')
          )
      );
    }
  }

  void changepercentage(int idtache, int percentage) async{

    if(nouveaupourcentage == POURCENT_NON_MODIFIE)
      {
        nouveaupourcentage == taskdetailresponse.percentageDone;
      }

    else{
      try{
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showLoaderDialog(context);
        });
        var reponse = await taskpercentage(idtache, percentage);
        taskdetailresponse.percentageDone = nouveaupourcentage;
        print(reponse);
        Navigator.pop(context);
        setState(() {});

      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Erreur reseau')
            )
        );
      }
    }

  }

  @override
  void initState() {
    getHttpdetailTache(widget.le_parametre);
    changepercentage(widget.le_parametre,nouveaupourcentage);
    initializeDateFormatting("fr-FR", null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // TODO decommenter la ligne suivante
       drawer: LeTiroir(),
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(Locs.of(context).trans('Consultation')),
        ),

      body: Column(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
         // Text(widget.le_parametre.toString())

      Container(
      margin: EdgeInsets.all(5),
      width: double.infinity,
      height: 200,
      child:  Expanded(
        child:
            Column(

                children:[
                  Expanded(
                    flex: 2,
                    child:
                    Text(Locs.of(context).trans('Nom de la tache') + " : " + taskdetailresponse.name),
                  ),

                  Expanded(
                    flex: 2,
                    child:
                    Text(Locs.of(context).trans('Date decheance de la tache') + " : " + DateFormat.yMd("fr_FR").format(taskdetailresponse.deadline)),
                  ),

                  Expanded(
                    flex: 2,
                    child:
                    Text(Locs.of(context).trans('Pourcentage davancement') + " : " + taskdetailresponse.percentageDone.toString()),

                  ),

                  Expanded(
                    flex: 2,
                    child:
                    Text(Locs.of(context).trans('Pourcentage de temps ecoule') + " : " + taskdetailresponse.percentageTimeSpent.toString()),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextFormField(
                        decoration: InputDecoration(labelText: Locs.of(context).trans('Entrer le nouveau pourcentage'),
                            labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.grey
                              ),
                            )),
                        onChanged: (pourcentage) {
                          try {
                            nouveaupourcentage = int.parse(pourcentage);
                          } catch(e) {
                            nouveaupourcentage = POURCENT_NON_MODIFIE;
                          }
                        }
                    ),
                  ),
                ]
            ),
       ),
    ),


          Row(
            children: [
              Expanded(
                child: MaterialButton(
                  child: Text(Locs.of(context).trans('Enregistrement du nouveau pourcentage')),
                  color: Colors.blue,
                  onPressed: () {
                    changepercentage(widget.le_parametre, nouveaupourcentage);
                    //    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}