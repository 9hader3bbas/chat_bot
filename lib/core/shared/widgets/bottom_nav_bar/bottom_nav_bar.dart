import 'package:chat_bot/core/constant/colors/colors.dart';
import 'package:chat_bot/core/constant/routes/routes.dart';
import 'package:chat_bot/core/shared/extentions/extentions.dart';
import 'package:chat_bot/features/controller/bottom_nav_bar/bottom_nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomBottomNavBar extends StatelessWidget {
  CustomBottomNavBar({super.key, required this.index});
  final int index;
  final BottomNavBarControllerImpl controller =
      Get.put(BottomNavBarControllerImpl());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavBarControllerImpl>(
      builder: (_) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0.w),
          child: Container(
              height: 46.0.h,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackColor.withOpacity(0.15),
                    blurRadius: 22.0.r,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(
                    color: const Color(0xFF36B8B8).withOpacity(0.80)),
                borderRadius: BorderRadius.circular(16.0.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Get.offNamed(AppRoutes.home);
                      controller.update();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      height: MediaQuery.sizeOf(context).height * .060,
                      width: MediaQuery.sizeOf(context).width * .250,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        controller.pagesIcons[0],
                        width: 16.0.w,
                        colorFilter: 0 == index
                            ? const ColorFilter.mode(
                                AppColors.primaryColor,
                                BlendMode.srcIn,
                              )
                            : const ColorFilter.mode(
                                Color(0xFFB9C1CC),
                                BlendMode.srcIn,
                              ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.offNamed(AppRoutes.feedBacks);
                    },
                    child: Stack(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.fastLinearToSlowEaseIn,
                          height: MediaQuery.sizeOf(context).height * .060,
                          width: MediaQuery.sizeOf(context).width * .250,
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            controller.pagesIcons[1],
                            width: 20.0.w,
                            colorFilter: 1 == index
                                ? const ColorFilter.mode(
                                    AppColors.primaryColor,
                                    BlendMode.srcIn,
                                  )
                                : const ColorFilter.mode(
                                    Color(0xFFB9C1CC),
                                    BlendMode.srcIn,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.offNamed(AppRoutes.logs);
                      controller.update();
                    },
                    child: Stack(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.fastLinearToSlowEaseIn,
                          height: MediaQuery.sizeOf(context).height * .060,
                          width: MediaQuery.sizeOf(context).width * .250,
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            controller.pagesIcons[2],
                            width: 20.0.w,
                            colorFilter: 2 == index
                                ? const ColorFilter.mode(
                                    AppColors.primaryColor,
                                    BlendMode.srcIn,
                                  )
                                : const ColorFilter.mode(
                                    Color(0xFFB9C1CC),
                                    BlendMode.srcIn,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}
