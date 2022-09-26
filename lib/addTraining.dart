import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:io';
import 'addExerices.dart';
import 'colors.dart';
import 'main.dart';
import 'home.dart';
import 'consumedCal.dart';
class AddTraining extends StatefulWidget {
  const AddTraining({Key? key}) : super(key: key);

  @override
  State<AddTraining> createState() => _AddTrainingState();
}

class _AddTrainingState extends State<AddTraining> {
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController trainingNameController = TextEditingController();
  Couleurs colors = Couleurs();

  bool pressed = false;

  Future<void> addTraining(String name, String uid, CollectionReference collection) {
    return collection.doc(name).set({
      "uid": uid,
      "Exercices": [],
    });
  }




  void deleteTraining(String name,CollectionReference collection){
  
   setState(() {
       collection.doc(name).delete();
   });
  }

  
  void addTrainingCals(String name,String uid,CollectionReference collection) async{

    var now = DateTime.now();
    var day = now.weekday-1;
    print(day);
    var doc = await FirebaseFirestore.instance.collection("users").doc(uid).get();
    var tempList = doc["calList"];
    var trainingDoc = await collection.doc(name).get();
    int sum = 0;
    for (var i = 0; i < trainingDoc["Exercices"].length; i++) {
     
       
      sum += int.parse(trainingDoc["Exercices"][i]["Calories"]);
      
      
    }
    tempList[day]+=sum;

    FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
      "calList": tempList
    });


  }


  var training = FirebaseFirestore.instance.collection("training");

  Future<void> displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Ajouter un entrainement'),
            content: TextField(
              controller: trainingNameController,
              decoration: InputDecoration(hintText: "Nom de l'entrainement"),
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
                    textStyle: TextStyle(color: colors.orange)),
                child: Text('Ajouter'),
                onPressed: () {
                  setState(() {
                    addTraining(
                        trainingNameController.text, user!.uid, training);
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
    

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar:AppBar(
        backgroundColor: colors.orange,
        title: Text("Mes entrainements",style: TextStyle(color: colors.noir),),
        leading: IconButton(onPressed: ()=>Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AppNav())), 
                            icon: Icon(Icons.arrow_back),
                            color: colors.noir,
                            ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          displayDialog(context);
        },
        child: Icon(Icons.add,color: colors.noir,),
        backgroundColor: colors.orange,
      ),
      backgroundColor: Colors.black,
      body: Container(
        width: width,
        height: height,
        child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: training.where("uid", isEqualTo: user!.uid).get(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.done && snapshot.data!.docs.length>0) {
              
              List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
                  snapshot.data!.docs;
              return ListView.builder(
                
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Column(
                    
                    children: [
                      SizedBox(height: height/15,),
                      SizedBox(
                        height: height/7,
                        width: width/1.1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: colors.gris,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          
                          
                          ),
                          child: ElevatedButton(
                              onPressed: (() {
                                 Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => AddExercices(trainingName:data[index].id)));
                              }),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        data[index].id,
                                        style: TextStyle(color: colors.blanc, fontSize: 25,fontWeight: FontWeight.bold),
                                      ),

                                     
                                      IconButton(onPressed: ()=>deleteTraining(data[index].id, training), icon: Icon(Icons.delete),color: Colors.red,),
                                      IconButton(onPressed: ()=>addTrainingCals(data[index].id,FirebaseAuth.instance.currentUser!.uid,training), icon: Icon(Icons.add))
                                     
                                    ],
                                  ),
                                 
                                ],
                              ),
                            ),
                        ),
                      ),
                      
                    ],
                  );
                    
                  
                },
              );
            } 
            else {
              return Center(child: Text("Vous n'avez aucun entrainement",style: TextStyle(color: colors.blanc,fontSize: 25),));
            }
          },
        ),
      ),
    );
  }
}
