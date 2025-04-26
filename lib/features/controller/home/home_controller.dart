import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chat_bot/core/constant/colors/colors.dart';
import 'package:chat_bot/core/constant/constant.dart';
import 'package:chat_bot/core/constant/routes/routes.dart';
import 'package:chat_bot/core/services/log_service/log_service.dart';
import 'package:chat_bot/core/services/my_services/my_services.dart';
import 'package:chat_bot/core/shared/widgets/custom_mini_button/custom_mini_button.dart';
import 'package:chat_bot/features/data/models/chat/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

abstract class HomeContoller extends GetxController {
  Future<void> logout();
  void startNewChat();
}

class HomeContollerImpl extends HomeContoller {
  TextEditingController feedBackTEC = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  MyServices myServices = Get.find();

  @override
  Future<void> logout() async {
    _isBotTyping = false;
    messages.clear();
    myServices.sharedPreferences.setBool("isLoggedIn", false);
    myServices.sharedPreferences.setString("name", "");
    myServices.sharedPreferences.setString("email", "");
    myServices.sharedPreferences.setString("user_id", "");
    myServices.sharedPreferences.setString("role", "");
    update();

    Get.offAllNamed(AppRoutes.signIn);
  }

  bool isFeedBackLoading = false;
  Future<void> showAddFeedbackDialog() async {
    await AwesomeDialog(
      context: Get.context!,
      dialogBackgroundColor: AppColors.whiteColor,
      dialogType: DialogType.noHeader,
      dialogBorderRadius: BorderRadius.circular(16.0.r),
      body: GetBuilder<HomeContollerImpl>(builder: (_) {
        return SizedBox(
          height: 190.0.h,
          width: 330.0.w,
          child: isFeedBackLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              : Column(
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
                      "What do you think of this app",
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
                        controller: feedBackTEC,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF191919).withOpacity(0.80)),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.send,
                        textDirection: TextDirection.ltr,
                        showCursor: true,
                        cursorColor: AppColors.greyColor,
                        cursorRadius: Radius.circular(AppConstant.appRadius),
                        scrollPhysics: const BouncingScrollPhysics(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.whiteColor,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.0.w,
                              vertical: 4.0.h), // Adjusts text padding
                          hintText: "Type here ...",
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
                      height: 26.0.h,
                    ),
                    SizedBox(
                      width: 250.0.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomMiniButton(
                              textButton: "Send",
                              colorText: AppColors.whiteColor,
                              colorButton: const Color(0xDD465C5C),
                              onTapButton: () {
                                feedBackTEC.text.trim().isNotEmpty
                                    ? addFeedBack()
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

  Future<void> addFeedBack() async {
    isFeedBackLoading = true;
    update();
    try {
      User? user = _auth.currentUser; // Get the currently logged-in user
      if (user == null) {
        throw Exception("User not logged in");
      }
      String name = myServices.sharedPreferences.getString("name")!;
      DocumentReference docRef =
          await _firestore.collection("users_feedbacks").add({
        'name': name,
        "userId": user.uid, // Store user ID
        "message": feedBackTEC.text.trim(),
        "timestamp": FieldValue.serverTimestamp(), // Auto-generate timestamp
      });
      isFeedBackLoading = false;
      feedBackTEC.clear();
      update();
      LogService.addLog(
          query: "New Feedback",
          response: "User start add new feedback with the id (${docRef.id})");
      Get.back();
      Get.snackbar("Thank You", "Your feedback helps us improve !",
          titleText: Text(
            "Thank You",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 14.0.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.whiteColor,
            ),
          ),
          messageText: Text(
            "Your feedback helps us improve !",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.whiteColor,
            ),
          ));
    } catch (e) {
      isFeedBackLoading = false;
      update();
      print("Error submitting feedback: $e");
    }
  }

  List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatMessage> get messages => _messages;
  String _currentQuestion = '';
  String get currentQuestion => _currentQuestion;
  bool _isBotTyping = false;
  bool get isBotTyping => _isBotTyping;
  final String chatBotUrl =
      'https://chatbot1-426859956024.us-central1.run.app/chat/?query=';

  void updateQuestion(String question) {
    _currentQuestion = question;
    update();
  }

  Future<void> sendMessage() async {
    if (_currentQuestion.trim().isNotEmpty) {
      if (messages.isEmpty) {
        LogService.addLog(
            query: "New Conversation",
            response: "User start a new Conversation with the chat bot");
      }
      final userMessage = ChatMessage(
        text: _currentQuestion.trim(),
        isUser: true,
        timestamp: DateTime.now(),
      );
      _messages.insert(
          0, userMessage); // Insert at the beginning for reverse list
      _currentQuestion = '';
      _isBotTyping = true;
      update(); // Trigger UI update

      try {
        final response = await http
            .get(Uri.parse('$chatBotUrl${userMessage.text}'), headers: {
          'Content-Type': 'application/json', // Example header
        });

        if (response.statusCode == 200) {
          try {
            final Map<dynamic, dynamic> decodedResponse =
                jsonDecode(utf8.decode(response.bodyBytes));
            if (decodedResponse.containsKey("response")) {
              final String botResponseText = decodedResponse["response"];
              final botResponse = ChatMessage(
                text: botResponseText,
                isUser: false,
                timestamp: DateTime.now(),
              );
              _messages.insert(0, botResponse);
            } else {
              // Handle the case where the "response" key is missing
              _messages.insert(
                  0,
                  ChatMessage(
                    text: "Error: Unexpected response format from chatbot.",
                    isUser: false,
                    timestamp: DateTime.now(),
                    isError: true,
                  ));
              print("Error: 'response' key missing in chatbot response.");
            }
          } catch (e) {
            // Handle errors during JSON decoding
            _messages.insert(
                0,
                ChatMessage(
                  text: "Error: Could not parse chatbot response.",
                  isUser: false,
                  timestamp: DateTime.now(),
                  isError: true,
                ));
            print("Error decoding chatbot response: $e");
            print(
                "Raw response body: ${response.body}"); // Log the raw body for debugging
          }
        } else {
          final errorMessage =
              'Failed to get response from chatbot. Status code: ${response.statusCode}';
          _messages.insert(
              0,
              ChatMessage(
                text: errorMessage,
                isUser: false,
                timestamp: DateTime.now(),
                isError: true,
              ));
          print(errorMessage);
        }
      } catch (e) {
        final errorMessage = 'Error communicating with the chatbot: $e';
        _messages.insert(
            0,
            ChatMessage(
              text: errorMessage,
              isUser: false,
              timestamp: DateTime.now(),
              isError: true,
            ));
        print(errorMessage);
      } finally {
        _isBotTyping = false;
        update(); // Trigger UI update
      }
    }
  }

  @override
  void startNewChat() {
    _currentQuestion = "";
    messages.clear();
    update();
  }
}
