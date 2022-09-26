import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'addTraining.dart';
class TrainingPage extends StatefulWidget {
  const TrainingPage({Key? key}) : super(key: key);

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  Couleurs colors = Couleurs();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(children: [
        SizedBox(
          height: 100,
        ),
        Text(
          "Entrainements",
          style: TextStyle(color: colors.blanc, fontSize: 20),
        ),
        SizedBox(height:50),
        SizedBox(
          width: 400,
          height: 100,
          child: ElevatedButton(
              onPressed: (){
                 Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AddTraining()));
              },
              
              child: Text(
                "Mes entrainements",
                style: TextStyle(
                    color: colors.noir,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
              // Foreground color
              onPrimary: colors.gris,
              // Background color
              primary: colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)))
            ).copyWith(elevation: ButtonStyleButton.allOrNull(10)),
                  
              ),
        )
      ]),
    );
  }
}
