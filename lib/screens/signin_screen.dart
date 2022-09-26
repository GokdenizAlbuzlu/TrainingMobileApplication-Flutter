import 'package:flutter/material.dart';
import 'package:genfit/utils/color_utils.dart';
import 'package:genfit/reusable_widgets/reusable_widget.dart';
import 'package:genfit/screens/signup_screen.dart';
import 'package:genfit/main.dart';
import 'package:genfit/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  Couleurs colors = Couleurs();
  bool login =false;
  @override
  Widget build(BuildContext context) {

    FirebaseAuth.instance.authStateChanges().listen((user){
      if(user==null){
        setState(() {
               login = false;
        });
     
      }
      else{
        setState(() {
            login=true;
        });
       
      }
    });
    if(login==false){
      return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: colors.noir,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(
            children: <Widget>[
              //logoWidget("flutter_appli/assets/images/logo.png"),
              SizedBox(
                height: 30,
              ),
              reusableTextField("Enter email", Icons.person_outline, false,
                  _emailTextController,colors),
              SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Password", Icons.lock_outline, true,
                  _passwordTextController,colors),
              SizedBox(
                height: 20,
              ),
              signInSignUpButton(context, "Sign In", () {
                FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text)
                    .then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AppNav()));
                }).onError((error, stackTrace) {
                  print("Error ${error.toString()}");
                });
              },colors),
              signUpOption()
            ],
          ),
        ),
      ),
    ));
    }
    else{
      return AppNav();
    }
    
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
