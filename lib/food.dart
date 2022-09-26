import 'package:flutter/material.dart';


class FoodPage extends StatefulWidget {
  const FoodPage({Key? key}) : super(key: key);

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("FOOD PAGE",style: TextStyle(color:Colors.white,fontSize: 20)));
  }
}