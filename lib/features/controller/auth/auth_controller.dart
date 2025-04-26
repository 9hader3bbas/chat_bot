import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chat_bot/core/constant/colors/colors.dart';
import 'package:chat_bot/core/constant/routes/routes.dart';
import 'package:chat_bot/core/services/log_service/log_service.dart';
import 'package:chat_bot/core/services/my_services/my_services.dart';
import 'package:chat_bot/features/controller/profile/profile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

abstract class AuthController extends GetxController {
  void showPassword();
  Future<void> storeUser(
      {required String userId,
      required String fullName,
      required String emailAddress,
      required String fcmToken});
  Future<dynamic> signUp();
  Future<dynamic> signIn();
  Future<dynamic> resetPassword();
}

class AuthControllerImpl extends AuthController {
  MyServices myServices = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var role = "".obs; // Stores the role (admin/user)
  var name = "".obs; // Stores the Name

  // Form Keys
  GlobalKey<FormState> signinKey = GlobalKey<FormState>();
  GlobalKey<FormState> signupKey = GlobalKey<FormState>();
  GlobalKey<FormState> forgetPasswordKey = GlobalKey<FormState>();

  // TextEditingControllers
  TextEditingController nameTEC = TextEditingController();
  TextEditingController emailAdressTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();

  // FocusNode
  FocusNode signUpFocusNode1 = FocusNode();
  FocusNode signUpFocusNode2 = FocusNode();
  FocusNode signUpFocusNode3 = FocusNode();
  FocusNode signInFocusNode1 = FocusNode();
  FocusNode signInFocusNode2 = FocusNode();

  // Booleans
  bool isShowPassword = true;
  bool isSignInLoading = false;
  bool isSignUpLoading = false;
  bool isResetPasswordLoading = false;

  @override
  void showPassword() {
    isShowPassword = isShowPassword == true ? false : true;
    update();
  }

  //Store User
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Future<void> storeUser(
      {required String userId,
      required String fullName,
      required String emailAddress,
      required String fcmToken}) async {
    DateTime timestamp = DateTime.now(); // Get current timestamp
    return users
        .add({
          'user_id': userId,
          'full_name': fullName,
          'email_address': emailAddress,
          'fcm_token': fcmToken,
          'created_at': timestamp,
          'updated_at': timestamp,
          'role': "user"
        })
        .then((value) => log("User Added"))
        .catchError((error) => log("Failed to add user: $error"));
  }

