import 'dart:math' as math;
import 'package:background_sms/background_sms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shake/shake.dart';
import 'package:shuraksha1/screens/EmergencyContactScreen.dart';
import 'package:shuraksha1/screens/ParentsContactScreen.dart';
import 'package:shuraksha1/util/globals.dart';

import 'Profile Page/profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Position? _currentPosition;
  String? _currentAddress;
  LocationPermission? permission;

  _getPermissions() async {
    await [Permission.sms].request();
    await [Permission.locationAlways].request();
    await [Permission.notification].request();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentUserData();
    });

    // Asking for permissions
    _getPermissions();

    // Shake
    shakeFeature();

    // Location
    _getCurrentLocation();
  }

  getCurrentUserData() async {
    try {
      // Getting data from firebase in realtime
      var docSnapshot = await userData.get();
      Map<String, dynamic> data = docSnapshot.data()!;
      setState(() {
        userFirstName = data['firstName'];
      });
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  // Shake Feature
  shakeFeature() {
    ShakeDetector detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        getAndSendSms();
      },
      minimumShakeCount: 2,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  }

  // Send Sms
  _sendSms(String phoneNumber, String message) async {
    var result = await BackgroundSms.sendMessage(phoneNumber: phoneNumber, message: message);
    if(result == SmsStatus.sent) {
      Fluttertoast.showToast(msg: "Alert Sent!!");
    } else {
      Fluttertoast.showToast(msg: "Alert not Sent!!");
    }
  }

  getAndSendSms() async {
    String messageBody = "https://maps.google.com/?daddr=${_currentPosition!.latitude}%2C${_currentPosition!.longitude}. $_currentAddress";
    if(await Permission.sms.status.isGranted) {
      _sendSms(
          "91${eContact.toString()}",
          "I am in trouble please reach me out at $messageBody"
      );
    } else {
      Fluttertoast.showToast(msg: "Something's Wrong!!!");
    }
  }

  _getCurrentLocation() async {
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      Fluttertoast.showToast(msg: "Location permissions are denied.");
      if(permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(msg: "Location permissions are permanently denied.");
      }
    }
    Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true
    ).then((Position position) {
      setState(() {
        _currentPosition = position;
        print(_currentPosition!.latitude);
        _getAddressfromLatitudeLongitude();
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  _getAddressfromLatitudeLongitude() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(_currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = "${place.street}, ${place.locality}, ${place.postalCode}";
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.exit_to_app_rounded, color: Colors.white,),
          ),
        ),
        title: Text("Shuraksha", style: GoogleFonts.montserrat(),),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20, top: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black26,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()),);
              },
              icon: Image.asset("assets/images/girl_pwr_image.png"),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/dashboard_img1.jpg"),
                            fit: BoxFit.cover,
                          )
                      ),
                      height: 200,
                      width: 450,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 77,),
                            Text("Welcome,", style: GoogleFonts.montserrat(fontSize: 16), textAlign: TextAlign.start,),
                            Text("${userFirstName}", style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, fontSize: 40, color: Color(0xffa4001a)),textAlign: TextAlign.start,),
                          ],
                        ),
                      ),
                    ),
                    //Emergency Numbers
                    SizedBox(
                      height: 114,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [Color(0xffa4001a), Color(0xff4B141C)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  )
                              ),
                              width: 198,
                              height: 114,
                              child: Column(
                                children: [
                                  SizedBox(height: 20,),
                                  Center(child: Text("Testing", style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 2,
                                  ),)),
                                  SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 32, right: 32),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Color(0xffa3001a),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(.25),
                                                    blurRadius: 4,
                                                    offset: Offset(0, 4),
                                                  )
                                                ]
                                            ),
                                            child: Center(child: Text("7", style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),)),
                                          ),
                                        ),
                                        SizedBox(width: 20,),
                                        Container(
                                          width: 30,
                                          height: 30,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Color(0xffa3001a),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(.25),
                                                    blurRadius: 4,
                                                    offset: Offset(0, 4),
                                                  )
                                                ]
                                            ),
                                            child: Center(child: Text("0", style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),)),
                                          ),
                                        ),
                                        SizedBox(width: 20,),
                                        Container(
                                          width: 30,
                                          height: 30,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Color(0xffa3001a),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(.25),
                                                    blurRadius: 4,
                                                    offset: Offset(0, 4),
                                                  )
                                                ]
                                            ),
                                            child: Center(child: Text("0", style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),//Testing Only
                          SizedBox(width: 20,),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [Color(0xffa4001a), Color(0xff4B141C)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                )
                            ),
                            width: 198,
                            height: 114,
                            child: Column(
                              children: [
                                SizedBox(height: 20,),
                                Center(child: Text("Police", style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 2,
                                ),)),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 32, right: 32),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Color(0xffa3001a),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(.25),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 4),
                                                )
                                              ]
                                          ),
                                          child: Center(child: Text("1", style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),)),
                                        ),
                                      ),
                                      SizedBox(width: 20,),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Color(0xffa3001a),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(.25),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 4),
                                                )
                                              ]
                                          ),
                                          child: Center(child: Text("0", style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),)),
                                        ),
                                      ),
                                      SizedBox(width: 20,),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Color(0xffa3001a),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(.25),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 4),
                                                )
                                              ]
                                          ),
                                          child: Center(child: Text("0", style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),)),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),//Police
                          SizedBox(width: 20,),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [Color(0xffa4001a), Color(0xff4B141C)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                )
                            ),
                            width: 198,
                            height: 114,
                            child: Column(
                              children: [
                                SizedBox(height: 20,),
                                Center(child: Text("Ambulance", style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                ),)),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 32, right: 32),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Color(0xffa3001a),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(.25),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 4),
                                                )
                                              ]
                                          ),
                                          child: Center(child: Text("1", style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),)),
                                        ),
                                      ),
                                      SizedBox(width: 20,),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Color(0xffa3001a),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(.25),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 4),
                                                )
                                              ]
                                          ),
                                          child: Center(child: Text("0", style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),)),
                                        ),
                                      ),
                                      SizedBox(width: 20,),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Color(0xffa3001a),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(.25),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 4),
                                                )
                                              ]
                                          ),
                                          child: Center(child: Text("2", style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),)),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),//Hospital
                          SizedBox(width: 20,),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [Color(0xffa4001a), Color(0xff4B141C)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                )
                            ),
                            width: 198,
                            height: 114,
                            child: Column(
                              children: [
                                SizedBox(height: 20,),
                                Center(child: Text("Women's Helpline", style: GoogleFonts.montserrat(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),)),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 24),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Color(0xffa3001a),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(.25),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 4),
                                                )
                                              ]
                                          ),
                                          child: Center(child: Text("1", style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),)),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Color(0xffa3001a),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(.25),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 4),
                                                )
                                              ]
                                          ),
                                          child: Center(child: Text("0", style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),)),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Color(0xffa3001a),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(.25),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 4),
                                                )
                                              ]
                                          ),
                                          child: Center(child: Text("9", style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),)),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Color(0xffa3001a),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(.25),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 4),
                                                )
                                              ]
                                          ),
                                          child: Center(child: Text("0", style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),)),
                                        ),
                                      ),

                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),//Women's Helpline
                        ],
                      ),
                    ),
                    SizedBox(height: 30,),
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ParentsContactScreen()),
                              );
                            },
                            child: Container(
                              height: 154,
                              width: 154,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [Color(0xffa4001a), Color(0xff4B141C)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Icon(CupertinoIcons.person_2_fill, size: 70,),
                                    SizedBox(height: 10,),
                                    Text("Parent's Contact", style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500
                                    ),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const EmergencyContactScreen()),
                              );
                            },
                            child: Container(
                              height: 154,
                              width: 154,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [Color(0xffa4001a), Color(0xff4B141C)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Column(
                                children: [
                                  SizedBox(height: 10,),
                                  Icon(Icons.emergency_rounded, size: 80,),
                                  SizedBox(height: 10,),
                                  Text("Emergency Contact", style: GoogleFonts.montserrat(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500
                                  ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => const GestureMessageScreen()),
                              // );
                              Fluttertoast.showToast(msg: "More into this is coming!!!\nHave patience");
                            },
                            child: Container(
                              height: 154,
                              width: 154,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [Color(0xffa4001a), Color(0xff4B141C)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Column(
                                children: [
                                  SizedBox(height: 20,),
                                  Icon(Icons.vibration_rounded, size: 60,),
                                  SizedBox(height: 10,),
                                  Text("Gesture Feature", style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500
                                  ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
                                builder: (context) => Container(
                                  padding: EdgeInsets.all(30),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Make Selection!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36, color: Color(0xffa4001a)),),
                                      Text("Select one of the options given below."),
                                      SizedBox(height: 30,),
                                      GestureDetector(
                                        onTap: () async {
                                          String messageBody = "https://maps.google.com/?daddr=${_currentPosition!.latitude}%2C${_currentPosition!.longitude}. $_currentAddress";
                                          if(await Permission.sms.status.isGranted) {
                                            _sendSms(
                                                "91${eContact.toString()}",
                                                "This is my location - $messageBody"
                                            );
                                          } else {
                                            Fluttertoast.showToast(msg: "Something's Wrong!!!");
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(20.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: Colors.grey.shade600,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(Icons.location_pin, size: 60.0, color: Color(0xffa4001a),),
                                              SizedBox(width: 10.0,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Send Location", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xffa4001a), fontSize: 18),),
                                                  Text("Send your location to loved one's in case\nof an emergency", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                      GestureDetector(
                                        onTap: () async {
                                          String messageBody = "https://maps.google.com/?daddr=${_currentPosition!.latitude}%2C${_currentPosition!.longitude}. $_currentAddress";
                                          if(await Permission.sms.status.isGranted) {
                                            _sendSms(
                                                "91${eContact.toString()}",
                                                "I am in trouble help me at - $messageBody"
                                            );
                                          } else {
                                            Fluttertoast.showToast(msg: "Something's Wrong!!!");
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(20.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: Colors.grey.shade600,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(Icons.add_alert_sharp, size: 60.0, color: Color(0xffa4001a),),
                                              SizedBox(width: 10.0,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Send Alert!!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xffa4001a)),),
                                                  Text("Send emergency alert to your loved one's\nor your parent's", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 154,
                              width: 154,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [Color(0xffa4001a), Color(0xff4B141C)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: 15,),
                                    Icon(Icons.location_on, size: 70,),
                                    SizedBox(height: 10,),
                                    Text("Location | Alert", style: GoogleFonts.montserrat(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500
                                    ),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 60, bottom: 40),
                      child: Center(
                        child: Text(
                          "Designed by Monish Ranjan", style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w100
                        ),
                        ),
                      ),
                    )
                  ]
              )
          )
      ),
    );
  }

  _callNumber(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }
}
