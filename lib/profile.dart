import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:genfit/screens/signin_screen.dart';
import 'colors.dart';




class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {

  Couleurs colors = Couleurs();

  bool canEditTaille = false;
  bool canEditPoids = false;
  bool canEditCal = false;
  TextEditingController tailleController = TextEditingController();
  TextEditingController poidsController = TextEditingController();
  TextEditingController calController = TextEditingController();
  String initialTaille = "";
  String initialPoids = "";
  String initialCal = "";



  Future<void> updateField(String value,String field) async {
    await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
      field:value
    });
  }



  Widget editTaille() {
    if (canEditTaille)
      return Center(
        child: TextField(
          onSubmitted: (newValue){
            setState(() {
              initialTaille = newValue;
              updateField(initialTaille, "taille");
              canEditTaille =false;
            });
          },
          autofocus: true,
          controller: tailleController,
          style: TextStyle(color: colors.orange),
        ),
      );
    return InkWell(
      onTap: () {
        setState(() {
          canEditTaille = true;
        });
      },
      child: Center(
        child: Text(
    initialTaille,
    style: TextStyle(
        color: colors.orange,
        fontSize: 30.0,
    ),
  ),
      ));
  }
  Widget editPoids() {
    if (canEditPoids)
      return Center(
        child: TextField(
          onSubmitted: (newValue){
            setState(() {
              initialPoids = newValue;
              updateField(initialPoids, "poids");
              canEditPoids =false;
            });
          },
          autofocus: true,
          controller: poidsController,
        ),
      );
    return InkWell(
      onTap: () {
        setState(() {
          canEditPoids = true;
        });
      },
      child: Center(
        child: Text(
    initialPoids,
    style: TextStyle(
        color: colors.orange,
        fontSize: 30.0,
    ),
  ),
      ));
  }


    Widget editCal() {
    if (canEditCal)
      return Center(
        child: TextField(
          onSubmitted: (newValue){
            setState(() {
              initialCal = newValue;
              updateField(initialCal, "calObj");
              canEditCal =false;
            });
          },
          autofocus: true,
          controller: calController,
        ),
      );
    return InkWell(
      onTap: () {
        setState(() {
          canEditCal = true;
        });
      },
      child: Center(
        child: Text(
    initialCal,
    style: TextStyle(
        color: colors.orange,
        fontSize: 30.0,
    ),
  ),
      ));
  }


  @override
  void initState() {
    super.initState();
    tailleController = TextEditingController(text: initialTaille);
    poidsController = TextEditingController(text: initialPoids);
    calController = TextEditingController(text: initialCal);
  }
  @override
  void dispose() {
    tailleController.dispose();
    poidsController.dispose();
    calController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    
   
    return Scaffold(
      backgroundColor: Colors.black,
      body:Center(
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot)  {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

            if (snapshot.connectionState == ConnectionState.done && snapshot.data!.exists) {
                var doc = snapshot.data;
                initialTaille = snapshot.data!["taille"];
                initialPoids = snapshot.data!["poids"];
                initialCal = snapshot.data!["calObj"];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                     SizedBox(
                       height: 100,
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text("Pseudo : ",style: TextStyle(color: colors.blanc,fontWeight: FontWeight.bold,fontSize: 25),),
                            Text(FirebaseAuth.instance.currentUser!.displayName!,style: TextStyle(color: colors.orange,fontSize: 25)),
                         ],
                       ),
                     ),
                      SizedBox(height: 50,),
                      SizedBox(
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Taille : ",style: TextStyle(color: colors.blanc,fontWeight: FontWeight.bold,fontSize: 25)),
                            SizedBox(width: 300,height:50,child: editTaille()),
                          ],
                          ),
                      ),
                      SizedBox(height: 50,),
                      SizedBox(
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Poids : ",style: TextStyle(color: colors.blanc,fontWeight: FontWeight.bold,fontSize: 25)),
                            SizedBox(width: 300,height:50,child: editPoids()),
                          ],
                        ),
                      ),
                      SizedBox(height: 50,),
                      SizedBox(
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Objectif de calories dépensées : ",style: TextStyle(color: colors.blanc,fontWeight: FontWeight.bold,fontSize: 25)),
                            SizedBox(width: 300,height:50,child: editCal()),
                          ],
                        ),
                      ),
                      ElevatedButton(onPressed: (){
                        FirebaseAuth.instance.signOut();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignInScreen()));
                        
                      }  , child: Text("Déconnexion") , style: ElevatedButton.styleFrom(primary: colors.orange),),
                      ],
                      
                      
                
                );

              


              }
              else{
                return Text("");
              }
            }
         
        ),
      )
      
    );
  }
}




