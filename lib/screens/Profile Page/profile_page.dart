import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../util/globals.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentUserData();
    });
  }

  getCurrentUserData() async {
    try {
      // Getting data from firebase in realtime
      var docSnapshot = await userData.get();
      Map<String, dynamic> data = docSnapshot.data()!;
      setState(() {
        userFirstName = data['firstName'];
        userSecondName = data['lastName'];
        userEmail = data['email'];
      });
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  //Variable
  String? profilePic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: GoogleFonts.montserrat(),),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.support_agent_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final XFile? pickProfileImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if(pickProfileImage != null) {
                        setState(() {
                          profilePic = pickProfileImage.path;
                        });
                      }
                    },
                    child: Container(
                      child: profilePic == null
                          ? CircleAvatar(
                        radius: 70,
                        backgroundColor: Color(0xff2b2b2b),
                        child: Image.asset(
                          'assets/images/girl_pwr_image.png',
                          height: 80,
                          width: 80,
                        ),
                      ) : CircleAvatar(
                        radius: 70,
                        backgroundImage: FileImage(File(profilePic!)),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(0xffa4001a),
                      ),
                      child: Icon(LineAwesomeIcons.alternate_pencil, color: Colors.white, size: 20,),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10,),
              Text("${userFirstName} ${userSecondName}", style: GoogleFonts.montserrat(
                  color: Color(0xffa4001a),
                  fontWeight: FontWeight.w600,
                  fontSize: 20
              ),),
              Text("${userEmail}", style: GoogleFonts.montserrat(fontSize: 12),),
              SizedBox(height: 20,),
              SizedBox(
                width: 175,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const UpdateProfileScreen()),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffa4001a), side: BorderSide.none, shape: StadiumBorder(),
                  ),
                  child: Text("Edit Profile", style: GoogleFonts.montserrat(),),
                ),
              ),
              SizedBox(height: 30,),
              Divider(),
              SizedBox(height: 10,),
              ProfileMenuWidget(
                title: 'Settings',
                icon: LineAwesomeIcons.cog,
                onPress: () {  },
              ),
              ProfileMenuWidget(
                title: 'Application Guide',
                icon: LineAwesomeIcons.book_open,
                onPress: () {  },
              ),
              Divider(),
              ProfileMenuWidget(
                title: 'About Us',
                icon: LineAwesomeIcons.info_circle,
                onPress: () {  },
              ),
              ProfileMenuWidget(
                title: 'Logout',
                icon: LineAwesomeIcons.alternate_sign_out,
                textColor: Color(0xffa4001a),
                endIcon: false,
                onPress: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> imageUpload(File filepath, String? reference) async {
    try {
      final finalName = '${FirebaseAuth.instance.currentUser!.uid}${DateTime.now().second}';
    } catch (e) {
    }
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color(0xffa4001a).withOpacity(0.2),
        ),
        child: Icon(icon, color: Color(0xffa4001a), size: 20,),
      ),
      title: Text(title, style: GoogleFonts.montserrat(fontSize: 14)?.apply(color: textColor)),
      trailing: endIcon? Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.white.withOpacity(0.2),
        ),
        child: Icon(LineAwesomeIcons.angle_right, size: 18.0, color: Colors.white,),
      ) : null,
    );
  }
}