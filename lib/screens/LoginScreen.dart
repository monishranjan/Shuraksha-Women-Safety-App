import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shuraksha1/screens/verification_page/emailPassword_reset.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginScreen({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Editing Controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Firebase
  final _auth = FirebaseAuth.instance;

  Future signIn() async {
    await _auth.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                    Text("Welcome Back", style: GoogleFonts.montserrat(fontSize: 38, fontWeight: FontWeight.bold)),
                    Text("Always be ready for an emergency", style: GoogleFonts.montserrat(),),

                    SizedBox(height: 50,),
                    //Text Fields
                    Column(
                      children: [
                        TextField(
                          autofocus: false,
                          controller: _emailController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.mail),
                            label: Text("E-Mail"),
                            hintText: "E-Mail",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20,),
                        TextField(
                          autofocus: false,
                          controller: _passwordController,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.key),
                            label: Text("Password"),
                            hintText: "Password",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // showModalBottomSheet(
                                //   context: context,
                                //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
                                //   builder: (context) => Container(
                                //     padding: EdgeInsets.all(30),
                                //     child: Column(
                                //       crossAxisAlignment: CrossAxisAlignment.start,
                                //       children: [
                                //         Text("Make Selection!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36, color: Color(0xffa4001a)),),
                                //         Text("Select one of the options given below to reset your password."),
                                //         SizedBox(height: 30,),
                                //         GestureDetector(
                                //           onTap: () {
                                //             Navigator.pop(context);
                                //             Navigator.push(context, MaterialPageRoute(builder: (context) => const Placeholder()));
                                //           },
                                //           child: Container(
                                //             padding: EdgeInsets.all(20.0),
                                //             decoration: BoxDecoration(
                                //               borderRadius: BorderRadius.circular(10.0),
                                //               color: Colors.grey.shade600,
                                //             ),
                                //             child: Row(
                                //               children: [
                                //                 Icon(Icons.mail_outline_rounded, size: 60.0,),
                                //                 SizedBox(width: 10.0,),
                                //                 Column(
                                //                   crossAxisAlignment: CrossAxisAlignment.start,
                                //                   children: [
                                //                     Text("E-Mail", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xffa4001a), fontSize: 18),),
                                //                     Text("Reset via Mail Verification", style: TextStyle(fontWeight: FontWeight.w400),),
                                //                   ],
                                //                 )
                                //               ],
                                //             ),
                                //           ),
                                //         ),
                                //         SizedBox(height: 20,),
                                //         GestureDetector(
                                //           onTap: () {},
                                //           child: Container(
                                //             padding: EdgeInsets.all(20.0),
                                //             decoration: BoxDecoration(
                                //               borderRadius: BorderRadius.circular(10.0),
                                //               color: Colors.grey.shade600,
                                //             ),
                                //             child: Row(
                                //               children: [
                                //                 Icon(Icons.mobile_friendly_rounded, size: 60.0,),
                                //                 SizedBox(width: 10.0,),
                                //                 Column(
                                //                   crossAxisAlignment: CrossAxisAlignment.start,
                                //                   children: [
                                //                     Text("Phone No", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xffa4001a), fontSize: 18),),
                                //                     Text("Reset via Phone Verification", style: TextStyle(fontWeight: FontWeight.w400),),
                                //                   ],
                                //                 )
                                //               ],
                                //             ),
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // );
                                Navigator.push(context, MaterialPageRoute(builder: (context) {return EmailPasswordReset();}));
                              },
                              child: Text("Forgot Password?", style: GoogleFonts.montserrat(fontWeight: FontWeight.w400, color: Colors.white)),
                            )
                        ),// Forgot Password
                        SizedBox(height: 20,),
                        SizedBox(
                          width: 500,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              signIn();
                            },
                            child: Text("SIGN IN", style: GoogleFonts.montserrat(fontWeight: FontWeight.w400)),
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
                              onPressed: () {},
                              icon: Image.asset("assets/images/google.png", width: 20,),
                              label: Text("Sign-in with Google", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Don't have an account? ", style: GoogleFonts.montserrat(fontWeight: FontWeight.w400),),
                            GestureDetector(
                              onTap: widget.showRegisterPage,
                              child: Text(
                                "SignUp",
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
