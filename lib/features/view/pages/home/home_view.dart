import 'dart:developer';
import 'package:chat_bot/core/constant/app_assets/app_assets.dart';
import 'package:chat_bot/core/constant/colors/colors.dart';
import 'package:chat_bot/core/constant/routes/routes.dart';
import 'package:chat_bot/core/services/my_services/my_services.dart';
import 'package:chat_bot/core/shared/widgets/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:chat_bot/core/shared/widgets/chat_bubble/chat_bubble_widget.dart';
import 'package:chat_bot/core/shared/widgets/custom_mini_button/custom_mini_button.dart';
import 'package:chat_bot/features/controller/home/home_controller.dart';
import 'package:chat_bot/features/data/models/chat/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date formatting

class HomeView extends StatelessWidget {
  HomeView({super.key});
  HomeContollerImpl controller = Get.put(HomeContollerImpl());
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MyServices myServices = Get.find();
    final String role = myServices.sharedPreferences.getString("role")!;

    return GetBuilder<HomeContollerImpl>(builder: (_) {
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
          leading: role == "user"
              ? SizedBox(
                  height: 20.0.h,
                  width: 45.0.w,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 12.0.w, top: 12.0.h, bottom: 12.0.h),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.profile);
                      },
                      radius: 30.0.r,
                      borderRadius: BorderRadius.circular(30.0.r),
                      child: Image.asset(
                        AppAssets.userImage,
                        height: 20.0.h,
                        width: 45.0.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                )
              : null,
          centerTitle: true,
          title: Text(
            "CampusGuide",
            style: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.whiteColor,
                fontSize: 24.0.sp,
                fontWeight: FontWeight.w600),
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded,
                  color: AppColors.whiteColor),
              color: Colors.white,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(12.0.r)), // Rounded edges like your image
              ),
              splashRadius: 12.0.r,
              menuPadding: EdgeInsets.symmetric(horizontal: 0.0.w),
              onSelected: (value) {
                if (value == "New chat") {
                  log("New chat Selected");
                  _textEditingController.clear();
                  controller.startNewChat();
                } else if (value == "Leave feedback") {
                  log("Leave Feedback Selected");
                  controller.showAddFeedbackDialog();
                } else if (value == "Logout") {
                  log("Logout Selected");
                  controller.logout();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: "New chat",
                  child: Center(
                    child: Text("New chat",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: AppColors.blackColor.withOpacity(0.80),
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.w400)),
                  ),
                ),
                role == "user"
                    ? PopupMenuDivider(
                        height: 1.0.h,
                      )
                    : PopupMenuDivider(
                        height: 0.0.h,
                      ),
                role == "user"
                    ? PopupMenuItem<String>(
                        value: "Leave feedback",
                        child: Center(
                          child: Text("Leave feedback",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: AppColors.blackColor.withOpacity(0.80),
                                  fontSize: 16.0.sp,
                                  fontWeight: FontWeight.w400)),
                        ),
                      )
                    : PopupMenuDivider(
                        height: 0.0.h,
                      ),
                PopupMenuDivider(
                  height: 1.0.h,
                ),
                PopupMenuItem<String>(
                  value: "Logout",
                  child: Center(
                    child: Text("Logout",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: AppColors.blackColor.withOpacity(0.80),
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.w400)),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: GetBuilder<HomeContollerImpl>(
          // Wrap the chat UI with GetBuilder
          builder: (controller) {
            return SingleChildScrollView(
              child: SizedBox(
                height: role == "admin" && controller.currentQuestion == ""
                    ? MediaQuery.sizeOf(context).height * 0.80
                    : MediaQuery.sizeOf(context).height * 0.87,
                child: Column(
                  children: [
                    controller.messages.isEmpty
                        ? SizedBox(
                            height: 400.0.h,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 205.0.h,
                                ),
                                Text(
                                  "How can I help you",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: AppColors.primaryColor,
                                    fontSize: 20.0.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0.h,
                                ),
                                SizedBox(
                                  width: 250.0.w,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomMiniButton(
                                        colorButton: const Color(0xFF465C5C)
                                            .withOpacity(0.90),
                                        colorText: AppColors.whiteColor,
                                        textButton: "FAQ",
                                        onTapButton: () {
                                          controller.updateQuestion("FAQ");
                                          controller.sendMessage();
                                        },
                                        isLoading: false,
                                      ),
                                      CustomMiniButton(
                                        colorButton: const Color(0xFF465C5C)
                                            .withOpacity(0.90),
                                        colorText: AppColors.whiteColor,
                                        textButton: "Exam schedule",
                                        onTapButton: () {
                                          controller
                                              .updateQuestion("Exam schedule");
                                          controller.sendMessage();
                                        },
                                        isLoading: false,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0.h,
                                ),
                                SizedBox(
                                  width: 250.0.w,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomMiniButton(
                                        colorButton: const Color(0xFF465C5C)
                                            .withOpacity(0.90),
                                        colorText: AppColors.whiteColor,
                                        textButton: "Course details",
                                        onTapButton: () {
                                          controller
                                              .updateQuestion("Course details");
                                          controller.sendMessage();
                                        },
                                        isLoading: false,
                                      ),
                                      CustomMiniButton(
                                        colorButton: const Color(0xFF465C5C)
                                            .withOpacity(0.90),
                                        colorText: AppColors.whiteColor,
                                        textButton: "IT Club",
                                        onTapButton: () {
                                          controller.updateQuestion("IT Club");
                                          controller.sendMessage();
                                        },
                                        isLoading: false,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: controller.messages.length,
                        itemBuilder: (context, index) {
                          final message = controller.messages[index];
                          return ChatBubbleWidget(
                              message: message.text,
                              isUserMessage: message.isUser);
                        },
                      ),
                    ),
                    _buildInputField(),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: role == "admin" && controller.currentQuestion == ""
            ? Padding(
                padding: EdgeInsets.all(8.0.w),
                child: CustomBottomNavBar(index: 0),
              )
            : const SizedBox(),
      );
    });
  }

  Widget _buildInputField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.0.w, vertical: 5.0.h),
      child: Container(
        padding: EdgeInsets.zero,
        height: 35.0.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0.r),
            color: Colors.transparent,
            border: Border.all(color: AppColors.primaryColor, width: 1.0.w)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextFormField(
                controller: _textEditingController,
                onChanged: (value) {
                  controller.updateQuestion(value);
                },
                maxLines: 1,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.0.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.blackColor),
                scrollPhysics: const BouncingScrollPhysics(),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0.w),
                  hintText: 'Type here ...',
                  hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blackColor.withOpacity(0.8)),
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
            GetBuilder<HomeContollerImpl>(
              builder: (controller) {
                return controller.isBotTyping
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                        child: SizedBox(
                          width: 18.0.h,
                          height: 18.0.w,
                          child: const CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      )
                    : IconButton(
                        icon: SvgPicture.asset(
                          AppAssets.telegramIcon,
                          height: 22.0.h,
                          width: 22.0.w,
                          fit: BoxFit.cover,
                        ),
                        onPressed: () {
                          controller.sendMessage();
                          _textEditingController.clear();
                        },
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
