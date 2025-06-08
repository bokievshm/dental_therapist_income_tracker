import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PrivacyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> getPrivacySettings() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('settings')
        .doc('privacy')
        .get();

    if (!doc.exists) {
      // Set default privacy settings
      final defaultSettings = {
        'dataSharing': false,
        'analytics': true,
        'crashReports': true,
        'practiceDataSharing': false,
        'emailNotifications': true,
        'smsNotifications': false,
        'twoFactorAuth': false,
        'lastPasswordChange': DateTime.now().toIso8601String(),
      };

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('settings')
          .doc('privacy')
          .set(defaultSettings);

      return defaultSettings;
    }

    return doc.data() ?? {};
  }

  Future<void> updatePrivacySettings(Map<String, dynamic> settings) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('settings')
        .doc('privacy')
        .set(settings);
  }

  Future<void> togglePrivacySetting(String setting, bool value) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('settings')
        .doc('privacy')
        .update({setting: value});
  }

  Future<void> updatePassword(String currentPassword, String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Reauthenticate user before changing password
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);

    // Update password
    await user.updatePassword(newPassword);

    // Update last password change timestamp
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('settings')
        .doc('privacy')
        .update({
      'lastPasswordChange': DateTime.now().toIso8601String(),
    });
  }

  Future<void> enableTwoFactorAuth() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // TODO: Implement 2FA setup
    // This would typically involve:
    // 1. Generating a secret key
    // 2. Showing QR code to user
    // 3. Verifying the setup
    // 4. Enabling 2FA in Firebase Auth

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('settings')
        .doc('privacy')
        .update({'twoFactorAuth': true});
  }

  Future<void> disableTwoFactorAuth() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // TODO: Implement 2FA removal
    // This would typically involve:
    // 1. Verifying current 2FA code
    // 2. Disabling 2FA in Firebase Auth

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('settings')
        .doc('privacy')
        .update({'twoFactorAuth': false});
  }
} 