import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid;

  UserDataServices({required this.uid});

  CollectionReference<Map<String, dynamic>> subjectRef() =>
      _firestore.collection('users').doc(uid).collection('subjects');

  CollectionReference<Map<String, dynamic>> studyScheduleRef() =>
      _firestore.collection('users').doc(uid).collection('schedues');

  CollectionReference<Map<String, dynamic>> sessionRef() =>
      _firestore.collection('users').doc(uid).collection('sessions');
}
