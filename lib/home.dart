//Files :
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'colors.dart';
import 'consumedCal.dart';

//Packages
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:core';
class HomePage extends StatefulWidget {
  //Flutter Charts

   HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
  List<ConsumedCalories> list =[
    ConsumedCalories(day: "Lu", cals:0),
    ConsumedCalories(day: "Ma", cals: 0),
    ConsumedCalories(day: "Me", cals: 0),
    ConsumedCalories(day: "Je", cals: 0),
    ConsumedCalories(day: "Ve",cals: 0),
    ConsumedCalories(day: "Sa", cals: 0),
    ConsumedCalories(day: "Di", cals: 0,)];
  bool reset = false;
} 

class _HomePageState extends State<HomePage> {
  Future<int> getDayCals() async{
    var doc = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
    int cals = await doc["calList"][DateTime.now().weekday-1];
    return cals;
  }
    Future<int> getCalsObj() async{
    var doc = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
    int cals = await int.parse(doc["calObj"]);
    return cals;
  }
  

  
  //Classe Couleurs
  Couleurs colors = Couleurs();

  //BottomNavBar

  //Flutter Charts
  Future<void> fillList() async {
    var doc = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
    for (var i = 0; i < widget.list.length; i++) {
        widget.list[i].cals = doc["calList"][i];
    }
    

    
  }



  
  Future<int> getCalsSum(String uid, CollectionReference collection) async {
    var doc = await collection.where("uid",isEqualTo:uid).get();
    print(doc.docs);
    int sum = 0;
    for (var i = 0; i < doc.docs.length; i++) {
      for (var j = 0; j<doc.docs[i]["Exercices"].length; j++) {
        print(int.parse(doc.docs[i]["Exercices"][j]["Calories"]));
        sum += int.parse(doc.docs[i]["Exercices"][j]["Calories"]);
      }
      
    }
    print(sum);    
    return await sum;
  }

  Future<void> resetWeek()async{
    var doc = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid);
    var emptyList = [0,0,0,0,0,0,0];
    
      doc.update({
        "calList":emptyList
      });
    

  }
 





  
  CarouselController _carouselController = CarouselController();
  int _current = 0;

  int daysCals= 0;
  int calsObj = 0;
  String username=FirebaseAuth.instance.currentUser!.displayName!;

  @override
  Widget build(BuildContext context)  {
    
      

    getDayCals().then((value){
      daysCals = value;
    });
    getCalsObj().then((value){
      calsObj = value;
    });

    fillList();

  List<Column> carouselList = [
    Column(
      children: [
        Text(
          "Temps d'entrainement",
          style: TextStyle(
              color: Couleurs().blanc,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: LinearPercentIndicator(
            lineHeight: 25.0,
            percent: 0.75,
            backgroundColor: Couleurs().gris,
            progressColor: Couleurs().orange,
            barRadius: Radius.circular(5),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "5/8h",
          style: TextStyle(
              color: Couleurs().blanc,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        )
      ],
    ),
    Column(
      children: [
        Text(
          "Calories dépensées",
          style: TextStyle(
              color: Couleurs().blanc,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: LinearPercentIndicator(
            lineHeight: 25.0,
            percent: (daysCals/calsObj <=1) ? daysCals/calsObj :1  ,
            backgroundColor: Couleurs().gris,
            progressColor: Couleurs().orange,
            barRadius: Radius.circular(5),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          " ${daysCals.toString()}/${calsObj.toString()}",
          style: TextStyle(
              color: Couleurs().blanc,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        )
      ],
    ),
    Column(
      children: [
        Text(
          "Calories consomées",
          style: TextStyle(
              color: Couleurs().blanc,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: LinearPercentIndicator(
            lineHeight: 25.0,
            percent: 0.75,
            backgroundColor: Couleurs().gris,
            progressColor: Couleurs().orange,
            barRadius: Radius.circular(5),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "1500/2000Kcal",
          style: TextStyle(
              color: Couleurs().blanc,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        )
      ],
    ),
  ];

    List<charts.Series<ConsumedCalories, String>> timeline  = [
      charts.Series (
        id: "ConsumedCals",
        data: widget.list,
        domainFn: (ConsumedCalories timeline, _) => timeline.day,
        measureFn: (ConsumedCalories timeline, _) => timeline.cals,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(colors.orange),
      ),
    ];

     //Size
      double sHeight = MediaQuery.of(context).size.height;
      double sWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: colors.noir,
        body: SizedBox(
          height: sHeight,
          width: sWidth,
          child: Column(children: [
            SizedBox(height: 50),
            Text(
              "Bievenue $username ! ",
              style: TextStyle(color: colors.blanc, fontSize: 30),
            ),
            SizedBox(height: sHeight/15),
            
            Container(
              padding: EdgeInsets.only(bottom: 15, left: 5, right: 5),
              decoration: BoxDecoration(
                color: colors.gris,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: sHeight/2.3,
                width: sWidth/1,
                child: charts.BarChart(
                  timeline,
                  animate: true,
                  domainAxis: charts.OrdinalAxisSpec(
                      renderSpec: charts.SmallTickRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                        color: charts.ColorUtil.fromDartColor(colors.blanc),
                        fontSize: 20),
                  )),
                  primaryMeasureAxis: charts.NumericAxisSpec(
                      renderSpec: charts.GridlineRendererSpec(
                          labelStyle: charts.TextStyleSpec(
                              color:
                                  charts.ColorUtil.fromDartColor(colors.blanc),
                              fontSize: 20))),
                ),
              ),
            ),
            SizedBox(
              height: sHeight/20,
            ),
            Column(
              children: [
                CarouselSlider(
                    options: CarouselOptions(
                        height: 100.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                         
                        },
                        enlargeCenterPage: true),
                    items: carouselList),
                SizedBox(
                  height: sHeight/50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: carouselList.asMap().entries.map((data) {
                    
                    return Container(
                      width: 8,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == data.key
                              ? colors.orange
                              : colors.gris),
                    );
                  }).toList(),
                ),
              ],
            ),
          ]),
        ));
  }
}
