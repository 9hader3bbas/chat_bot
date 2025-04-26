import 'package:chat_bot/core/constant/colors/colors.dart';
import 'package:chat_bot/core/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  final String textButton;
  final Color colorText;
  final Color colorButton;
  final void Function() onTapButton;
  final bool isLoading;
  const CustomButton({
    super.key,
    required this.textButton,
    required this.colorText,
    required this.colorButton,
    required this.onTapButton,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(
        Radius.circular(30.0.r),
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
        decoration: BoxDecoration(
          color: colorButton,
          borderRadius: BorderRadius.all(
            Radius.circular(30.0.r),
          ),
        ),
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
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: colorText,
                      fontSize: AppConstant.fontSizeEighteen,
                      fontWeight: FontWeight.w500),
                ),
        ),
      ),
    );
  }
}
