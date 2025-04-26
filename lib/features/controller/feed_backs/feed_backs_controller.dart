import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

abstract class FeedBacksController extends GetxController {}

class FeedBacksControllerImpl extends FeedBacksController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var feedbackList = <Map<String, dynamic>>[].obs;
  var isFeedBacksLoading = true.obs;

  @override
  void onInit() {
    fetchFeedbacks();
    super.onInit();
  }

  // Fetch feedbacks from Firestore
  Future<void> fetchFeedbacks() async {
    try {
      isFeedBacksLoading(true);

      QuerySnapshot querySnapshot = await _firestore
          .collection("users_feedbacks")
          .orderBy("timestamp", descending: true)
          .get();

      List<Map<String, dynamic>> tempList = [];

      for (var doc in querySnapshot.docs) {
        Timestamp timestamp = doc["timestamp"] as Timestamp;
        DateTime dateTime = timestamp.toDate();
        DateTime localTime = dateTime.toLocal();

        String formattedTime = timeAgoSinceDate(localTime);

        tempList.add({
          "name": doc["name"] ?? "Unknown User",
          "message": doc["message"] ?? "",
          "timestamp": formattedTime,
          "user_id": doc["userId"] ?? ""
        });
      }

      feedbackList.assignAll(tempList); // Update the observable list
    } catch (e) {
      print("Error fetching feedbacks: $e");
    } finally {
      isFeedBacksLoading(false);
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
}
