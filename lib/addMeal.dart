import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:genfit/addIngredients.dart';
import 'dart:io';
import 'addExerices.dart';
import 'colors.dart';
import 'main.dart';
import 'home.dart';
import 'consumedCal.dart';
class AddMeal extends StatefulWidget {
  const AddMeal({Key? key}) : super(key: key);

  @override
  State<AddMeal> createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController mealNameController = TextEditingController();
  Couleurs colors = Couleurs();

  bool pressed = false;
  Future<void> AddMeal(String name, String uid, CollectionReference collection) {
    return collection.doc(name).set({
      "uid": uid,
      "Ingredients": [],
    });
  }

  void deleteMeal(String name,CollectionReference collection){
  
   setState(() {
       collection.doc(name).delete();
   });
  }

  
  var meal = FirebaseFirestore.instance.collection("meal");

  Future<void> displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Ajouter un repas'),
            content: TextField(
              controller: mealNameController,
              decoration: InputDecoration(hintText: "Nom du repas"),
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
                    AddMeal(
                        mealNameController.text, user!.uid, meal);
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
        title: Text("Mes repas",style: TextStyle(color: colors.noir),),
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
          future: meal.where("uid", isEqualTo: user!.uid).get(),
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
                                  MaterialPageRoute(builder: (context) => AddIngredients(mealName:data[index].id)));
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

                                     
                                      IconButton(onPressed: ()=>deleteMeal(data[index].id, meal), icon: Icon(Icons.delete),color: Colors.red,),
                                     
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
              return Center(child: Text("Vous n'avez aucun repas",style: TextStyle(color: colors.blanc,fontSize: 25),));
            }
          },
        ),
      ),
    );
  }
}
