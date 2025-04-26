import 'dart:developer';

import 'package:chat_bot/core/constant/app_assets/app_assets.dart';
import 'package:chat_bot/core/constant/colors/colors.dart';
import 'package:chat_bot/core/constant/constant.dart';
import 'package:chat_bot/features/controller/logs/logs_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LogWidget extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String logId;
  LogWidget({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    required this.logId,
  });
  final LogsControllerImpl controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75.0.h,
      width: 350.0.w,
      child: Row(
        children: [
          Container(
            height: 45.0.h,
            width: 45.0.w,
            padding: EdgeInsets.all(12.0.w),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.primaryColor),
            child: SvgPicture.asset(
              AppAssets.logIcon,
              height: 25.0.h,
              width: 25.0.w,
              fit: BoxFit.cover,
              colorFilter:
                  const ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn),
            ),
          ),
          SizedBox(
            width: 12.0.w,
          ),
          SizedBox(
            height: 56.0.h,
            width: 227.0.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: const Color(0xFF3D3D3D),
                      fontSize: AppConstant.fontSizeSixteen,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 8.0.h,
                ),
                Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: const Color(0xFF636363),
                      fontSize: AppConstant.fontSizeTwelve,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 5.0.w,
          ),
          SizedBox(
            height: 65.0.h,
            width: 55.0.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: AppColors.blackColor,
                      fontSize: 10.0.sp,
                      fontWeight: FontWeight.w500),
                ),
                InkWell(
                  onTap: () {
                    controller.deleteLog(logId);
                  },
                  child: Container(
                      height: 30.0.h,
                      width: 30.0.w,
                      padding: EdgeInsets.all(4.0.w),
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(4.0.r)),
                      child: SvgPicture.asset(
                        height: 24.0.h,
                        width: 24.0.w,
                        fit: BoxFit.cover,
                        AppAssets.deleteIcon,
                        colorFilter: const ColorFilter.mode(
                            AppColors.whiteColor, BlendMode.srcIn),
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
