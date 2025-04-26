import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chat_bot/core/constant/app_assets/app_assets.dart';
import 'package:chat_bot/core/constant/colors/colors.dart';
import 'package:chat_bot/core/constant/constant.dart';
import 'package:chat_bot/core/constant/routes/routes.dart';
import 'package:chat_bot/core/services/log_service/log_service.dart';
import 'package:chat_bot/core/services/my_services/my_services.dart';
import 'package:chat_bot/core/shared/widgets/custom_mini_button/custom_mini_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

abstract class ProfileController extends GetxController {
  Future<void> fetchUserData();
}

class ProfileControllerImpl extends ProfileController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MyServices _myServices = Get.find();

  GlobalKey<FormState> forgetPasswordKey = GlobalKey<FormState>();
  GlobalKey<FormState> editProfileKey = GlobalKey<FormState>();

  // TextEditingControllers
  TextEditingController nameTEC = TextEditingController();
  TextEditingController emailAdressTEC = TextEditingController();
  TextEditingController oldPasswordTEC = TextEditingController();
  TextEditingController newPasswordTEC = TextEditingController();

  // FocusNode
  FocusNode viewProfileFocusNode1 = FocusNode();
  FocusNode viewProfileFocusNode2 = FocusNode();
  FocusNode editProfileFocusNode1 = FocusNode();
  FocusNode editProfileFocusNode2 = FocusNode();
  FocusNode editProfileFocusNode3 = FocusNode();
  FocusNode editProfileFocusNode4 = FocusNode();

  //FireStore Initialize
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isfetchUserDataLoading = false;
  bool isfetchUserDataError = false;

  //Fetch User Data
  @override
  Future<void> fetchUserData() async {
    String userId = _myServices.sharedPreferences.getString("user_id")!;
    log(userId);
    try {
      isfetchUserDataLoading = true;
      update();
      QuerySnapshot userSnapshot = await firestore
          .collection('users')
          .where('user_id', isEqualTo: userId)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        // Retrieve the first document from the snapshot
        DocumentSnapshot userDoc = userSnapshot.docs.first;
        nameTEC.text = userDoc['full_name'];
        emailAdressTEC.text = userDoc['email_address'];
        log('User data: ${userDoc.data()}');
        log('userDoc Email ${userDoc['email_address']}');
        isfetchUserDataLoading = false;
        update();
      } else {
        isfetchUserDataLoading = false;
        isfetchUserDataError = true;
        update();
        log('User not found');
      }
    } catch (e) {
      isfetchUserDataLoading = false;
      isfetchUserDataError = true;
      update();
      print("Error fetching user data: $e");
    }
  }

  bool isShowOldPassword = true;
  bool isShowNewPassword = true;

  @override
  void showOldPassword() {
    isShowOldPassword = isShowOldPassword == true ? false : true;
    update();
  }

  @override
  void showNewPassword() {
    isShowNewPassword = isShowNewPassword == true ? false : true;
    update();
  }

  bool isDeleteAccountLoading = false;
  Future<void> showDeleteConfirmDialog() async {
    await AwesomeDialog(
      context: Get.context!,
      dialogBackgroundColor: AppColors.whiteColor,
      dialogType: DialogType.noHeader,
      dialogBorderRadius: BorderRadius.circular(16.0.r),
      body: GetBuilder<ProfileControllerImpl>(builder: (_) {
        return SizedBox(
          height: 170.0.h,
          width: 310.0.w,
          child: isDeleteAccountLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              color: AppColors.primaryColor,
                            ))
                      ],
                    ),
                    Text(
                      "Are you sure ? Please re enter the Password",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.blackColor),
                    ),
                    SizedBox(
                      height: 17.0.h,
                    ),
                    SizedBox(
                      height: 30.0.h,
                      width: 250.0.w,
                      child: TextFormField(
                        controller: oldPasswordTEC,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF191919).withOpacity(0.80)),
                        textInputAction: TextInputAction.send,
                        textDirection: TextDirection.ltr,
                        showCursor: true,
                        cursorColor: AppColors.greyColor,
                        cursorRadius: Radius.circular(AppConstant.appRadius),
                        scrollPhysics: const BouncingScrollPhysics(),
                        validator: (validate) {
                          if (validate == "") {
                            return "Password is required !";
                          }
                          return null;
                        },
                        obscureText: isShowOldPassword,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.whiteColor,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.0.w,
                              vertical: 4.0.h), // Adjusts text padding
                          hintText: "Password",
                          suffixIcon: SizedBox(
                            height: 20.0.h,
                            width: 20.0.w,
                            child: IconButton(
                              onPressed: () => showOldPassword(),
                              splashColor: AppColors.primaryColor,
                              icon: isShowOldPassword
                                  ? SvgPicture.asset(
                                      AppAssets.openedEye,
                                      fit: BoxFit.none,
                                      colorFilter: const ColorFilter.mode(
                                          AppColors.primaryColor,
                                          BlendMode.srcIn),
                                    )
                                  : SvgPicture.asset(
                                      AppAssets.closedEye,
                                      fit: BoxFit.none,
                                      colorFilter: const ColorFilter.mode(
                                          Color.fromRGBO(25, 25, 25, 0.9),
                                          BlendMode.srcIn),
                                    ),
                            ),
                          ),

                          hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              color: const Color(0xFFC8C8C8),
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w500),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0.r)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0.r),
                            borderSide: BorderSide(
                              width: 1.0.w,
                              color: const Color(0xFFCBD2E0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0.r),
                            borderSide: BorderSide(
                              width: 1.0,
                              color: AppColors.secondaryColor.withOpacity(0.90),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60.0.h,
                      width: 250.0.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomMiniButton(
                              textButton: "No",
                              colorText: AppColors.primaryColor,
                              colorButton: Colors.transparent,
                              borderColor: AppColors.primaryColor,
                              onTapButton: () {
                                Get.back();
                              },
                              isLoading: false),
                          CustomMiniButton(
                              textButton: "Yes",
                              colorText: AppColors.whiteColor,
                              colorButton: const Color(0xDD465C5C),
                              onTapButton: () async {
                                oldPasswordTEC.text.trim().isNotEmpty
                                    ? await deleteUserAccount()
                                    : ();
                              },
                              isLoading: false),
                        ],
                      ),
                    )
                  ],
                ),
        );
      }),
    ).show();
  }

  Future<void> deleteUserAccount() async {
    try {
      isDeleteAccountLoading = true;
      update();
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("No user is currently logged in.");
      }

      // 🔹 Get user's email for re-authentication
      String email = user.email ?? "";
      AuthCredential credential = EmailAuthProvider.credential(
          email: email, password: oldPasswordTEC.text.trim());

      // 1- Re-authenticate user
      await user.reauthenticateWithCredential(credential);

      // 2- Delete user document from Firestore
// 🔹 Query Firestore to find the document where user_id == current user ID
      QuerySnapshot querySnapshot = await _firestore
          .collection("users") // Change this to the actual collection name
          .where("user_id", isEqualTo: user.uid)
          .get();

      // 🔹 If the document exists, delete it
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await _firestore.collection("users").doc(doc.id).delete();
      }

      // 3- Delete user authentication account
      await user.delete();
      // Add log for the delete profile
      LogService.addLog(
          query: "Delete Profile", response: "User delete his profile");
      // 4- Sign out the user
      await _auth.signOut();

      // 5- Sign out the user and clear the Shared Prefrences data
      _myServices.sharedPreferences.setString("name", "");
      _myServices.sharedPreferences.setString("email", "");
      _myServices.sharedPreferences.setString("user_id", "");
      _myServices.sharedPreferences.setBool("isLoggedIn", false);
      _myServices.sharedPreferences.clear();
      isDeleteAccountLoading = false;
      update();
      Get.appUpdate();
      //  Show success message
      Get.snackbar(
          "Account Deleted", "Your account has been permanently deleted.",
          titleText: Text(
            "Account Deleted",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 14.0.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.whiteColor,
            ),
          ),
          messageText: Text(
            "Your account has been permanently deleted.",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.whiteColor,
            ),
          ));
      // 🚀 Navigate to login screen
      Get.offAllNamed(AppRoutes.signIn);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      isDeleteAccountLoading = false;
      update();
      print("Error deleting account: $e");
      if (e.code == "invalid-credential") {
        Get.snackbar("Error", "Incorrect password. Please try again",
            titleText: Text(
              "Error",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14.0.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.whiteColor,
              ),
            ),
            messageText: Text(
              "Incorrect password. Please try again",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 12.0.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.whiteColor,
              ),
            ),
            backgroundColor: AppColors.redColor.withOpacity(0.25));
      } else {
        Get.snackbar("Error", "Failed to delete account. Please try again.",
            titleText: Text(
              "Error",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14.0.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.whiteColor,
              ),
            ),
            messageText: Text(
              "Failed to delete account. Please try again.",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 12.0.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.whiteColor,
              ),
            ));
      }
    }
  }

  /// 🔹 Update user profile (name & password)
  Future<void> updateUserProfile() async {
    if (editProfileKey.currentState!.validate()) {
      try {
        User? user = _auth.currentUser;
        if (user == null) {
          throw Exception("No user is currently logged in.");
        }

        String userId = user.uid;

        // 🔹 Query Firestore to find the document where user_id == current user ID
        QuerySnapshot querySnapshot = await _firestore
            .collection("users") // Replace with your actual collection name
            .where("user_id", isEqualTo: userId)
            .get();

        if (querySnapshot.docs.isEmpty) {
          throw Exception("User document not found.");
        }

        // 🔹 Get the first document (assuming one document per user)
        DocumentReference userDocRef = querySnapshot.docs.first.reference;

        DateTime timestamp = DateTime.now(); // Get current timestamp

        // 🔹 Prepare the update data
        Map<String, dynamic> updateData = {
          "full_name": nameTEC.text.trim(),
          'updated_at': timestamp,
        };

        // 🔹 If a new password is provided, re-authenticate & update password
        if (newPasswordTEC.text.trim() != null &&
            newPasswordTEC.text.trim().isNotEmpty) {
          if (oldPasswordTEC.text.trim() == null ||
              oldPasswordTEC.text.trim().isEmpty) {
            throw FirebaseAuthException(
                code: "missing-old-password",
                message: "Please enter your old password.");
          }

          // Re-authenticate the user before changing the password
          AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!,
            password: oldPasswordTEC.text.trim(),
          );

          await user.reauthenticateWithCredential(credential);
          await user.updatePassword(newPasswordTEC.text.trim());
        }

        // 🔹 Update Firestore document
        await userDocRef.update(updateData);

        // ✅ Show success message
        Get.snackbar(
          "Profile Updated",
          "Your changes have been saved successfully.",
          titleText: Text(
            "Profile Updated",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 14.0.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.whiteColor,
            ),
          ),
          messageText: Text(
            "Your changes have been saved successfully.",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.whiteColor,
            ),
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.25),
        );
        LogService.addLog(
            query: "Update Profile", response: "User update his profile");
      } on FirebaseAuthException catch (e) {
        String errorMessage = "Failed to update profile.";
        if (e.code == "wrong-password") {
          errorMessage = "Incorrect old password.";
        } else if (e.code == "missing-old-password") {
          errorMessage = e.message ?? errorMessage;
        }

        Get.snackbar("Error", errorMessage,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            titleText: Text(
              "Error",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14.0.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.whiteColor,
              ),
            ),
            messageText: Text(
              errorMessage,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 12.0.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.whiteColor,
              ),
            ));
      } catch (e) {
        print("Error updating profile: $e");

        Get.snackbar(
          "Error",
          "Something went wrong. Please try again.",
          titleText: Text(
            "Error",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 14.0.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.whiteColor,
            ),
          ),
          messageText: Text(
            "Something went wrong. Please try again.",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.whiteColor,
            ),
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.redColor.withOpacity(0.25),
        );
      }
    }
  }

  @override
  void onInit() {
    fetchUserData();
    super.onInit();
  }
}
