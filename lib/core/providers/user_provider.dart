import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  UserNotifier() : super(const AsyncValue.data(null));

  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      return doc.data() ?? {};
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update(data);
      state = AsyncValue.data(data);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateProfilePicture(String userId, String imageUrl) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profilePicture': imageUrl,
      });
      state = AsyncValue.data({...?state.value, 'profilePicture': imageUrl});
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
} 