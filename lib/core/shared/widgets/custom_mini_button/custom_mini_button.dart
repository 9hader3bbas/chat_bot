import 'package:chat_bot/core/constant/colors/colors.dart';
import 'package:chat_bot/core/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomMiniButton extends StatelessWidget {
  final String textButton;
  final Color colorText;
  final Color colorButton;
  final Color? borderColor;
  final void Function() onTapButton;
  final bool isLoading;
  const CustomMiniButton({
    super.key,
    required this.textButton,
    required this.colorText,
    required this.colorButton,
    this.borderColor,
    required this.onTapButton,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28.0.h,
      width: 114.0.w,
      child: InkWell(
        borderRadius: BorderRadius.circular(
          30.0.r,
        ),
        highlightColor: null,
        splashColor: null,
        splashFactory: InkSplash.splashFactory,
        radius: 30.0.r,
        onTap: onTapButton,
        child: AnimatedContainer(
          duration: 1000.milliseconds,
          curve: Curves.fastLinearToSlowEaseIn,
          height: 50.h,
          width: 300.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: colorButton,
              borderRadius: BorderRadius.circular(30.0.r),
              border:
                  borderColor != null ? Border.all(color: borderColor!) : null),
          child: Center(
            child: isLoading
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0.h),
                    child: CircularProgressIndicator(
                      color: colorText,
                    ),
                  )
                : Text(
                    textButton,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: colorText,
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.w500),
                  ),
          ),
        ),
      ),
    );
  }
}
