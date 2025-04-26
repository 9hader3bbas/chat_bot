import 'dart:developer';

import 'package:chat_bot/core/services/my_services/my_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

/// A service to handle logging user actions or events into Firestore.
class LogService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Adds a log entry to the Firestore "logs" collection.
  ///
  /// Parameters:
  /// - [query] : The message or action description.
  /// - [response] : The result or response status of the action.
  ///
  /// Automatically sets:
  /// - [log_id] : The generated document ID.
  /// - [user_id] : Fetched from currently signed-in user.
  /// - [created_at] : Server timestamp when the log was created.
  static Future<void> addLog({
    required String query,
    required String response,
  }) async {
    try {
      MyServices myServices = Get.find();
      final String? userName = myServices.sharedPreferences.getString("name");
      final String? userId = myServices.sharedPreferences.getString("user_id");

      final logRef = _firestore.collection('logs').doc();

      final logData = {
        'log_id': logRef.id,
        'user_id': userId ?? "Not Get it yet",
        'user_name': userName ?? "Unknown",
        'query': query,
        'response': response,
        'created_at': FieldValue.serverTimestamp(),
      };

      await logRef.set(logData);
    } catch (e, stackTrace) {
      log('❌ Failed to add log: $e');
      log(stackTrace.toString());
    }
  }
}
