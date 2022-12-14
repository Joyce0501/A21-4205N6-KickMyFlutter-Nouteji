
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  String imagePath = "";
  String imageNetworkPath = "";
  XFile? pickedImage;
  List<XFile>? pickedImages;


  final picker = ImagePicker();

  // on met le fichier dans l'etat pour l'afficher dans la page
  var _imageFile = null;

  Future<String> sendPicture(int taskID, File file) async {
    FormData formData = FormData.fromMap({
      // TODO on peut ajouter d'autres champs que le fichier d'ou le nom multipart
     // "babyID": babyID,
      // TODO on peut mettre le nom du fichier d'origine si necessaire
      "file" : await MultipartFile.fromFile(file.path ,filename: "image.jpg"),
      "taskID" : this.taskdetailresponse.id,
    });
    // TODO changer la base de l'url pour l'endroit ou roule ton serveur
    var url = "http://10.0.2.2:8080/file";
    var response = await Dio().post(url, data: formData);
    print(response.data);
    getHttpdetailTache(widget.le_parametre);
    return "";
  }


  Future getImage() async {
    print("ouverture du selecteur d'image");
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      print("l'image a ete choisie " + pickedFile.path.toString());
      _imageFile = File(pickedFile.path);
      setState(() {});
      // TODO envoi au server
      print("debut de l'envoi , pensez a indiquer a l'utilisateur que ca charge " + DateTime.now().toString() );
      sendPicture(taskdetailresponse.id, _imageFile).then(
              (res) {
            setState(() {
              print("fin de l'envoi , pensez a indiquer a l'utilisateur que ca charge " + DateTime.now().toString() );

              // TODO mettre a jour interface graphique
            });
          }
      ).catchError(
              (err) {
            // TODO afficher un message a l'utilisateur pas marche
            print(err);
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                // title: const Text('AlertDialog Title'),
                content:  Text(Locs.of(context).trans("Erreur r??seau")),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
      );
    }
    else {
      print('Pas de choix effectue.');
    }
  }

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
           Container(margin: EdgeInsets.only(left: 7),child:Text( Locs.of(context).trans ("Chargement des d??tails..." ))),
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
      Navigator.of(context).pop();
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          // title: const Text('AlertDialog Title'),
          content:  Text(Locs.of(context).trans("Erreur r??seau")),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void changepercentage(int idtache, int percentage) async{

    if(nouveaupourcentage == POURCENT_NON_MODIFIE)
      {
        nouveaupourcentage == taskdetailresponse.percentageDone;
      }
    else if(nouveaupourcentage > 100){
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          // title: const Text('AlertDialog Title'),
          content:  Text(Locs.of(context).trans('Pourcentage doit etre inferieur ou egal a 100')),
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
        Navigator.of(context).pop();
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              // title: const Text('AlertDialog Title'),
              content:  Text(Locs.of(context).trans("Erreur r??seau")),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
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

      body: SingleChildScrollView(
        child: Column(
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
                  child:
                  //TODO au lieu de mettre directement le widget Image.network, on l'encapsule (on le wrap)
                  (taskdetailresponse.photoId == 0 ) ?
                  Text(Locs.of(context).trans('Aucune image pour cette tache'))
                      :
                  // dans un LayoutBuilder. Le LayoutBuilder nous permet d'avoir un nouveau build context
                  // uniquement pour le widget.
                  LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {

                        //TODO La MediaQuery permet de connaitre la taille disponible dans le build context,
                        // ici build context est uniquement pour le widget Image.network, c'est donc la taille disponible
                        // pour l'image
                        var size = MediaQuery.of(context).size;

                        //TODO la taille est en double, il sera important de convertir la taille en int
                        // pour que le serveur prenne notre requ??te (ex: 390 au lieu de 390.0)
                        String width = size.width.toInt().toString();

                        //TODO Une fois la taille connue, il suffit de la sp??cifier dans l'URL
                        return
                          CachedNetworkImage(
                            imageUrl: 'http://10.0.2.2:8080/file/' + taskdetailresponse.photoId.toString() +"?width=" +width, width: size.width,
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          );
                         // Image.network("https://exercices-web.herokuapp.com/exos/image?&width="+width, width: size.width,);
                      }
                  ),
                ),
              ],
            ),


            // Row(
            //   children: [
            //     Expanded(
            //         child:
            //         (taskdetailresponse.photoId == 0 ) ?
            //         Text(Locs.of(context).trans('Aucune image pour cette tache'))
            //             :
            //         CachedNetworkImage(
            //           imageUrl: 'http://10.0.2.2:8080/file/' + taskdetailresponse.photoId.toString().toString(),
            //           placeholder: (context, url) => CircularProgressIndicator(),
            //           errorWidget: (context, url, error) => Icon(Icons.error),
            //         ),
            //        // Image.network('http://10.0.2.2:8080/file/' + taskdetailresponse.photoId.toString().toString())
            //     ),
            //     //   ElevatedButton(onPressed:sendPicture(this.taskdetailresponse.id,File(imageNetworkPath.path)), child: Text("Envoyer image su serveur")),
            //   ],
            // ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          child: Text(Locs.of(context).trans('Enregistrement du nouveau pourcentage')),
                          color: Colors.blue,
                          onPressed: () {
                            changepercentage(widget.le_parametre, nouveaupourcentage);
                            setState(() {});
                          },
                ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          child: Text(Locs.of(context).trans('Selectionnes une image')),
                          color: Colors.blue,
                          onPressed: getImage,
                        ),
                      ),
                    ),
              ],
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}