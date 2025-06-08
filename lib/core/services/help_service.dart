import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HelpService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> getFAQs() async {
    final snapshot = await _firestore.collection('faqs').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getGuides() async {
    final snapshot = await _firestore.collection('guides').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> submitSupportTicket({
    required String subject,
    required String message,
    required String category,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore.collection('support_tickets').add({
      'userId': user.uid,
      'userEmail': user.email,
      'subject': subject,
      'message': message,
      'category': category,
      'status': 'open',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>> getSupportTickets() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final snapshot = await _firestore
        .collection('support_tickets')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<void> updateSupportTicket({
    required String ticketId,
    required String message,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore.collection('support_tickets').doc(ticketId).update({
      'message': message,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
} 