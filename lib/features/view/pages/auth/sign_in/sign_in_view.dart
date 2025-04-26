import 'package:chat_bot/core/constant/app_assets/app_assets.dart';
import 'package:chat_bot/core/constant/colors/colors.dart';
import 'package:chat_bot/core/constant/routes/routes.dart';
import 'package:chat_bot/core/shared/widgets/custom_button/custom_button.dart';
import 'package:chat_bot/core/shared/widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:chat_bot/features/controller/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignInView extends StatelessWidget {
  SignInView({super.key});
  AuthControllerImpl controller = Get.put(AuthControllerImpl());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthControllerImpl>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: null,
          body: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: Form(
              key: controller.signinKey,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 86.0.h, left: 46.0.w),
                      height: 200.0.h,
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25.0.r),
                              bottomRight: Radius.circular(25.0.r))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Login",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 30.0.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          SizedBox(
                            height: 4.0.h,
                          ),
                          Text(
                            "Login to your account.",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.whiteColor,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 60.0.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 46.0.w),
                          child: Column(
                            children: [
                              CustomTextFormField(
                                focusNode: controller.signInFocusNode1,
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).requestFocus(
                                      controller.signInFocusNode2);
                                },
                                hintText: "Email",
                                textEditingController:
                                    controller.emailAdressTEC,
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
                                  } else if (!regex
                                      .hasMatch(validate.toString())) {
                                    return "Please enter a valid Email Address !";
                                  }
                                  return null;
                                },
                                keyBoardType: TextInputType.emailAddress,
                                isSuffixed: false,
                                textDirection: TextDirection.ltr,
                                iconDataColor: const Color(0xFFF0F3F8),
                              ),
                              SizedBox(
                                height: 24.0.h,
                              ),
                              CustomTextFormField(
                                focusNode: controller.signInFocusNode2,
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).unfocus();
                                },
                                hintText: "Password",
                                textEditingController: controller.passwordTEC,
                                validation: (validate) {
                                  if (validate == "") {
                                    return "Password is required !";
                                  }
                                  return null;
                                },
                                obscureText: controller.isShowPassword,
                                keyBoardType: TextInputType.visiblePassword,
                                isSuffixed: true,
                                onTapSuffix: () => controller.showPassword(),
                              ),
                              SizedBox(
                                height: 24.0.h,
                              ),
                              CustomButton(
                                textButton: "Login",
                                colorText: AppColors.whiteColor,
                                colorButton: AppColors.secondaryColor,
                                onTapButton: () async {
                                  await controller.signIn();
                                },
                                isLoading: controller.isSignInLoading,
                              ),
                              SizedBox(
                                height: 16.0.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Don't have an account ?",
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: AppColors.blackColor
                                              .withOpacity(0.8),
                                          fontSize: 12.0.sp,
                                          fontWeight: FontWeight.w400)),
                                  SizedBox(
                                    width: 5.0.w,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.offNamed(AppRoutes.signUp);
                                    },
                                    borderRadius: BorderRadius.circular(5.0.r),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 0.7.w, vertical: 0.7.h),
                                      child: Text("Rigester",
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: AppColors.primaryColor,
                                              fontSize: 12.0.sp,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8.0.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Forget your password ?",
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: AppColors.blackColor
                                              .withOpacity(0.8),
                                          fontSize: 12.0.sp,
                                          fontWeight: FontWeight.w400)),
                                  SizedBox(
                                    width: 5.0.w,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.offNamed(AppRoutes.forgetPassword);
                                    },
                                    borderRadius: BorderRadius.circular(5.0.r),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 0.7.w, vertical: 0.7.h),
                                      child: Text("Forget Password",
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: AppColors.primaryColor,
                                              fontSize: 12.0.sp,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          AppAssets.handshakeImage,
                          height: 290.0.h,
                          width: 435.0.w,
                          fit: BoxFit.contain,
                          opacity: const AlwaysStoppedAnimation(0.6),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
