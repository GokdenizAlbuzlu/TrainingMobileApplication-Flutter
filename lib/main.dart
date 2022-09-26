import 'package:flutter/material.dart';
import 'home.dart';
import 'meal.dart';
import 'training.dart';
import 'profile.dart';
import 'colors.dart';
import 'package:genfit/screens/signin_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    home: SignInScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class AppNav extends StatefulWidget {
  const AppNav({Key? key}) : super(key: key);

  @override
  State<AppNav> createState() => _AppNavState();
}

class _AppNavState extends State<AppNav> {
  Couleurs colors = Couleurs();

  int selectedIndex = 0;
  void onTapHandler(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<Widget> pagesList = <Widget>[
    HomePage(),
    TrainingPage(),
    FoodPage(),
    ProfilPage()
    
  ];
  @override
  Widget build(BuildContext context) {
       return Scaffold(
        backgroundColor: colors.noir,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
            BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center), label: "Entrainement"),
            BottomNavigationBarItem(
                icon: Icon(Icons.restaurant), label: "Alimentation"),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: "Profil")
          ],
          onTap: onTapHandler,
          currentIndex: selectedIndex,
          selectedItemColor: colors.orange,
          backgroundColor: colors.gris,
          unselectedItemColor: colors.blanc,
        ),
        body: pagesList.elementAt(selectedIndex) ,
       );
  }
}