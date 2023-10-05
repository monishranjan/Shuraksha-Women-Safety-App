import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../util/globals.dart';

class EmergencyContactScreen extends StatefulWidget {
  const EmergencyContactScreen({super.key});

  @override
  State<EmergencyContactScreen> createState() => _EmergencyContactScreenState();
}

class _EmergencyContactScreenState extends State<EmergencyContactScreen> {

  TextEditingController emergencyNameController = TextEditingController();
  TextEditingController emergencyContactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.menu_rounded, color: Colors.white,),
        title: Text("Emergency Contact", style: GoogleFonts.montserrat(),),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Container(
              height: 150,
              child: Image(image: AssetImage("assets/logo/p_c_1.png")),
            ),
            SizedBox(height: 30,),
            TextFormField(
              controller: emergencyNameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined),
                labelText: "Full Name",
                hintText: "Full Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: emergencyContactController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined),
                labelText: "Phone No",
                hintText: "Phone No",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      Map<String, dynamic> data = {
                        "name": emergencyNameController.text,
                        "contact": emergencyContactController.text
                      };
                      FirebaseFirestore.instance.collection("users").doc(userId).collection("emergencyContact").add(data);
                      Fluttertoast.showToast(msg: "Contact Added");
                    },
                    child: Text("Save", style: GoogleFonts.montserrat(),),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15,),
            Row(
              children: [
                Icon(Icons.crisis_alert_rounded, color: Color(0xffa4001a),),
                SizedBox(width: 10,),
                Text('Note : If you want to add number as an\nemergency contact then click on add icon.', style: GoogleFonts.montserrat(fontSize: 12),),
              ],
            ),
            SizedBox(height: 20,),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').doc(userId).collection("emergencyContact").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) =>
                          Card(
                            child: ListTile(
                              title: Text(snapshot.data!.docs[index]['name'],
                                style: GoogleFonts.montserrat(
                                    color: Color(0xffa4001a),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),),
                              subtitle: Text(
                                snapshot.data!.docs[index]['contact'],
                                style: GoogleFonts.montserrat(fontSize: 14),),
                              trailing: SizedBox(
                                width: 110,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        pContact = snapshot.data!.docs[index]['contact'];
                                        _callNumber('+91${pContact.toString()}');
                                      },
                                      child: Icon(Icons.call,),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        await FirebaseFirestore.instance.collection("users").doc(userId).collection('gestureMessageContacts').doc().set({
                                          'firstName': snapshot.data!.docs[index]['name'],
                                          'lastName': snapshot.data!.docs[index]['contact'],
                                        });
                                        eContact = snapshot.data!.docs[index]['contact'];
                                        Fluttertoast.showToast(msg: "Contact added for gesture message");
                                      },
                                      child: Icon(Icons.add,),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        deleteContact(
                                            snapshot.data!.docs[index].id);
                                      },
                                      child: Icon(Icons.delete_forever,),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _callNumber(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  void deleteContact(id) {
    FirebaseFirestore.instance.collection('users').doc(userId).collection("emergencyContact").doc(id).delete();
    Fluttertoast.showToast(msg: "Contact Deleted");
  }

}