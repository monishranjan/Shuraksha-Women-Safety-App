import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailPasswordReset extends StatefulWidget {
  const EmailPasswordReset({super.key});

  @override
  State<EmailPasswordReset> createState() => _EmailPasswordResetState();
}

class _EmailPasswordResetState extends State<EmailPasswordReset> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future emailPasswordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Stack(
            // clipBehavior: Clip.none,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 375),
                  padding: EdgeInsets.all(16),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xff009607),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.crisis_alert_outlined, size: 40,),
                      SizedBox(width: 20,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hooray!', style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),),
                            SizedBox(height: 5,),
                            Text('Password reset link sent! Please check your email', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white), maxLines: 2, overflow: TextOverflow.ellipsis,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]
          ),
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
        ),
      );

    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Stack(
            // clipBehavior: Clip.none,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 375),
                  padding: EdgeInsets.all(16),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xff77000a),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.crisis_alert_outlined, size: 40,),
                      SizedBox(width: 20,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Oops!', style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),),
                            SizedBox(height: 5,),
                            Text('The entered email is not registered. Please do sign-up first.', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white), maxLines: 2, overflow: TextOverflow.ellipsis,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]
          ),
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(right: 30, left: 30, top: 30),
            child: Column(
              children: [
                Text("Reset Password", style: GoogleFonts.montserrat(fontSize: 38, fontWeight: FontWeight.bold),),
                SizedBox(height: 30,),
                Image.asset("assets/images/forgotpassword.png", height: 250,),
                SizedBox(height: 20,),
                Text("Enter your Email and we will send you a password reset link.", style: GoogleFonts.montserrat(),),
                SizedBox(height: 10,),
                TextField(
                  autofocus: false,
                  controller: _emailController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    label: Text("Email"),
                    hintText: "Your email goes here",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20,),
                SizedBox(
                  width: 500,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      emailPasswordReset();
                    },
                    child: Text("Reset Password", style: GoogleFonts.montserrat(fontWeight: FontWeight.w400)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
