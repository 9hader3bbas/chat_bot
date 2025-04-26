import 'package:chat_bot/features/view/pages/feed_backs/feed_backs_view.dart';
import 'package:chat_bot/features/view/pages/logs/logs_view.dart';
import 'package:chat_bot/features/view/pages/profile/edit_profile/edit_profile_view.dart';
import 'package:chat_bot/features/view/pages/profile/profile_view.dart';
import 'package:chat_bot/features/view/pages/auth/forget_password/forget_password_view.dart';
import 'package:chat_bot/features/view/pages/auth/sign_in/sign_in_view.dart';
import 'package:chat_bot/features/view/pages/auth/sign_up/sign_up_view.dart';
import 'package:chat_bot/features/view/pages/home/home_view.dart';
import 'package:chat_bot/features/view/pages/splash_screen/splash_screen_view.dart';
import 'package:get/get.dart';

import '../core/constant/routes/routes.dart';

List<GetPage<dynamic>>? routes = [
  //Splash
  GetPage(
      name: AppRoutes.splashScreen,
      page: () {
        return SplashScreenView();
      }),
  //Sign In
  GetPage(
      name: AppRoutes.signIn,
      page: () {
        return SignInView();
      }),
  //Sign Up
  GetPage(
      name: AppRoutes.signUp,
      page: () {
        return SignUpView();
      }),
  //Forget Password
  GetPage(
      name: AppRoutes.forgetPassword,
      page: () {
        return ForgetPasswordView();
      }),
  //Home
  GetPage(
      name: AppRoutes.home,
      page: () {
        return HomeView();
      }),
  //FeedBack
  GetPage(
      name: AppRoutes.feedBacks,
      page: () {
        return FeedBacksView();
      }),
  //LogsView
  GetPage(
      name: AppRoutes.logs,
      page: () {
        return LogsView();
      }),
  //Profile
  GetPage(
      name: AppRoutes.profile,
      page: () {
        return ProfileView();
      }),
  //Edit Profile
  GetPage(
      name: AppRoutes.editProfile,
      page: () {
        return EditProfileView();
      })
];
