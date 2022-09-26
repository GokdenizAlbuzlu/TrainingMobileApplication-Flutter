import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'colors.dart';
import 'addMeal.dart';

class AddIngredients extends StatefulWidget {
  final String mealName;
  const AddIngredients({Key? key, required this.mealName}) : super(key: key);
  @override
  State<AddIngredients> createState() => _AddIngredientsState();
}

class _AddIngredientsState extends State<AddIngredients> {
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController ingredientNameController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();
  TextEditingController proteineController = TextEditingController();
  TextEditingController glucideController = TextEditingController();
  TextEditingController lipideController = TextEditingController();
  Couleurs colors = Couleurs();

  Future<void> addIngredient(String id, String name, String calories, String proteines, String glucides, String lipides, CollectionReference collection) {
    return collection.doc(id).update({
      "Ingredients": FieldValue.arrayUnion([
        {"Nom": name, "Calories": calories, "Proteines": proteines, "Glucides": glucides, "Lipides": lipides}
      ])
    });
  }

  void deleteIngredient(Map ingredient,String id,CollectionReference collection){
    collection.doc(id).update({
      "Ingredients": FieldValue.arrayRemove([ingredient]),
    });
  }
  var meal = FirebaseFirestore.instance.collection("meal");

  Future<void> displayDialog(BuildContext context, String mealName) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Ajouter un ingrédient'),
            content: Column(
              children: [
                TextField(
                  controller: ingredientNameController,
                  decoration: InputDecoration(hintText: "Nom de l'ingrédient"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: caloriesController,
                  decoration: InputDecoration(hintText: "Calories Présentes"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: proteineController,
                  decoration: InputDecoration(hintText: "Nombre de protéines"),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: glucideController,
                  decoration:
                      InputDecoration(hintText: "Nombre de glucides"),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: lipideController,
                  decoration: InputDecoration(hintText: "Nombre de lipides"),
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
                    addIngredient(
                        mealName,
                        ingredientNameController.text,
                        caloriesController.text,
                        proteineController.text,
                        glucideController.text,
                        lipideController.text,
                        meal);
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
                  MaterialPageRoute(builder: (context) => AddMeal()));
            },
            icon: Icon(
              Icons.arrow_back,
              color: colors.noir,
            ),
          ),
          title: Text(
            "Ingrédients dans le repas ${widget.mealName}",
            style: TextStyle(color: colors.noir),
          ),
          backgroundColor: colors.orange),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          displayDialog(context, widget.mealName);
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
          future: meal.doc(widget.mealName).get(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.data?["Ingredients"].isNotEmpty) {
       
              DocumentSnapshot<Map<String, dynamic>> data = snapshot.data!;
              return ListView.builder(
                itemCount: data["Ingredients"].length,
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
                                    text: "Ingrédient :",
                                    style: TextStyle(
                                        color: colors.orange,
                                        fontSize: 15,
                                        decoration: TextDecoration.underline),
                                    children: [
                                      TextSpan(
                                          text:
                                              " ${data["Ingredients"][index]["Nom"]}",
                                          style: TextStyle(
                                              color: colors.blanc,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              decoration: TextDecoration.none))
                                    ]),
                              ),
                              IconButton(onPressed: (){
                                setState(() {
                                  deleteIngredient(data["Ingredients"][index], widget.mealName, meal);
                                });}
                                ,icon: Icon(Icons.delete,color: Colors.red,),)
                            ],
                          ),
                          Text(
                            "Calories présentes : ${data["Ingredients"][index]["Calories"]} cals ",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          Text(
                            "${data["Ingredients"][index]["Proteines"]} proteines + ${data["Ingredients"][index]["Glucides"]} glucides +  ${data["Ingredients"][index]["Lipides"]} lipides",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text("Ce repas ne contien aucun ingrédient",style: TextStyle(color: Colors.white,fontSize: 15),));
            }
          },
        ),
      ),
    );
  }
}
