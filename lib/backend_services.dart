import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';


adminAuth() async {
  CollectionReference admin = FirebaseFirestore.instance.collection('admin');

  QuerySnapshot querySnapshot = await admin.get();

  for (var doc in querySnapshot.docs) {
    if (doc.get('uid') == FirebaseAuth.instance.currentUser!.uid) {
      return true;
    }
  }
  return false;
}

getFacilityData(String facility) async {
  CollectionReference data = FirebaseFirestore.instance.collection('facility');
  QuerySnapshot querySnapshot = await data.get();
  if (querySnapshot.docs.isEmpty) {
    return null;
  }
  return querySnapshot.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .toList();
}

getTodaysData() async {
  final now = DateTime.now();
  String formattedDate = DateFormat.yMMMEd().format(now);
  DocumentReference data = FirebaseFirestore.instance
      .collection('weekly_capacity_data')
      .doc(formattedDate);
  DocumentSnapshot querySnapshot = await data.get();
  if (!querySnapshot.exists) {
    return null;
  }
  return querySnapshot.get('tempfield');
}
//Todo: Add a function to get today's data from the database
//Todo: Add a function to get the most recent data from each day of the week

uploadData(int capacity) async {
  CollectionReference weekly_capacity_data =
      FirebaseFirestore.instance.collection("weekly_capacity_data");
  await weekly_capacity_data
      .add({'timestamp': Timestamp.now(), 'capacity': capacity});
}

getMostRecent() async {
  QuerySnapshot document = await FirebaseFirestore.instance
      .collection("weekly_capacity_data")
      .orderBy("timestamp", descending: true)
      .limit(1)
      .get();
  //return the most recent document based off of its timestamp
  if (document.docs.isNotEmpty) {
    return document.docs.first.data() as Map<String, dynamic>;
  } else {
    return {};
  }
}

DateTime getLastX(int day) {
  DateTime now = DateTime.now();
  int daySinceX = (now.weekday - day) % 7;
  if (daySinceX < 0) {
    daySinceX += 7;
  }
  DateTime lastx = now.subtract(Duration(days: daySinceX));
  return DateTime.utc(lastx.year, lastx.month, lastx.day);
}

getDayOfWeek(String day) async {
  var x;
  switch (day) {
    case 'monday':
      x = getLastX(DateTime.monday);
      break;
    case 'tuesday':
      x = getLastX(DateTime.tuesday);
      break;
    case 'wednesday':
      x = getLastX(DateTime.wednesday);
      break;
    case 'thursday':
      x = getLastX(DateTime.thursday);
      break;
    case 'friday':
      x = getLastX(DateTime.friday);
      break;
    case 'saturday':
      x = getLastX(DateTime.saturday);
      break;
    case 'sunday':
      x = getLastX(DateTime.sunday);
      break;
    default:
      print("$day is not a valid selector!");
      return <Map<String, dynamic>>[];
  }

  Timestamp begin = Timestamp.fromDate(x.add(Duration(hours:8)));
  Timestamp end = Timestamp.fromDate(
      x.add(Duration(hours: 32, minutes: 59, seconds: 59, milliseconds: 999)));
  //Why do begin and end have an extra 8 hours added to them? To sum up, there was some weird error with the Timestamp trying to convert
  //the timestamp to UTC, despite already being in UTC? Therefore, I had to add an extra 8 hrs to the query hours in order for it not to query
  //the previous day from 16:00:00:000 to the correct day @ 15:59:59:999
  //This may cause potential issues if a user were to leave California, but lowkey that's not my problem. 
  QuerySnapshot docs = await FirebaseFirestore.instance
      .collection('weekly_capacity_data')
      .where('timestamp', isGreaterThanOrEqualTo: begin)
      .where('timestamp', isLessThanOrEqualTo: end)
      .orderBy('timestamp')
      .get();
  if (docs.docs.isNotEmpty) {
    var data = [];
    for(var doc in docs.docs){
      data.add(doc.data() as Map<String,dynamic>);
    }
    return data;
  } else {
    return <Map<String, dynamic>>[];
  }
}

getTwoWeeksAgo() async{
  DateTime now = DateTime.now();
  Timestamp begin = Timestamp.fromDate(now.subtract(const Duration(days: 14)));
  Timestamp end = Timestamp.fromDate(now);
  //Why do begin and end have an extra 8 hours added to them? To sum up, there was some weird error with the Timestamp trying to convert
  //the timestamp to UTC, despite already being in UTC? Therefore, I had to add an extra 8 hrs to the query hours in order for it not to query
  //the previous day from 16:00:00:000 to the correct day @ 15:59:59:999
  //This may cause potential issues if a user were to leave California, but lowkey that's not my problem. 
  QuerySnapshot docs = await FirebaseFirestore.instance
      .collection('weekly_capacity_data')
      .where('timestamp', isGreaterThanOrEqualTo: begin)
      .where('timestamp', isLessThanOrEqualTo: end)
      .orderBy('timestamp')
      .get();
  if (docs.docs.isNotEmpty) {
    var data = [];
    for(var doc in docs.docs){
      data.add(doc.data() as Map<String,dynamic>);
    }
    return data;
  } else {
    return <Map<String, dynamic>>[];
  }
} 