  // Sign Up
  @override
  Future<dynamic> signUp() async {
    if (signupKey.currentState!.validate()) {
      try {
        isSignUpLoading = true;
        update();
        // Get FCM token
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailAdressTEC.text.trim(),
          password: passwordTEC.text.trim(),
        )
            .then((value) async {
          await FirebaseAuth.instance.currentUser!.sendEmailVerification();
        }).then((value) async {
          await storeUser(
              userId: FirebaseAuth.instance.currentUser!.uid,
              fullName: nameTEC.text.trim(),
              emailAddress: emailAdressTEC.text.trim(),
              fcmToken: fcmToken ?? "");
          myServices.sharedPreferences.setString("name", nameTEC.text.trim());
          myServices.sharedPreferences
              .setString("user_id", FirebaseAuth.instance.currentUser!.uid);
          LogService.addLog(
              query: "Register",
              response:
                  "Register successfully , the verify link were sent to the user");
          isSignUpLoading = true;
          update();
        });

        return AwesomeDialog(
          context: Get.context!,
          dialogBackgroundColor: AppColors.whiteColor,
          dialogType: DialogType.info,
          animType: AnimType.scale,
          titleTextStyle: TextStyle(
              fontFamily: 'Poppins',
              color: AppColors.blackColor,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.bold),
          descTextStyle: TextStyle(
              fontFamily: 'Poppins',
              color: AppColors.blackColor,
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500),
          onDismissCallback: (value) {
            Get.offAllNamed(AppRoutes.signIn);
          },
          title: "Varify Account",
          desc:
              "Please check your inbox and varify your account using the link sent to you then you can login to your account",
        )..show();
      } on FirebaseAuthException catch (e) {
        isSignUpLoading = false;
        update();
        if (e.code == 'weak-password') {
          LogService.addLog(query: "Register", response: "Weak Password");
          return AwesomeDialog(
            context: Get.context!,
            dialogBackgroundColor: AppColors.whiteColor,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            titleTextStyle: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.blackColor,
                fontSize: 16.0.sp,
                fontWeight: FontWeight.bold),
            descTextStyle: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.blackColor,
                fontSize: 12.0.sp,
                fontWeight: FontWeight.w500),
            title: 'The password provided is too weak.',
            desc: 'Please Enter a strong password',
          )..show();
        } else if (e.code == 'email-already-in-use') {
          LogService.addLog(
              query: "Register",
              response:
                  "The Email(${emailAdressTEC.text.trim()}) already in use");
          return AwesomeDialog(
            context: Get.context!,
            dialogBackgroundColor: AppColors.whiteColor,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            titleTextStyle: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.blackColor,
                fontSize: 16.0.sp,
                fontWeight: FontWeight.bold),
            descTextStyle: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.blackColor,
                fontSize: 12.0.sp,
                fontWeight: FontWeight.w500),
            title: "The account already exists for that email",
            desc:
                "Please Enter a different email or reset your password using your current email",
          )..show();
        }
      } catch (e) {
        isSignUpLoading = false;
        update();
        log(e.toString());
      }
    }
  }

  // Sign In
  @override
  Future<dynamic> signIn() async {
    if (signinKey.currentState!.validate()) {
      try {
        isSignInLoading = true;
        update();

        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailAdressTEC.text, password: passwordTEC.text);

        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          String userId = userCredential.user!.uid;

          QuerySnapshot querySnapshot = await _firestore
              .collection("users")
              .where("user_id", isEqualTo: userId)
              .get();

          if (querySnapshot.docs.isEmpty) {
            throw Exception("User document not found.");
          }

          DocumentSnapshot userDoc = querySnapshot.docs.first;
          role.value = userDoc["role"] ?? "user";
          name.value = userDoc["full_name"] ?? "unknown user";
          print("ROLE IS ${role.value}");
          print("Name IS ${name.value}");
          isSignInLoading = true;
          update();
          myServices.sharedPreferences.setString("email", emailAdressTEC.text);
          myServices.sharedPreferences.setString("role", role.value);
          myServices.sharedPreferences.setString("name", name.value);
          myServices.sharedPreferences
              .setString("user_id", FirebaseAuth.instance.currentUser!.uid);
          myServices.sharedPreferences.setBool("isLoggedIn", true);
          log("Welcome to ChatBot Application :)");
          isSignInLoading = false;
          update();
          Get.offAllNamed(AppRoutes.home);
          LogService.addLog(query: "Login", response: "Login Successfully");
          Get.put(ProfileControllerImpl());
        } else {
          isSignInLoading = false;
          update();
          LogService.addLog(
              query: "Login",
              response:
                  "Not verified account , The verify link were sent to the user mail (${emailAdressTEC.text.trim()})");
          FirebaseAuth.instance.currentUser!.sendEmailVerification();
          return AwesomeDialog(
              context: Get.context!,
              dialogBackgroundColor: AppColors.whiteColor,
              dialogType: DialogType.error,
              animType: AnimType.scale,
              titleTextStyle: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.blackColor,
                  fontSize: 16.0.sp,
                  fontWeight: FontWeight.bold),
              descTextStyle: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.blackColor,
                  fontSize: 12.0.sp,
                  fontWeight: FontWeight.w500),
              title: "An error occurred",
              desc:
                  "Your account isn't verified please check your inbox and verify your account using the link sent to you then try login again",
              onDismissCallback: (value) {})
            ..show();
        }
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        log(fcmToken.toString());
      } on FirebaseAuthException catch (e) {
        isSignInLoading = false;
        update();
        if (e.code == 'invalid-credential') {
          return AwesomeDialog(
              context: Get.context!,
              dialogBackgroundColor: AppColors.whiteColor,
              dialogType: DialogType.error,
              animType: AnimType.scale,
              titleTextStyle: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.blackColor,
                  fontSize: 16.0.sp,
                  fontWeight: FontWeight.bold),
              descTextStyle: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.blackColor,
                  fontSize: 12.0.sp,
                  fontWeight: FontWeight.w500),
              title: "Invalid credential",
              desc: "Please check your email and password then try again",
              onDismissCallback: (value) {})
            ..show();
        }
        return AwesomeDialog(
            context: Get.context!,
            dialogBackgroundColor: AppColors.whiteColor,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            titleTextStyle: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.blackColor,
                fontSize: 16.0.sp,
                fontWeight: FontWeight.bold),
            descTextStyle: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.blackColor,
                fontSize: 12.0.sp,
                fontWeight: FontWeight.w500),
            title: "An error occurred",
            desc:
                "Something went wrong while processing your request Please check your internet and try again",
            onDismissCallback: (value) {})
          ..show();
      }
    }
  }

  // Forget Password
  @override
  Future<dynamic> resetPassword() async {
    if (forgetPasswordKey.currentState!.validate()) {
      try {
        isResetPasswordLoading = true;
        update();
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailAdressTEC.text);
        isResetPasswordLoading = false;
        update();
        LogService.addLog(
            query: "Request Password Reset link",
            response:
                "Password Reset Link was sent to the user mail (${emailAdressTEC.text.trim()})");
        return AwesomeDialog(
          context: Get.context!,
          dialogBackgroundColor: AppColors.whiteColor,
          dialogType: DialogType.success,
          animType: AnimType.scale,
          titleTextStyle: TextStyle(
              fontFamily: 'Poppins',
              color: AppColors.blackColor,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.bold),
          descTextStyle: TextStyle(
              fontFamily: 'Poppins',
              color: AppColors.blackColor,
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500),
          onDismissCallback: (value) {
            Get.offAllNamed(AppRoutes.signIn);
          },
          title: "The reset password link has been sent to your email",
          desc:
              "Please check your inbox and reset your password then try to login to your account again",
        )..show();
      } catch (err) {
        isResetPasswordLoading = false;
        update();
        return AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          titleTextStyle: TextStyle(
              fontFamily: 'Poppins',
              color: AppColors.blackColor,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.bold),
          descTextStyle: TextStyle(
              fontFamily: 'Poppins',
              color: AppColors.blackColor,
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500),
          title: "An error occurred",
          desc:
              "Something went wrong while processing your request Please check your internet and try again",
        )..show();
      }
    }
  }
}
