import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_therapist_income_tracker/core/services/invoice_service.dart';
import 'package:dental_therapist_income_tracker/core/models/invoice_model.dart';
import 'package:dental_therapist_income_tracker/core/models/practice_model.dart';
import 'package:dental_therapist_income_tracker/core/models/daily_activity_model.dart';
import 'package:dental_therapist_income_tracker/core/models/nhs_course_model.dart';

@GenerateMocks(
    [FirebaseFirestore, CollectionReference, DocumentReference, Query])
void main() {
  late InvoiceService invoiceService;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockQuery mockQuery;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockQuery = MockQuery();
    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.where(any, isEqualTo: anyNamed('isEqualTo')))
        .thenReturn(mockQuery);
    invoiceService = InvoiceService(mockFirestore);
  });

  group('InvoiceService Tests', () {
    test('generateInvoice should create invoice with correct calculations',
        () async {
      // Arrange
      const userId = 'test_user_id';
      final practice = PracticeModel(
        id: 'test_practice_id',
        name: 'Test Practice',
        address: 'Test Address',
        contactEmail: 'test@example.com',
        practiceManagerName: 'Test Manager',
        managerEmail: 'manager@example.com',
        managerPhone: '1234567890',
        udaRate: 10.0,
        defaultUDARate: 10.0,
        defaultPrivatePercentage: 50.0,
        defaultHygieneFee: 100.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final startDate = DateTime(2024, 1, 1);
      final endDate = DateTime(2024, 1, 31);

      final activities = [
        DailyActivityModel(
          id: '1',
          userId: userId,
          practiceId: practice.id,
          dateOfService: DateTime(2024, 1, 15),
          activityType: ActivityType.hygiene,
          hygieneAppointmentFeeApplied: 100.0,
          totalPatientChargePrivate: 0.0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        DailyActivityModel(
          id: '2',
          userId: userId,
          practiceId: practice.id,
          dateOfService: DateTime(2024, 1, 20),
          activityType: ActivityType.private,
          hygieneAppointmentFeeApplied: 0.0,
          totalPatientChargePrivate: 200.0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final courses = [
        NHSCourseModel(
          id: '1',
          userId: userId,
          practiceId: practice.id,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
          udas: 10,
          udaRate: 10.0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      // Act
      final invoice = await invoiceService.generateInvoice(
        userId: userId,
        practice: practice,
        startDate: startDate,
        endDate: endDate,
        activities: activities,
        courses: courses,
      );

      // Assert
      expect(invoice.userId, equals(userId));
      expect(invoice.practiceId, equals(practice.id));
      expect(invoice.totalUdas, equals(10));
      expect(invoice.udaEarnings, equals(100.0));
      expect(invoice.hygieneEarnings, equals(100.0));
      expect(invoice.privateEarnings, equals(200.0));
      expect(invoice.totalEarnings, equals(400.0));
    });

    test('generateInvoice should throw error for invalid dates', () async {
      // Arrange
      const userId = 'test_user_id';
      final practice = PracticeModel(
        id: 'test_practice_id',
        name: 'Test Practice',
        address: 'Test Address',
        contactEmail: 'test@example.com',
        practiceManagerName: 'Test Manager',
        managerEmail: 'manager@example.com',
        managerPhone: '1234567890',
        udaRate: 10.0,
        defaultUDARate: 10.0,
        defaultPrivatePercentage: 50.0,
        defaultHygieneFee: 100.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final startDate = DateTime(2024, 1, 31);
      final endDate = DateTime(2024, 1, 1);

      // Act & Assert
      expect(
        () => invoiceService.generateInvoice(
          userId: userId,
          practice: practice,
          startDate: startDate,
          endDate: endDate,
          activities: [],
          courses: [],
        ),
        throwsException,
      );
    });

    test('generateInvoice should throw error for empty userId', () async {
      // Arrange
      final practice = PracticeModel(
        id: 'test_practice_id',
        name: 'Test Practice',
        address: 'Test Address',
        contactEmail: 'test@example.com',
        practiceManagerName: 'Test Manager',
        managerEmail: 'manager@example.com',
        managerPhone: '1234567890',
        udaRate: 10.0,
        defaultUDARate: 10.0,
        defaultPrivatePercentage: 50.0,
        defaultHygieneFee: 100.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Act & Assert
      expect(
        () => invoiceService.generateInvoice(
          userId: '',
          practice: practice,
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          activities: [],
          courses: [],
        ),
        throwsException,
      );
    });
  });
}
