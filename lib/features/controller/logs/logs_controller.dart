import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

abstract class LogsController extends GetxController {}

class LogsControllerImpl extends LogsController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;
  var logs = <Map<String, dynamic>>[].obs;

  /// Fetch all logs from Firestore
  Future<void> fetchLogs() async {
    try {
      isLoading.value = true;
      logs.clear();
      final querySnapshot = await _firestore
          .collection('logs')
          .orderBy('created_at', descending: true)
          .get();
      List<Map<String, dynamic>> tempList = [];

      for (var doc in querySnapshot.docs) {
        Timestamp timestamp = doc["created_at"] as Timestamp;
        DateTime dateTime = timestamp.toDate();
        DateTime localTime = dateTime.toLocal();

        String formattedTime = timeAgoSinceDate(localTime);

        tempList.add({
          "query": doc["query"] ?? "----------------------",
          "user_name": doc["user_name"] ?? "Unknown",
          "created_at": formattedTime,
          "user_id": doc["user_id"] ?? "not Get it yet",
          "log_id": doc["log_id"]
        });
      }
      logs.assignAll(tempList); // Update the observable list
    } catch (e) {
      print('❌ Error fetching logs: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete a log by its document ID
  Future<void> deleteLog(String logId) async {
    try {
      await _firestore.collection('logs').doc(logId).delete();
      logs.removeWhere((log) => log['log_id'] == logId);
      fetchLogs();
    } catch (e) {
      print('❌ Error deleting log: $e');
    }
  }

  /// 🔹 Custom Time Ago Formatting Method (Your Method)
  String timeAgoSinceDate(DateTime date, {bool numericDates = true}) {
    final date2 = DateTime.now().toLocal();
    final difference = date2.difference(date);

    if (difference.inSeconds < 5) {
      return 'Just now';
    } else if (difference.inSeconds <= 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes <= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inMinutes <= 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours <= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inHours <= 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays <= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inDays <= 6) {
      return '${difference.inDays} days ago';
    } else if ((difference.inDays / 7).ceil() <= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if ((difference.inDays / 7).ceil() <= 4) {
      return '${(difference.inDays / 7).ceil()} weeks ago';
    } else if ((difference.inDays / 30).ceil() <= 1) {
      return (numericDates) ? '1 month ago' : 'Last month';
    } else if ((difference.inDays / 30).ceil() <= 12) {
      return '${(difference.inDays / 30).ceil()} months ago';
    } else if ((difference.inDays / 365).ceil() <= 1) {
      return (numericDates) ? '1 year ago' : 'Last year';
    }
    return '${(difference.inDays / 365).floor()} years ago';
  }

  @override
  void onInit() {
    fetchLogs();
    super.onInit();
  }
}
