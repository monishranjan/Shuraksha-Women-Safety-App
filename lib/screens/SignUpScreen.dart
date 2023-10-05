import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../util/globals.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignUpScreen({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  //Editing Controller
  final _firstNameEditingController = TextEditingController();
  final _secondNameEditingController = TextEditingController();
  final _emailEditingController = TextEditingController();
  final _phoneEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();
  final _confirmPasswordEditingController = TextEditingController();

  @override
  void dispose() {
    _firstNameEditingController.dispose();
    _secondNameEditingController.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Future signUp() async {
    // Create User
    if(passwordConfirmed()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailEditingController.text.trim(),
        password: _passwordEditingController.text.trim(),
      );

      // Add user details
      addUserDetails(
        _firstNameEditingController.text.trim(),
        _secondNameEditingController.text.trim(),
        _emailEditingController.text.trim(),
      );

      await FirebaseFirestore.instance.collection("users").doc(userId).collection("parentsContact");
      await FirebaseFirestore.instance.collection("users").doc(userId).collection("emergencyContact");
      await FirebaseFirestore.instance.collection("users").doc(userId).collection("gestureMessageContacts");
    }
  }

  Future addUserDetails(String firstName, String lastName, String email) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection("users").doc(userId).set({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    });
  }

  bool passwordConfirmed() {
    if(_passwordEditingController.text.trim() == _confirmPasswordEditingController.text.trim()) {
      Fluttertoast.showToast(msg: "Account Created :) ");
      return true;
    } else {
      Fluttertoast.showToast(msg: "Both passwords are not same.");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.cover,
              )
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    // SizedBox(height: 150,),
                    Text("Get on Board!", style: GoogleFonts.montserrat(fontSize: 38, fontWeight: FontWeight.bold)),
                    Text("Create your profile to start the journey", style: GoogleFonts.montserrat(),),

                    SizedBox(height: 50,),
                    //Text Fields
                    Column(
                      children: [
                        TextField(
                          autofocus: false,
                          controller: _firstNameEditingController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            label: Text("First Name"),
                            hintText: "First Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextField(
                          autofocus: false,
                          controller: _secondNameEditingController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            label: Text("Last Name"),
                            hintText: "Last Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextField(
                          autofocus: false,
                          controller: _emailEditingController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.mail),
                            label: Text("E-Mail"),
                            hintText: "E-Mail",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextField(
                          autofocus: false,
                          controller: _passwordEditingController,
                          obscureText: true,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.key),
                            label: Text("Password"),
                            hintText: "Password",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextField(
                          autofocus: false,
                          controller: _confirmPasswordEditingController,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.key),
                            label: Text("Confirm Password"),
                            hintText: "Confirm Password",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20,),
                        SizedBox(
                          width: 500,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              signUp();
                            },
                            child: Text("SIGN UP", style: GoogleFonts.montserrat(fontWeight: FontWeight.w400)),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: Text("OR")),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: OutlinedButton.icon(
                              onPressed: () {
                              },
                              icon: Image.asset("assets/images/google.png", width: 20,),
                              label: Text("Sign-in with Google", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Already have an account? ", style: GoogleFonts.montserrat(fontWeight: FontWeight.w400),),
                            GestureDetector(
                              onTap: widget.showLoginPage,
                              child: Text(
                                "Login",
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xffa4001a),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
