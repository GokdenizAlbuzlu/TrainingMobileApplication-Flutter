import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'colors.dart';
import 'addTraining.dart';

class AddExercices extends StatefulWidget {
  final String trainingName;
  const AddExercices({Key? key, required this.trainingName}) : super(key: key);
  @override
  State<AddExercices> createState() => _AddExercicesState();
}

class _AddExercicesState extends State<AddExercices> {
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController exerciceNameController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();
  TextEditingController seriesController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  Couleurs colors = Couleurs();
  Future<void> addExercice(String id, String name, String calories,
      String series, String reps, CollectionReference collection) {
    return collection.doc(id).update({
      "Exercices": FieldValue.arrayUnion([
        {"Exercice": name, "Calories": calories, "Series": series, "Reps": reps}
      ])
    });
  }

  void deleteExercice(Map exercice,String id,CollectionReference collection){
    collection.doc(id).update({
      "Exercices": FieldValue.arrayRemove([exercice]),
    });
  }
  var training = FirebaseFirestore.instance.collection("training");

  Future<void> displayDialog(BuildContext context, String trainingName) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Ajouter un exercice'),
            content: Column(
              children: [
                TextField(
                  controller: exerciceNameController,
                  decoration: InputDecoration(hintText: "Nom de l'exercice"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: caloriesController,
                  decoration: InputDecoration(hintText: "Calories Consomées"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: seriesController,
                  decoration: InputDecoration(hintText: "Nombre de séries"),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: repsController,
                  decoration:
                      InputDecoration(hintText: "Nombre de répétitions"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    textStyle: TextStyle(color: Colors.white)),
                child: Text('Annuler'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    textStyle: TextStyle(color: Colors.white)),
                child: Text('Ajouter'),
                onPressed: () {
                  setState(() {
                    addExercice(
                        trainingName,
                        exerciceNameController.text,
                        caloriesController.text,
                        seriesController.text,
                        repsController.text,
                        training);
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    print(user!.uid);

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () async{
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddTraining()));
            },
            icon: Icon(
              Icons.arrow_back,
              color: colors.noir,
            ),
          ),
          title: Text(
            "Exerices du training ${widget.trainingName}",
            style: TextStyle(color: colors.noir),
          ),
          backgroundColor: colors.orange),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          displayDialog(context, widget.trainingName);
        },
        child: Icon(
          Icons.add,
          color: colors.noir,
        ),
        backgroundColor: colors.orange,
      ),
      backgroundColor: Colors.black,
      body: Container(
        width: width,
        height: height,
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: training.doc(widget.trainingName).get(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.data?["Exercices"].isNotEmpty) {
       
              DocumentSnapshot<Map<String, dynamic>> data = snapshot.data!;
              return ListView.builder(
                itemCount: data["Exercices"].length,
                itemBuilder: (context, index) {
                  return Container(
                    height: height / 6,
                    margin: EdgeInsets.symmetric(
                        horizontal: width / 15, vertical: height / 20),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: colors.gris,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: colors.orange, width: 3)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: "Exercice :",
                                    style: TextStyle(
                                        color: colors.orange,
                                        fontSize: 15,
                                        decoration: TextDecoration.underline),
                                    children: [
                                      TextSpan(
                                          text:
                                              " ${data["Exercices"][index]["Exercice"]}",
                                          style: TextStyle(
                                              color: colors.blanc,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              decoration: TextDecoration.none))
                                    ]),
                              ),
                              IconButton(onPressed: (){
                                setState(() {
                                  deleteExercice(data["Exercices"][index], widget.trainingName, training);
                                });}
                                ,icon: Icon(Icons.delete,color: Colors.red,),)
                            ],
                          ),
                          Text(
                            "Calories dépensées: ${data["Exercices"][index]["Calories"]} cals ",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          Text(
                            "${data["Exercices"][index]["Series"]} series x ${data["Exercices"][index]["Reps"]} reps ",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text("Cet entrainement ne contient aucun exercice",style: TextStyle(color: Colors.white,fontSize: 15),));
            }
          },
        ),
      ),
    );
  }
}
