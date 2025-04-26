import 'package:chat_bot/core/constant/app_assets/app_assets.dart';
import 'package:chat_bot/core/constant/colors/colors.dart';
import 'package:chat_bot/core/services/my_services/my_services.dart';
import 'package:chat_bot/core/shared/widgets/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:chat_bot/core/shared/widgets/feed_back/feed_back_widget.dart';
import 'package:chat_bot/features/controller/feed_backs/feed_backs_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FeedBacksView extends StatelessWidget {
  FeedBacksView({super.key});
  FeedBacksControllerImpl controller = Get.put(FeedBacksControllerImpl());
  @override
  Widget build(BuildContext context) {
    MyServices myServices = Get.find();
    final String role = myServices.sharedPreferences.getString("role")!;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        surfaceTintColor: AppColors.primaryColor,
        backgroundColor: AppColors.primaryColor,
        toolbarHeight: 67.0.h,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0.r),
                bottomRight: Radius.circular(20.0.r))),
        centerTitle: true,
        title: Text(
          "Feedbacks",
          style: TextStyle(
              fontFamily: 'Poppins',
              color: AppColors.whiteColor,
              fontSize: 24.0.sp,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: GetBuilder<FeedBacksControllerImpl>(builder: (_) {
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.0.w),
            child: Column(
              children: [
                SizedBox(
                  height: 8.0.h,
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.78,
                  child: Obx(() {
                    if (controller.isFeedBacksLoading.value) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ));
                    }

                    if (controller.feedbackList.isEmpty) {
                      return Center(
                          child: Text(
                        "No Feedbacks available.",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: AppColors.blackColor,
                            fontSize: 24.0.sp,
                            fontWeight: FontWeight.w500),
                      ));
                    }
                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.feedbackList.length,
                      itemBuilder: (context, index) {
                        final feedback = controller.feedbackList[index];
                        return FeedBackWidget(
                          name: feedback['name'],
                          message: feedback['message'],
                          time: feedback['timestamp'],
                        );
                      },
                      separatorBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                        child: const Divider(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ));
      }),
      bottomNavigationBar: role == "admin"
          ? Padding(
              padding: EdgeInsets.all(8.0.w),
              child: CustomBottomNavBar(index: 1),
            )
          : const SizedBox(),
    );
  }
}
