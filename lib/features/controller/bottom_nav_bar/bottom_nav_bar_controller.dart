import 'package:chat_bot/core/constant/app_assets/app_assets.dart';
import 'package:chat_bot/features/view/pages/feed_backs/feed_backs_view.dart';
import 'package:chat_bot/features/view/pages/home/home_view.dart';
import 'package:chat_bot/features/view/pages/logs/logs_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

abstract class BottomNavBarController extends GetxController {
  changeCurrentIndex(int index);
}

class BottomNavBarControllerImpl extends BottomNavBarController {
  late int currentIndex;

  List<Widget> pages = [HomeView(), FeedBacksView(), LogsView()];
  List<String> pagesIcons = [
    AppAssets.homeIcon,
    AppAssets.feedBackIcon,
    AppAssets.logIcon
  ];
  @override
  changeCurrentIndex(int index) {
    currentIndex = index;
    HapticFeedback.lightImpact();
    update();
  }

  @override
  void onInit() {
    currentIndex = 0;
    super.onInit();
  }
}
