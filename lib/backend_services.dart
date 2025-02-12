import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:slug_swole/home.dart';

adminAuth() async{
  CollectionReference admin = FirebaseFirestore.instance.collection('admin');

  QuerySnapshot querySnapshot = await admin.get();

  for(var doc in querySnapshot.docs){
    if (doc.get('uid') == FirebaseAuth.instance.currentUser!.uid){
      return true;
    }
  }
  return false;
}
