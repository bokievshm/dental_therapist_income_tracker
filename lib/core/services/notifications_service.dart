import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> getNotificationSettings() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('settings')
        .doc('notifications')
        .get();

    if (!doc.exists) {
      // Set default notification settings
      final defaultSettings = {
        'invoiceReminders': true,
        'monthlyReports': true,
        'practiceUpdates': true,
        'courseReminders': true,
        'marketingUpdates': false,
        'band2Reminders': true,
        'band2ReminderTime': 2, // Default to 2 months before deadline
        'band2ReminderUnit': 'months', // 'weeks' or 'months'
      };

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('settings')
          .doc('notifications')
          .set(defaultSettings);

      return defaultSettings;
    }

    return doc.data() ?? {};
  }

  Future<void> updateNotificationSettings(Map<String, dynamic> settings) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('settings')
        .doc('notifications')
        .set(settings);
  }

  Future<void> toggleNotificationSetting(String setting, bool value) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('settings')
        .doc('notifications')
        .update({setting: value});
  }

  Future<void> updateBand2ReminderSettings({
    required bool enabled,
    required int time,
    required String unit,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('settings')
        .doc('notifications')
        .update({
      'band2Reminders': enabled,
      'band2ReminderTime': time,
      'band2ReminderUnit': unit,
    });
  }
} 