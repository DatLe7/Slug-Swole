import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';


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

getFacilityData(String facility) async{
  CollectionReference data = FirebaseFirestore.instance.collection('facility');
  QuerySnapshot querySnapshot = await data.get();
  if (querySnapshot.docs.isEmpty){
    return null;
  }
  return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
}

getTodaysData() async{
  final now = DateTime.now();
  String formattedDate = DateFormat.yMMMEd().format(now);
  DocumentReference data = FirebaseFirestore.instance.collection('weekly_capacity_data').doc(formattedDate);
  DocumentSnapshot querySnapshot = await data.get();
  if (!querySnapshot.exists){
    return null;
  }
  return querySnapshot.get('tempfield');
  
}
//Todo: Add a function to get today's data from the database
//Todo: Add a function to get the most recent data from each day of the week

