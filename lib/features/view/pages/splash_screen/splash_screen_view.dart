import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chat_bot/core/constant/routes/routes.dart';
import 'package:chat_bot/core/services/my_services/my_services.dart';
import 'package:chat_bot/features/controller/splash_screen/splash_screen_controller.dart';
import 'package:chat_bot/features/view/pages/auth/sign_in/sign_in_view.dart';
import 'package:chat_bot/features/view/pages/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import '../../../../core/constant/colors/colors.dart';

class SplashScreenView extends StatelessWidget {
  SplashScreenView({super.key});
  final SplashScreenControllerImpl controller =
      Get.put(SplashScreenControllerImpl());

  @override
  Widget build(BuildContext context) {
    MyServices myServices = Get.find();
    bool? isLoggedIn = myServices.sharedPreferences.getBool("isLoggedIn");
    return GetBuilder<SplashScreenControllerImpl>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          surfaceTintColor: AppColors.whiteColor,
          toolbarHeight: 0.0,
        ),
        backgroundColor: AppColors.whiteColor,
        body: Center(
          child: AnimatedSplashScreen(
            backgroundColor: AppColors.whiteColor,
            //splashIconSize: 150,
            splash: Text.rich(TextSpan(
                text: "Campus",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 40.0.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                children: [
                  TextSpan(
                      text: "Guide",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 40.0.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryColor,
                      ))
                ])),
            nextRoute: isLoggedIn ?? false ? AppRoutes.home : AppRoutes.signIn,
            nextScreen: isLoggedIn ?? false ? HomeView() : SignInView(),
            animationDuration: 1.seconds,
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.fade,
          ),
        ),
      );
    });
  }
}
