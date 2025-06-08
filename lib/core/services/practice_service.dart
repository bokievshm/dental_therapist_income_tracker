import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/practice_model.dart';

class PracticeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'practices';

  Future<List<PracticeModel>> getPractices(String userId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => PracticeModel.fromFirestore(doc))
        .toList();
  }

  Future<PracticeModel> getPractice(String practiceId) async {
    final doc = await _firestore.collection(_collection).doc(practiceId).get();
    return PracticeModel.fromFirestore(doc);
  }

  Future<String> createPractice(PracticeModel practice) async {
    final docRef = await _firestore.collection(_collection).add(practice.toFirestore());
    return docRef.id;
  }

  Future<void> updatePractice(PracticeModel practice) async {
    await _firestore
        .collection(_collection)
        .doc(practice.id)
        .update(practice.toFirestore());
  }

  Future<void> deletePractice(String practiceId) async {
    await _firestore.collection(_collection).doc(practiceId).delete();
  }
} 