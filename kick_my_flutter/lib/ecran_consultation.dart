
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kick_my_flutter/lib_http.dart';
import 'package:kick_my_flutter/tiroir_nav.dart';
import 'package:kick_my_flutter/transfer.dart';


class EcranConsultation extends StatefulWidget {

  final int le_parametre;

  const EcranConsultation({Key? key, required this.le_parametre}) : super(key: key);


  @override
  _EcranConsultationState createState() => _EcranConsultationState();
}

class _EcranConsultationState extends State<EcranConsultation> {

  int nouveaupourcentage = 0;

  TaskDetailResponse taskdetailresponse = TaskDetailResponse();

  void getHttpdetailTache(int idtache) async {
    try{
      this.taskdetailresponse = await taskdetail(idtache);
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

    try{
      var reponse = await taskpercentage(idtache, percentage);
      print(reponse);
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

  @override
  void initState() {
    getHttpdetailTache(widget.le_parametre);
  //  changepercentage(widget.le_parametre,nouveaupourcentage);
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
          title: Text('Consultation'),
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
                    Text("nom de la tache : " + taskdetailresponse.name),
                  ),

                  Expanded(
                    flex: 2,
                    child:
                    Text("date d'echeance de la tache : " + taskdetailresponse.deadline.toString()),
                  ),

                  Expanded(
                    flex: 2,
                    child:
                    Text("Pourcentage d" + "'" "avancement : " + taskdetailresponse.percentageDone.toString()),
                  ),

                  Expanded(
                    flex: 2,
                    child:
                    Text("Pourcentage de temps ecoule : " + taskdetailresponse.percentageTimeSpent.toString()),
                  ),

                  Expanded(
                    flex: 2,
                    child: TextFormField(
                        decoration: InputDecoration(labelText: "Entrer le nouuveau pourcentage",
                            labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.grey
                              ),
                            )),
                        onChanged: (pourcentage) {
                          nouveaupourcentage = int.parse('pourcentage');
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
                child: Text('Modification du pourcentage'),
                color: Colors.blue,
                onPressed: () {
                  changepercentage(widget.le_parametre, int.parse('nouveaupourcentage'));
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