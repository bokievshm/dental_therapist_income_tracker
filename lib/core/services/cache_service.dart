import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/practice_model.dart';
import '../models/invoice_model.dart';
import '../models/daily_activity_model.dart';
import '../models/nhs_course_model.dart';
import 'logging_service.dart';

final cacheServiceProvider = Provider<CacheService>((ref) {
  return CacheService(ref.watch(loggingServiceProvider));
});

class CacheService {
  final LoggingService _logger;
  static const String _practicesBox = 'practices';
  static const String _invoicesBox = 'invoices';
  static const String _activitiesBox = 'activities';
  static const String _coursesBox = 'courses';
  static const String _settingsBox = 'settings';

  CacheService(this._logger);

  Future<void> initialize() async {
    try {
      await Hive.initFlutter();
      Hive.registerAdapter(PracticeModelAdapter());
      Hive.registerAdapter(InvoiceModelAdapter());
      Hive.registerAdapter(DailyActivityModelAdapter());
      Hive.registerAdapter(NHSCourseModelAdapter());
      await Hive.openBox<PracticeModel>(_practicesBox);
      await Hive.openBox<InvoiceModel>(_invoicesBox);
      await Hive.openBox<DailyActivityModel>(_activitiesBox);
      await Hive.openBox<NHSCourseModel>(_coursesBox);
      await Hive.openBox(_settingsBox);
      _logger.info('Cache service initialized successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to initialize cache service', e, stackTrace);
      rethrow;
    }
  }

  // Practice caching
  Future<void> cachePractices(List<PracticeModel> practices) async {
    try {
      final box = Hive.box<PracticeModel>(_practicesBox);
      await box.clear();
      await box.addAll(practices);
      _logger.info('Practices cached successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to cache practices', e, stackTrace);
    }
  }

  List<PracticeModel> getCachedPractices() {
    try {
      final box = Hive.box<PracticeModel>(_practicesBox);
      return box.values.toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to get cached practices', e, stackTrace);
      return [];
    }
  }

  // Invoice caching
  Future<void> cacheInvoices(List<InvoiceModel> invoices) async {
    try {
      final box = Hive.box<InvoiceModel>(_invoicesBox);
      await box.clear();
      await box.addAll(invoices);
      _logger.info('Invoices cached successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to cache invoices', e, stackTrace);
    }
  }

  List<InvoiceModel> getCachedInvoices() {
    try {
      final box = Hive.box<InvoiceModel>(_invoicesBox);
      return box.values.toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to get cached invoices', e, stackTrace);
      return [];
    }
  }

  // Activity caching
  Future<void> cacheActivities(List<DailyActivityModel> activities) async {
    try {
      final box = Hive.box<DailyActivityModel>(_activitiesBox);
      await box.clear();
      await box.addAll(activities);
      _logger.info('Activities cached successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to cache activities', e, stackTrace);
    }
  }

  List<DailyActivityModel> getCachedActivities() {
    try {
      final box = Hive.box<DailyActivityModel>(_activitiesBox);
      return box.values.toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to get cached activities', e, stackTrace);
      return [];
    }
  }

  // Course caching
  Future<void> cacheCourses(List<NHSCourseModel> courses) async {
    try {
      final box = Hive.box<NHSCourseModel>(_coursesBox);
      await box.clear();
      await box.addAll(courses);
      _logger.info('Courses cached successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to cache courses', e, stackTrace);
    }
  }

  List<NHSCourseModel> getCachedCourses() {
    try {
      final box = Hive.box<NHSCourseModel>(_coursesBox);
      return box.values.toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to get cached courses', e, stackTrace);
      return [];
    }
  }

  // Settings caching
  Future<void> cacheSetting(String key, dynamic value) async {
    try {
      final box = Hive.box(_settingsBox);
      await box.put(key, jsonEncode(value));
      _logger.info('Setting cached successfully: $key');
    } catch (e, stackTrace) {
      _logger.error('Failed to cache setting: $key', e, stackTrace);
    }
  }

  T? getCachedSetting<T>(
      String key, T Function(Map<String, dynamic>) fromJson) {
    try {
      final box = Hive.box(_settingsBox);
      final value = box.get(key);
      if (value == null) return null;
      return fromJson(jsonDecode(value));
    } catch (e, stackTrace) {
      _logger.error('Failed to get cached setting: $key', e, stackTrace);
      return null;
    }
  }

  // Cache clearing
  Future<void> clearCache() async {
    try {
      await Hive.box<PracticeModel>(_practicesBox).clear();
      await Hive.box<InvoiceModel>(_invoicesBox).clear();
      await Hive.box<DailyActivityModel>(_activitiesBox).clear();
      await Hive.box<NHSCourseModel>(_coursesBox).clear();
      await Hive.box(_settingsBox).clear();
      _logger.info('Cache cleared successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to clear cache', e, stackTrace);
    }
  }

  // Cache size
  Future<int> getCacheSize() async {
    try {
      int size = 0;
      size += Hive.box<PracticeModel>(_practicesBox).length;
      size += Hive.box<InvoiceModel>(_invoicesBox).length;
      size += Hive.box<DailyActivityModel>(_activitiesBox).length;
      size += Hive.box<NHSCourseModel>(_coursesBox).length;
      size += Hive.box(_settingsBox).length;
      return size;
    } catch (e, stackTrace) {
      _logger.error('Failed to get cache size', e, stackTrace);
      return 0;
    }
  }
}
