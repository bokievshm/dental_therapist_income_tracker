import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubscriptionService {
  static const String _subscriptionKey = 'is_subscribed';
  static const String _subscriptionExpiryKey = 'subscription_expiry';
  static const String _monthlySubscriptionId = 'monthly_subscription';

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late Stream<List<PurchaseDetails>> _subscriptionStream;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SubscriptionService() {
    _subscriptionStream = _inAppPurchase.purchaseStream;
  }

  // Collection references
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _subscriptionsCollection => _firestore.collection('users').doc(_auth.currentUser?.uid).collection('subscriptions');

  Future<bool> isSubscribed() async {
    final prefs = await SharedPreferences.getInstance();
    final isSubscribed = prefs.getBool(_subscriptionKey) ?? false;
    if (!isSubscribed) return false;

    final expiryTimestamp = prefs.getInt(_subscriptionExpiryKey);
    if (expiryTimestamp == null) return false;

    final expiryDate = DateTime.fromMillisecondsSinceEpoch(expiryTimestamp);
    return DateTime.now().isBefore(expiryDate);
  }

  Future<void> checkSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final purchaseDetails = await _inAppPurchase.queryPastPurchases();

    for (final purchase in purchaseDetails.pastPurchases) {
      if (purchase.productID == _monthlySubscriptionId) {
        // Verify the purchase with your backend
        // If valid, update the subscription status
        await _updateSubscriptionStatus(true, purchase.transactionDate ?? DateTime.now());
        break;
      }
    }
  }

  Future<void> _updateSubscriptionStatus(bool isSubscribed, DateTime expiryDate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_subscriptionKey, isSubscribed);
    await prefs.setInt(_subscriptionExpiryKey, expiryDate.millisecondsSinceEpoch);
  }

  Future<bool> canCreateInvoice() async {
    return await isSubscribed();
  }

  Future<bool> canAddMultiplePractices() async {
    return await isSubscribed();
  }

  Future<void> purchaseSubscription() async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      throw Exception('In-app purchases are not available');
    }

    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails({
      _monthlySubscriptionId,
    });

    if (response.notFoundIDs.isNotEmpty) {
      throw Exception('Product not found');
    }

    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: response.productDetails.first,
    );

    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    await _inAppPurchase.restorePurchases();
  }

  Future<Map<String, dynamic>?> getCurrentSubscription() async {
    try {
      final purchaseDetails = await _inAppPurchase.queryPastPurchases();
      if (purchaseDetails.pastPurchases.isEmpty) {
        return null;
      }

      final latestPurchase = purchaseDetails.pastPurchases.first;
      final subscriptionData = await _firestore
          .collection('subscriptions')
          .doc(latestPurchase.productID)
          .get();

      return {
        'plan': subscriptionData.data()?['plan'],
        'status': latestPurchase.status == PurchaseStatus.purchased ? 'active' : 'expired',
        'endDate': latestPurchase.transactionDate?.add(const Duration(days: 30)),
        'features': subscriptionData.data()?['features'] ?? [],
      };
    } catch (e) {
      print('Error getting current subscription: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getSubscriptionPlans() async {
    try {
      final products = await _inAppPurchase.queryProductDetails({
        'basic_plan',
        'premium_plan',
        'enterprise_plan',
      });

      return products.productDetails.map((product) {
        return {
          'id': product.id,
          'name': product.title,
          'description': product.description,
          'price': product.rawPrice,
          'features': _getPlanFeatures(product.id),
        };
      }).toList();
    } catch (e) {
      print('Error getting subscription plans: $e');
      return [];
    }
  }

  List<String> _getPlanFeatures(String planId) {
    switch (planId) {
      case 'basic_plan':
        return [
          'Basic practice management',
          'Up to 3 practices',
          'Basic reporting',
        ];
      case 'premium_plan':
        return [
          'Advanced practice management',
          'Unlimited practices',
          'Advanced reporting',
          'Custom invoicing',
          'Priority support',
        ];
      case 'enterprise_plan':
        return [
          'Enterprise practice management',
          'Unlimited practices',
          'Advanced reporting',
          'Custom invoicing',
          'Priority support',
          'API access',
          'Dedicated account manager',
        ];
      default:
        return [];
    }
  }

  Future<bool> hasFeatureAccess(String feature) async {
    final subscription = await getCurrentSubscription();
    if (subscription == null) return false;

    final features = subscription['features'] as List<dynamic>;
    return features.contains(feature);
  }

  Future<void> subscribe(String planId) async {
    try {
      final products = await _inAppPurchase.queryProductDetails({planId});
      if (products.productDetails.isEmpty) {
        throw Exception('Product not found');
      }

      final purchaseParam = PurchaseParam(
        productDetails: products.productDetails.first,
      );

      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      print('Error subscribing to plan: $e');
      rethrow;
    }
  }

  Future<void> cancelSubscription() async {
    try {
      final subscription = await getCurrentSubscription();
      if (subscription == null) {
        throw Exception('No active subscription found');
      }

      // Implement subscription cancellation logic here
      // This might involve calling a backend API or updating Firestore
    } catch (e) {
      print('Error canceling subscription: $e');
      rethrow;
    }
  }

  Future<void> changePlan(String newPlanId) async {
    try {
      await cancelSubscription();
      await subscribe(newPlanId);
    } catch (e) {
      print('Error changing subscription plan: $e');
      rethrow;
    }
  }

  Future<void> renewSubscription() async {
    try {
      final subscription = await getCurrentSubscription();
      if (subscription == null) {
        throw Exception('No active subscription found');
      }

      // Implement subscription renewal logic here
      // This might involve calling a backend API or updating Firestore
    } catch (e) {
      print('Error renewing subscription: $e');
      rethrow;
    }
  }
} 