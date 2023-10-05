import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shuraksha1/util/globals.dart';

class ParentsContactScreen extends StatefulWidget {
  const ParentsContactScreen({super.key});

  @override
  State<ParentsContactScreen> createState() => _ParentsContactScreenState();
}

class _ParentsContactScreenState extends State<ParentsContactScreen> {

  //Controllers
  TextEditingController parentsNameController = TextEditingController();
  TextEditingController parentsContactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // leading: Icon(Icons.menu_rounded, color: Colors.white,),
          title: Text("Parent's Contact", style: GoogleFonts.montserrat(),),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Container(
                height: 150,
                child: Image(image: AssetImage("assets/logo/p_c_1.png")),
              ),
              SizedBox(height: 30,),
              TextFormField(
                controller: parentsNameController,
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
                controller: parentsContactController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
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
                          "name": parentsNameController.text,
                          "contact": parentsContactController.text
                        };
                        FirebaseFirestore.instance.collection("users").doc(userId).collection("parentsContact").add(data);
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
                  stream: FirebaseFirestore.instance.collection('users').doc(userId).collection("parentsContact").snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if(snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            title: Text(snapshot.data!.docs[index]['name'], style: GoogleFonts.montserrat(color: Color(0xffa4001a), fontWeight: FontWeight.w600, fontSize: 18),),
                            subtitle: Text(snapshot.data!.docs[index]['contact'], style: GoogleFonts.montserrat(fontSize: 14),),
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
                                    onTap: () {
                                      Map<String, dynamic> data = {
                                        "name": snapshot.data!.docs[index]['name'],
                                        "contact": snapshot.data!.docs[index]['contact']
                                      };
                                      FirebaseFirestore.instance.collection("users").doc(userId).collection("emergencyContact").add(data);                                      Fluttertoast.showToast(msg: "Contact added to emergency contact");
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
      ),
    );
  }

  void deleteContact(id) {
    FirebaseFirestore.instance.collection('users').doc(userId).collection("parentsContact").doc(id).delete();
    Fluttertoast.showToast(msg: "Contact Deleted");
  }

  _callNumber(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }
}
