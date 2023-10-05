library shuraksha1.globals;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// General Variables
var userFirstName = '';
var userSecondName = '';
var userEmail = '';

//----
String eContact = "";
String pContact = "";
//----
//=========================================================


// Firestore Stuff
String userId = FirebaseAuth.instance.currentUser!.uid;
final userData = FirebaseFirestore.instance.collection('users').doc(userId);
//=========================================================