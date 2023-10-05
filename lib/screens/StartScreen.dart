import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartScreen extends StatefulWidget {
  final VoidCallback showLoginPage, showRegisterPage;
  const StartScreen({Key? key, required this.showLoginPage, required this.showRegisterPage}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff282828),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 102, bottom: 86),
                child: Image(image: AssetImage("assets/images/splashImage.png"), height: 381, width: 150,),
              ),
              Text("Welcome on Board", style: GoogleFonts.montserrat(fontSize: 34, fontWeight: FontWeight.bold)),
              SizedBox(height: 13,),
              Text("Women's safety comes first", style: GoogleFonts.montserrat(),),
              SizedBox(height: 52,),
              SizedBox(
                width: 287.0,
                height: 48.0,
                child: ElevatedButton(
                  onPressed: widget.showRegisterPage,
                  child: Text("I'm new here", style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w400,
                  )),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          )
                      )
                  ),
                ),
              ),
              SizedBox(height: 20,),
              TextButton(
                onPressed: widget.showLoginPage,
                child: Text("Sign In", style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
