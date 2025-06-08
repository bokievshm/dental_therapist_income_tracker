import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String professionalTitle;
  final String? bankDetails;
  final bool isSubscribed;
  final DateTime subscriptionExpiry;
  final List<String> practiceIds;

  UserModel({
    required this.id,
    required this.name,
    required this.professionalTitle,
    this.bankDetails,
    required this.isSubscribed,
    required this.subscriptionExpiry,
    required this.practiceIds,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      professionalTitle: data['professionalTitle'] ?? '',
      bankDetails: data['bankDetails'],
      isSubscribed: data['isSubscribed'] ?? false,
      subscriptionExpiry: (data['subscriptionExpiry'] as Timestamp).toDate(),
      practiceIds: List<String>.from(data['practiceIds'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'professionalTitle': professionalTitle,
      'bankDetails': bankDetails,
      'isSubscribed': isSubscribed,
      'subscriptionExpiry': Timestamp.fromDate(subscriptionExpiry),
      'practiceIds': practiceIds,
    };
  }

  UserModel copyWith({
    String? name,
    String? professionalTitle,
    String? bankDetails,
    bool? isSubscribed,
    DateTime? subscriptionExpiry,
    List<String>? practiceIds,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      professionalTitle: professionalTitle ?? this.professionalTitle,
      bankDetails: bankDetails ?? this.bankDetails,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
      practiceIds: practiceIds ?? this.practiceIds,
    );
  }
} 