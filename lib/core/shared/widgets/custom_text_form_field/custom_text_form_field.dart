import 'package:chat_bot/core/constant/app_assets/app_assets.dart';
import 'package:chat_bot/core/constant/colors/colors.dart';
import 'package:chat_bot/core/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final bool isSuffixed;
  final String? prefixIcon;
  final Color? iconDataColor;
  final TextEditingController textEditingController;
  final String? Function(String?) validation;
  final void Function()? onTapSuffix;
  final bool? obscureText;
  final TextInputType keyBoardType;
  final TextDirection? textDirection;
  final FocusNode focusNode;
  final void Function(String)? onFieldSubmitted;
  final bool? enabled;
  final int? maxChars;

  const CustomTextFormField(
      {super.key,
      required this.hintText,
      required this.isSuffixed,
      this.prefixIcon,
      this.iconDataColor,
      required this.textEditingController,
      required this.validation,
      this.obscureText,
      this.onTapSuffix,
      required this.keyBoardType,
      this.textDirection,
      required this.focusNode,
      this.onFieldSubmitted,
      this.enabled,
      this.maxChars});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxChars,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      buildCounter: (context,
              {required currentLength,
              required isFocused,
              required maxLength}) =>
          null,
      enabled: enabled ?? true,
      controller: textEditingController,
      validator: validation,
      style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14.0.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF191919).withOpacity(0.80)),
      obscureText: obscureText == null || obscureText == false ? false : true,
      keyboardType: keyBoardType,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: TextInputAction.send,
      textDirection: textDirection,
      mouseCursor: WidgetStateMouseCursor.clickable,
      showCursor: true,
      cursorColor: AppColors.greyColor,
      cursorRadius: Radius.circular(AppConstant.appRadius),
      scrollPhysics: const BouncingScrollPhysics(),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.whiteColor,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(
            vertical: 16.0.h, horizontal: 16.0.w), // Adjusts text padding
        labelText: hintText,
        errorMaxLines: 2,

        errorStyle: TextStyle(
            fontFamily: 'Poppins',
            color: AppColors.redColor,
            fontSize: 12.0.sp,
            fontWeight: FontWeight.w500),
        hintStyle: TextStyle(
            fontFamily: 'Poppins',
            color: const Color(0xFFC8C8C8),
            fontSize: 14.0.sp,
            fontWeight: FontWeight.w500),
        labelStyle: TextStyle(
            fontFamily: 'Poppins',
            color: AppColors.primaryColor,
            fontSize: 14.0.sp,
            fontWeight: FontWeight.w400),
        floatingLabelStyle: TextStyle(
            fontFamily: 'Poppins',
            color: AppColors.primaryColor,
            fontSize: 18.0.sp,
            fontWeight: FontWeight.w500),
        suffixIcon: isSuffixed
            ? IconButton(
                onPressed: onTapSuffix,
                splashColor: AppColors.primaryColor,
                icon: obscureText ?? true
                    ? SvgPicture.asset(
                        AppAssets.openedEye,
                        fit: BoxFit.none,
                        colorFilter: const ColorFilter.mode(
                            AppColors.primaryColor, BlendMode.srcIn),
                      )
                    : SvgPicture.asset(
                        AppAssets.closedEye,
                        fit: BoxFit.none,
                        colorFilter: const ColorFilter.mode(
                            Color.fromRGBO(25, 25, 25, 0.9), BlendMode.srcIn),
                      ),
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0.r)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28.0.r),
          borderSide: BorderSide(
            width: 1.0,
            color: AppColors.secondaryColor.withOpacity(0.90),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28.0.r),
          borderSide: BorderSide(
            width: 1.0,
            color: AppColors.secondaryColor.withOpacity(0.90),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28.0.r),
          borderSide: BorderSide(
            width: AppConstant.appWidthThemeOne,
            color: AppColors.redColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28.0.r),
          borderSide: BorderSide(
            width: AppConstant.appWidthThemeOne,
            color: AppColors.redColor,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28.0.r),
          borderSide: BorderSide(
            width: 1.0,
            color: AppColors.secondaryColor.withOpacity(0.90),
          ),
        ),
      ),
    );
  }
}
