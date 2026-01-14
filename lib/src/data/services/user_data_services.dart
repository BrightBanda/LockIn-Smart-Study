import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid;

  UserDataServices({required this.uid});

  CollectionReference<Map<String, dynamic>> subjectRef() =>
      _firestore.collection('users').doc(uid).collection('subjects');

  CollectionReference<Map<String, dynamic>> studyScheduleRef() =>
      _firestore.collection('users').doc(uid).collection('schedules');

  CollectionReference<Map<String, dynamic>> sessionRef() =>
      _firestore.collection('users').doc(uid).collection('sessions');

  CollectionReference<Map<String, dynamic>> dayRef() =>
      _firestore.collection('users').doc(uid).collection('days');

  CollectionReference<Map<String, dynamic>> weekRef() =>
      _firestore.collection('users').doc(uid).collection('weeks');

  DocumentReference<Map<String, dynamic>> streakRef() => _firestore
      .collection('users')
      .doc(uid)
      .collection('Progress')
      .doc('Streak');
}
