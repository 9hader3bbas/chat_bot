import 'dart:developer';

import 'package:chat_bot/core/constant/app_assets/app_assets.dart';
import 'package:chat_bot/core/constant/colors/colors.dart';
import 'package:chat_bot/core/constant/routes/routes.dart';
import 'package:chat_bot/core/shared/widgets/custom_button/custom_button.dart';
import 'package:chat_bot/core/shared/widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:chat_bot/features/controller/profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditProfileView extends StatelessWidget {
  EditProfileView({super.key});
  ProfileControllerImpl controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileControllerImpl>(builder: (controller) {
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
          title: Text(
            "Edit Profile",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18.0.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.whiteColor,
            ),
          ),
          automaticallyImplyLeading: false,
          leadingWidth: 25.0.w,
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.whiteColor,
              )),
        ),
        body: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Form(
              key: controller.editProfileKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 46.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10.0.h,
                        ),
                        SizedBox(
                          height: 88.0.h,
                          width: 88.0.w,
                          child: Image.asset(AppAssets.userColoredImage),
                        ),
                        SizedBox(
                          height: 24.0.h,
                        ),
                        CustomTextFormField(
                          focusNode: controller.editProfileFocusNode1,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(controller.editProfileFocusNode3);
                          },
                          hintText: "Name",
                          textEditingController: controller.nameTEC,
                          validation: (validate) {
                            if (validate == "") {
                              return "Name is required !";
                            }
                            return null;
                          },
                          keyBoardType: TextInputType.text,
                          isSuffixed: false,
                          textDirection: TextDirection.ltr,
                          iconDataColor: const Color(0xFFF0F3F8),
                        ),
                        SizedBox(
                          height: 24.0.h,
                        ),
                        CustomTextFormField(
                          focusNode: controller.editProfileFocusNode2,
                          hintText: "Email",
                          textEditingController: controller.emailAdressTEC,
                          validation: (validate) {
                            const pattern =
                                r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                                r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                                r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                                r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                                r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                                r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                                r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
                            final regex = RegExp(pattern);
                            if (validate == "") {
                              return "Email Address is required !";
                            } else if (!regex.hasMatch(validate.toString())) {
                              return "Please enter a valid Email Address !";
                            }
                            return null;
                          },
                          keyBoardType: TextInputType.emailAddress,
                          isSuffixed: false,
                          textDirection: TextDirection.ltr,
                          iconDataColor: const Color(0xFFF0F3F8),
                          enabled: false,
                        ),
                        SizedBox(
                          height: 24.0.h,
                        ),
                        CustomTextFormField(
                          focusNode: controller.editProfileFocusNode3,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(controller.editProfileFocusNode4);
                          },
                          hintText: "Old Password",
                          textEditingController: controller.oldPasswordTEC,
                          validation: (validate) {
                            if (validate == "") {
                              return "Old Password is required !";
                            }
                            return null;
                          },
                          obscureText: controller.isShowOldPassword,
                          keyBoardType: TextInputType.visiblePassword,
                          isSuffixed: true,
                          onTapSuffix: () => controller.showOldPassword(),
                        ),
                        SizedBox(
                          height: 24.0.h,
                        ),
                        CustomTextFormField(
                          focusNode: controller.editProfileFocusNode4,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).unfocus();
                          },
                          hintText: "New Password",
                          textEditingController: controller.newPasswordTEC,
                          validation: (validate) {
                            if (validate == "") {
                              return "New Password is required !";
                            }
                            return null;
                          },
                          obscureText: controller.isShowNewPassword,
                          keyBoardType: TextInputType.visiblePassword,
                          isSuffixed: true,
                          onTapSuffix: () => controller.showNewPassword(),
                        ),
                        SizedBox(
                          height: 24.0.h,
                        ),
                        CustomButton(
                          textButton: "Save Changes",
                          colorText: AppColors.whiteColor,
                          colorButton: AppColors.secondaryColor,
                          onTapButton: () async {
                            await controller.updateUserProfile();
                          },
                          isLoading: false,
                        ),
                        SizedBox(
                          height: 16.0.h,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
