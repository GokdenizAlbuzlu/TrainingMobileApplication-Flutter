import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:genfit/reusable_widgets/reusable_widget.dart';
import 'package:genfit/main.dart';
import 'package:genfit/utils/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:genfit/colors.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection("users");
  Couleurs colors =  Couleurs();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: colors.noir,
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter UserName", Icons.person_outline, false,
                    _userNameTextController,colors),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email Id", Icons.person_outline, false,
                    _emailTextController,colors),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outlined, true,
                    _passwordTextController,colors),
                const SizedBox(
                  height: 20,
                ),
                signInSignUpButton(context,"Sign Up",
                     () {
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text)
                          .then((userCred) {

                        print("Created New Account");
                        users.doc(userCred.user!.uid).set({
                          "pseudo" : _userNameTextController.text,
                          "email" : userCred.user!.email,
                          "calList":[0,0,0,0,0,0,0],
                          "taille":"",
                          "poids":"",
                          "calObj":""
                        });
                        userCred.user!.updateDisplayName(_userNameTextController.text);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AppNav()));
                      }).onError((error, stackTrace) {
                        print("Error ${error.toString()}");
                      });
                    },
                    colors)
              ],
            ),
          ))),
    );
  }
}
